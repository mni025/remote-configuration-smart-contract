long RSA_Own_Public_Key[2] = {55, 7};
long RSA_Own_Private_Key[2] = {55, 3};
const int MOST_NO_OF_DIGITS = 10;

#include "rsa.h"
#include "aes.h"
#include <string.h>

#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
//switching the above two lines gives override error: Multiple libraries were found for "WiFiClient.h"
#include <ArduinoJson.h>
#include <OneWire.h>
#include <DallasTemperature.h>

int port = 8888;  //Port number
WiFiServer server(port);

//Older OneWire libraries may cause errors
// ESP8266 ESP-01 GPIO2 make sure this is correct for your ESP8266 version
// Data wire is plugged into pin 3 on the Arduino
#define ONE_WIRE_BUS 2

// Setup a oneWire instance to communicate with any OneWire devices (not just Maxim/Dallas temperature ICs)
OneWire oneWire(ONE_WIRE_BUS);

// Pass our oneWire reference to Dallas Temperature. 
DallasTemperature DS18B20(&oneWire);
int temperatureF;
int temperatureC;
int counter;
int currentTemperature;

const char* ssid     = "mywifi";         // The SSID (name) of the Wi-Fi network you want to connect to
const char* password = "scooter";     // The password of the Wi-Fi network

void setup() {
  counter = 0;
  //ESP8266 ESP-01 GPIO0
  //green 5mm LED attached to GPIO0
  pinMode(0, OUTPUT);
  pinMode(4, OUTPUT);
  
  Serial.print("Serial connection beginning...");
  Serial.begin(115200); //Serial connection
  DS18B20.begin();
  WiFi.begin(ssid, password);   //WiFi connection
  Serial.print("WiFi connection began...");
 
  while (WiFi.status() != WL_CONNECTED) {  //Wait for the WiFI connection completion 
    delay(500);
    Serial.println("Waiting for connection");
  }
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  server.begin();
  Serial.print("Open Telnet and connect to IP:");
  Serial.print(WiFi.localIP());
  Serial.print(" on port ");
  Serial.println(port);
}

void getTemperature() {
  float tempC;
  float tempF;
  do {
    DS18B20.requestTemperatures(); 
    tempC = DS18B20.getTempCByIndex(0);
    temperatureC = tempC;
    tempF = DS18B20.getTempFByIndex(0);
    temperatureF = tempF;
    delay(100);
  } while (tempC == 85.0 || tempC == (-127.0));
}


