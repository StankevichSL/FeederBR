(*----------------------------------------------------------------Robot----------------------------------------------------------------------------------------------------------------------*)

TYPE
	IORobotEthIpType : 	STRUCT 
		In : IORobotEthIpInType;
		Out : IORobotEthIpOutType;
	END_STRUCT;
	IORobotEthIpInType : 	STRUCT 
		diLaserOn : BOOL;
		diProgramStop : BOOL;
		diPilotOn : BOOL;
		diCoaxArgon : BOOL;
		diBulbStart : ARRAY[1..10]OF BOOL;
		diCrossjetOn : BOOL;
		diPiezoRegHead : BOOL;
		diLaserRequest : BOOL;
		diAnalyseOn : BOOL;
		diAnalyseOff : BOOL;
		diPowderSwitchOn : BOOL;
		diRobotError : BOOL;
		diReady : BOOL;
		diProgRun : BOOL;
		diModeAuto : BOOL;
		diModeT2 : BOOL;
		diModeT1 : BOOL;
		diBatteryAlarm : BOOL;
		diESTOP : BOOL;
		diInputSimulated : BOOL;
		diOutputSimulated : BOOL;
		diProgPaused : BOOL;
		diBusy : BOOL;
		diTpEnabled : BOOL;
		diHold : BOOL;
		aiLaserPower : UINT;
		aiCoaxialGasSetpoint : UINT;
		aiHeadGasSetpiont : UINT;
		aiBulbGasSetpoint : ARRAY[1..10]OF UINT;
		aiLaserProgram : UINT;
		aiWobblerProgramNumber : UINT;
		aiWobblerAmplitude : UINT;
		aiWobblerFriequency : UINT;
	END_STRUCT;
	IORobotEthIpOutType : 	STRUCT 
		doStart : BOOL;
		doStop : BOOL;
		doResetError : BOOL;
		doMachineError : BOOL;
	END_STRUCT;
END_TYPE
