
TYPE
	FeederBlockStatusEnum : 
		(
		FEEDBLOCK_ERROR := 0,
		FEEDBLOCK_INIT := 1,
		FEEDBLOCK_WORK := 2
		);
END_TYPE

(*FBFeederControl*)

TYPE
	FeederControlStatusEnum : 
		(
		FEEDCTRL_ERROR := 0,
		FEEDCTRL_INIT := 1,
		FEEDCTRL_READY_TO_FEED := 2,
		FEEDCTRL_PREPURGE := 3,
		FEEDCTRL_FEEDING := 4,
		FEEDCTRL_POSTPURGE := 5
		);
	FeederControlControlType : 	STRUCT 
		GasRate : INT;
		PowderRate : INT;
		KZP : REAL;
		KZU : REAL;
	END_STRUCT;
	FeederControlConfigType : 	STRUCT 
		PrepurgeTime : TIME;
		PostpurgeTime : TIME;
		AxisConfigLink : UDINT;
		ACPConfigLink : UDINT;
		AxisBasicParLink : UDINT;
		AxisCyclicSetParLink : UDINT;
		GasCalibrateOut : CalibrationType;
	END_STRUCT;
	FeederControlIOoutType : 	STRUCT 
		aoGasRate : INT;
		doShutOff : BOOL;
		doMixer : BOOL;
	END_STRUCT;
	FeederControlIOinType : 	STRUCT 
		aiGasRate : INT;
	END_STRUCT;
	FeederControlUserInfoType : 	STRUCT 
		Active : BOOL;
		ActualSpeed : REAL;
	END_STRUCT;
	FeederControlIOType : 	STRUCT 
		In : FeederControlIOinType;
		Out : FeederControlIOoutType;
	END_STRUCT;
END_TYPE

(*FBFeeder*)

TYPE
	FeederStatusEnum : 
		(
		FEED_ERROR := 0,
		FEED_INIT := 1,
		FEED_PAUSE := 2,
		FEED_RESET := 3,
		FEED_READY := 4,
		FEED_FEEDING := 5
		);
	FeederControlType : 	STRUCT 
		FeederControl : FeederControlControlType;
		ManualTareControl : BOOL;
		TareK : REAL;
	END_STRUCT;
	FeederConfigType : 	STRUCT 
		GasCalibrateIn : CalibrationType;
		WeightCalibrate : CalibrationType;
		DefaultTareK : REAL;
		WarningWeight : REAL;
		AlarmWeight : REAL;
		AlarmPrefix : STRING[80];
		EnableAutoRateControl : BOOL;
		ControlConfig : FeederControlConfigType;
		BufferDelay : TIME;
		TareCalcDelay : TIME;
		DeviationCalcDelay : TIME;
		ToGoToAutoDelay : TIME;
		DeviationLimit : REAL;
		ResetWeightLimit : REAL;
	END_STRUCT;
	FeederIOinType : 	STRUCT 
		aiWeight : INT;
	END_STRUCT;
	FeederUserInfoType : 	STRUCT 
		Weight : REAL;
		Rate : REAL;
		TareK : REAL;
		Deviation : REAL;
		IsAUTO : BOOL;
	END_STRUCT;
END_TYPE
