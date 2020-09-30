#include "xparameters.h"
#include "xuartps.h"
#include "xil_io.h"
//#include "xbasic_types.h"
#include <sleep.h>
#include "wifi.h"
#include <iostream>

using namespace std;

std::string ssid= "The_Gambia_24G";
std::string pwd = "scoobyroo";
int config_time_val = 0;
long RSA_Own_Private_Key[2] = {55, 3};

void loop(espWiFi*);
int stringToBin(std::string in);
std::string intToBinString(int in);

int main(){

	xil_printf("starting the main function...\n\r");
	int status;
	int new_config_time_val = 0;
	int config_time_val_reset;
	espWiFi myWiFi;

	while(1){
	do{
		status = myWiFi.initWifi(921600,ssid,pwd);
		if(status == WIFI_SUCCESS)
			xil_printf("Successfully started HTTP Client\n\r");
		else{
			xil_printf("Failed retrying...\n\r");
		}
	}while(status != WIFI_SUCCESS);

	if (new_config_time_val != config_time_val)
		new_config_time_val = config_time_val;
	else
		continue;

	config_time_val_reset = new_config_time_val + 16*16*16*16;
	//loop(&myWiFi);

	xil_printf("this is a bcm test\n\r");
	//exit(1);

	if (Xil_In32(XPAR_MYIPBCM_0_S00_AXI_BASEADDR+12) != 0x25feeded){
		xil_printf("warning: did not find the device\n\r");
	}

	//sleep(2);

	//Xil_Out32(XPAR_MYIPBCM_0_S00_AXI_BASEADDR, 0x0001F933);
	Xil_Out32(XPAR_MYIPBCM_0_S00_AXI_BASEADDR, config_time_val_reset);
	sleep(2);
	//Xil_Out32(XPAR_MYIPBCM_0_S00_AXI_BASEADDR, 0x0000F933);
	Xil_Out32(XPAR_MYIPBCM_0_S00_AXI_BASEADDR, config_time_val);

	//sleep(20);

	u32 val = Xil_In32(XPAR_MYIPBCM_0_S00_AXI_BASEADDR+4);
	xil_printf("the value is: %d\n\r",val);

	u32 new_val;
	u32 ticker_val;

	ticker_val = Xil_In32(XPAR_MYIPBCM_0_S00_AXI_BASEADDR+8);
	xil_printf("first ticker value is: %d\n\r", ticker_val);

	/*while (1){
		sleep(1);
		new_val = Xil_In32(XPAR_MYIPBCM_0_S00_AXI_BASEADDR+4);
		if (new_val != val){
			xil_printf("value is changed to %d\n\r", new_val);
			val = new_val;
		}

		ticker_val = Xil_In32(XPAR_MYIPBCM_0_S00_AXI_BASEADDR+8);
		//if (ticker_val == 0)
		//xil_printf("ticker value is: %d\n\r", ticker_val);
	}*/
	}

	return 0;
}
