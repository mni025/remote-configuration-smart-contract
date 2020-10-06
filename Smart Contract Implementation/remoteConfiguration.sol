pragma solidity ^0.5.11;

contract remoteConfiguration
{
    
    //The keyword "public" makes those variables readable from outside and inside.
    //The address type is a 160-bit value that doesn't allow any arithmetic operations
    address public manufacturer;
    
    //This declares a new complex type which will be used for variables later. It will represent a single device.
    struct info {
        address owner;
        uint256[] configurations;
    }
    
    //The type maps unsigned integers to info. Mappings can be seen as hash tables which are virtually initialized such that
    //every possible key exists and is mapped to a value whose byte-representation is all zeros.
    mapping (uint => info) public idInfo;
    
    uint256 currentConfig;
    uint256 configStartTime;
    uint256 configPeriod;
    bool tempUpdated;
    uint256 lastTempUpdate;

    modifier onlyManufacturer()
    {
        require(msg.sender == manufacturer);
        _;
    }
    
    constructor() public
    {
        //manufacturer = msg.sender;
        manufacturer = 0xFAFC4C0769f69Fc583A09380bD6Ee3136Eb4754C;
        tempUpdated = true;
        lastTempUpdate = block.number;
    }

    function registerDevice(uint _identifier, uint256 config0, uint256 config1, uint256 config2) public onlyManufacturer {
        idInfo[_identifier].owner = msg.sender;
        idInfo[_identifier].configurations[0] = config0; //this is the encrypted default configuration
        idInfo[_identifier].configurations[1] = config1;
        idInfo[_identifier].configurations[2] = config2;
    }
    
    function transferOwnership(uint _identifier, address buyer) public {
		require(
            msg.sender == idInfo[_identifier].owner,
            "Only the device owner can transfer the ownership."
        );
        idInfo[_identifier].owner = buyer;
        
    }
    
    function upgradeConfiguration(uint _identifier, uint256 requestedConfig, uint256 configTimer) public payable 
    {
        require(
            msg.sender == idInfo[_identifier].owner,
            "Only the device owner can request for configuration upgrade."
        );
        
        if( requestedConfig == 1 ){
            if (msg.value < 100 finney){ 
                revert(); 
            } else {
                currentConfig = idInfo[_identifier].configurations[1] ;
            }
        } else if( requestedConfig == 2 ){
            if (msg.value < 200 finney){ 
                revert(); 
            } else {
                currentConfig = idInfo[_identifier].configurations[2];
            }
        } else {
            revert();
        }
        configStartTime = block.timestamp;
        configPeriod = configTimer;
    }
    
        
    function queryConfiguration() public view returns (uint256, uint256)
    {
        if (block.timestamp - configStartTime < configPeriod) {
            return (currentConfig, configPeriod);
        } else {
            //LEDturnedOn = 27;
            revert();
        }
    }
}