String callGeth(String inputJSON)
{
  HTTPClient http;    //Declare object of class HTTPClient
 
    http.begin("http://192.168.0.12:8545/");      //TRAILING SLASH AT END REQUIRED!!!
    http.addHeader("Content-Type", "application/json");  //Specify content-type header
 
    int httpCode = http.POST(inputJSON);   //Send the request and get http Code
    String JSONResult = http.getString();  //Get the response from Geth JSONRPC
    
    http.end();
    return JSONResult;
}

 
void loop() {
  counter++;
  if (WiFi.status() == WL_CONNECTED) { //Check WiFi connection status

    StaticJsonBuffer<1000> JSONbuffer;   //Declaring static JSON buffer and set high value maybe 500 per call
    
    JsonObject& gethQueryJSON = JSONbuffer.createObject(); 
    gethQueryJSON["jsonrpc"] = "2.0";
    gethQueryJSON["method"] = "eth_call";
    JsonArray&  gethQueryParams = gethQueryJSON.createNestedArray("params");
    
    //***************************** first call to geth RPC function ****************************
    JsonObject& gethCallParams = JSONbuffer.createObject();
    gethCallParams["to"] = "0x4Cd8304Aa0e8B304CAc6EbCA95B92DdCF6437638";
    gethCallParams["data"] = "0x9de4d683";
    gethQueryParams.add(gethCallParams);
    gethQueryParams.add("latest");
    gethQueryJSON["id"] = 1;
 
    String gethStringJSON;
    gethQueryJSON.printTo(gethStringJSON);

    Serial.println("First Geth query JSON message isLightTurnedOn function: ");
    Serial.println(gethStringJSON);
     
    String gethResult = callGeth(gethStringJSON);  //Get the response from Geth JSONRPC
    JsonObject& gethJSONRPC = JSONbuffer.parseObject(gethResult);
    String lightOnString = gethJSONRPC["result"];
    lightOnString.remove(0,2);

    String lightOnString1 = lightOnString.substring(0,64);
    String lightOnString2 = lightOnString.substring(64,128);
      
    //parsing & converting Geth JSON-RPC hex results is not easy
    long int lightOn = strtol(lightOnString1.c_str(), NULL, 16);
    long int lightOnPeriod = strtol(lightOnString2.c_str(), NULL, 16);

    Serial.println("Geth JSON-RPC response: ");
    Serial.println(gethResult);    //Print request response payload
    Serial.println("Hex function input: ");
    Serial.println(lightOnString1);
    Serial.println("Function result: ");
    Serial.println(lightOn);
    Serial.println("Function result for time period: ");
    Serial.println(lightOnPeriod);
    
    long *plainText_encrypted = &lightOn;
    long plainText_encrypted_val = *plainText_encrypted;
    Serial.println("plaintext_encrypted:");
    Serial.println(plainText_encrypted_val);
    long *plainText_recovered;
    plainText_recovered = rsa_decrypt(plainText_encrypted, RSA_Own_Private_Key, 1);
    long plainText_recovered_val = *plainText_recovered;
    Serial.println("plaintext_recovered:");
    Serial.println(plainText_recovered_val);
  
    //***************************** second call to geth RPC function ****************************
    gethCallParams["data"] = "0x455f1a4c";
    String tempQuery;
    gethQueryJSON.printTo(tempQuery);
    Serial.println("Second Geth query JSON message isTempCurrent function: ");
    Serial.println(tempQuery);

    String tempStatus = callGeth(tempQuery);  //Get the response from Geth JSONRPC
    JsonObject& tempRPC = JSONbuffer.parseObject(tempStatus);
    String tempString = tempRPC["result"];
    tempString.remove(0,2);
    
    long int tempUpdate = strtol(tempString.c_str(), NULL, 16);

    Serial.println("Second Geth JSON-RPC response: ");
    Serial.println(tempStatus);    //Print request response payload
    //if the JSON buffer is too small, they'll be no or bunk output
    //hence the serial debugs
    //Serial.println("Hex Function input: ");
    //Serial.println(tempString);
    //Serial.println("Function result: ");
    //Serial.println(tempUpdate);
    

    //Turns on LED if blockchain state has been changed
    if( plainText_recovered_val == 49 ){
      digitalWrite(0, HIGH);   
      digitalWrite(4, LOW);
    } else if ( plainText_recovered_val == 51 ) {
      digitalWrite(0, HIGH);
      digitalWrite(4, HIGH);
    } else {
      digitalWrite(0, LOW);
      digitalWrite(4, LOW);
    }

    //***********************************third call to RPC to send Temperature*******************
    //sends temperature every 10min, or if smart contract activates, or if temp changes by 1 degree
    /*getTemperature();

    if( !tempUpdate || counter % 40 == 0 || currentTemperature != temperatureF ){
      if( !tempUpdate ){ Serial.println("**************** User requested temperature"); }
      if( counter % 40 == 0 ){ Serial.println("*********** 10 minute Temperature Update"); }
      if( currentTemperature != temperatureF )
      {
        Serial.println("*********** Temperature changed by at least one degreeF: ");
        Serial.println(temperatureF);
        currentTemperature = temperatureF;
      }
      
      if( counter == 4000 ){ counter = 0; } //keep counter in check

      //creating another JSON buffer to avoid confusion with the first 
      StaticJsonBuffer<1000> JSONBufferTwo;  
      JsonObject& uploadJSON = JSONBufferTwo.createObject(); 
      uploadJSON["jsonrpc"] = "2.0";
      uploadJSON["method"] = "personal_sendTransaction";
      
      JsonArray&  uploadQueryParams = uploadJSON.createNestedArray("params");
      
      JsonObject& callTxParams = JSONBufferTwo.createObject();
      callTxParams["from"] = "0xFAFC4C0769f69Fc583A09380bD6Ee3136Eb4754C";
      callTxParams["to"] = "0xc32D0A43ac5C419462c0cb3859713F27870861Bd";
      callTxParams["gas"] = "0x30D40"; //hex value for 200000 -high gas limit for good measure          
      callTxParams["gasPrice"] = "0x6FC23AC00"; //hex value 30 Gwei gasprice 21gwei is typical

      //convert temperature to hex and pad with zeroes
      String hexTemperature = String(temperatureF, HEX);
      String paddedZeroes;
      for(int x = 0; x < (64 - hexTemperature.length()); x++)
      {
        paddedZeroes = String(paddedZeroes + "0");
      }
      hexTemperature = String(paddedZeroes + hexTemperature);
      //sha3 hash of setTempDeviceOnly function name
      hexTemperature = String("0x0e56dbea" + hexTemperature);
      callTxParams["data"] = hexTemperature;
      
      uploadQueryParams.add(callTxParams);
      uploadQueryParams.add("Naz@29923186");
      uploadJSON["id"] = 1;

      String uploadString;
      uploadJSON.printTo(uploadString);
      Serial.println("Temperature Geth CALL JSON message setTempDeviceOnly function: ");
      Serial.println(uploadString);

      //!!!! This RPC call is insecure plain text password over the wifi LAN !!!!!!
      //Secure firewall and secure environment for private key/geth node is expected
      //I am looking for better ways to push data off IoT devices with minimum resources and open ports
      //NodeJS unlocking the accounts via IPC on the wifiRouter node seems best for now
      //I am looking for microcontroller IoT way to remotely securely unlock sign transactions without NodeJS
      //Suggestions?
      String uploadResult = callGeth(uploadString);  //Get the response from Geth JSONRPC
      JsonObject& gethJSONRPC = JSONbuffer.parseObject(uploadResult);
      Serial.println("**** Set Temp Call result TX hash: ");
      Serial.println(uploadResult);      
    }*/

   
    Serial.println("Counter: ");
    Serial.println(counter);
    Serial.println("Temperature in F: ");
    Serial.println(temperatureF);
    Serial.println("Temperature in C: ");
    Serial.println(temperatureC);
        
  } else {
 
    Serial.println("Error in WiFi connection");
 
  }
 
  delay(15000);  //Send a request every 15ish seconds

  WiFiClient client = server.available();
  
  if (client) {
    if(client.connected())
    {
      Serial.println("Client Connected");
    }
    
    while(client.connected()){      
      while(client.available()>0){
        // read data from the connected client
        Serial.write(client.read()); 
      }
      //Send Data to connected client
      while(Serial.available()>0)
      {
        client.write(Serial.read());
      }
    }
    client.stop();
    Serial.println("Client disconnected");    
  }
 
}
