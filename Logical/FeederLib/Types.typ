(*FBFeederHandler*)

TYPE
	FeederHandlerStatusEnum : 
		(
		FEEDCTRL_ERROR := 0,
		FEEDCTRL_INIT := 1,
		FEEDCTRL_READY_TO_FEED := 2,
		FEEDCTRL_PREPURGE := 3,
		FEEDCTRL_FEEDING := 4,
		FEEDCTRL_POSTPURGE := 5
		);
	FeederHandlerControlType : 	STRUCT 
		PowderRate : UINT; (*Базовое управляющее значение расхода порошка*)
		KZP : REAL;
		KZU : REAL;
		GasRate : UINT; (*Управляющее значение расходом газа*)
	END_STRUCT;
	FeederHandlerConfigType : 	STRUCT 
		PrepurgeTime : TIME;
		PostpurgeTime : TIME;
		AxisConfigLink : UDINT;
		ACPConfigLink : UDINT;
		AxisBasicParLink : UDINT;
		AxisCyclicSetParLink : UDINT;
		GasCalibrateOut : CalibrationType;
		Ratio : USINT := 25;
	END_STRUCT;
	FeederHandlerIOoutType : 	STRUCT 
		aoGasRate : INT; (*Управление регулятором расхода*)
		doShutOff : BOOL;
		doMixer : BOOL;
	END_STRUCT;
	FeederHandlerIOinType : 	STRUCT 
		aiGasRate : UINT; (*Показание регулятора расхода*)
	END_STRUCT;
	FeederHandlerUserInfoType : 	STRUCT 
		Active : BOOL;
		ActualSpeed : REAL;
	END_STRUCT;
	FeederHandlerIOType : 	STRUCT 
		In : FeederHandlerIOinType;
		Out : FeederHandlerIOoutType;
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
		Handler : FeederHandlerControlType;
		ManualTareControl : BOOL;
		TareK : REAL;
	END_STRUCT;
	FeederConfigType : 	STRUCT 
		Handler : FeederHandlerConfigType;
		GasCalibrateIn : CalibrationType;
		WeightCalibrate : CalibrationType;
		DefaultTareK : REAL;
		WarningWeight : REAL;
		AlarmWeight : REAL;
		AlarmPrefix : STRING[80];
		EnableAutoRateControl : BOOL;
		BufferDelay : TIME;
		TareCalcDelay : TIME;
		DeviationCalcDelay : TIME;
		ToGoToAutoDelay : TIME;
		RecordInBufferPerion : TIME := T#100ms; (*Запись значений в буфер через указанное время*)
		DeviationLimit : REAL;
		ResetWeightLimit : REAL;
	END_STRUCT;
	FeederIOinType : 	STRUCT 
		Handler : FeederHandlerIOinType;
		aiWeight : DINT;
	END_STRUCT;
	FeederUserInfoType : 	STRUCT 
		Handler : FeederHandlerUserInfoType;
		Weight : REAL;
		Rate : REAL;
		TareK : REAL;
		Deviation : REAL;
		IsAUTO : BOOL;
	END_STRUCT;
END_TYPE

(*FBFeederBlock*)

TYPE
	FeederBlockStatusEnum : 
		(
		FEEDBLOCK_ERROR := 0,
		FEEDBLOCK_INIT := 1,
		FEEDBLOCK_SINGLE := 2,
		FEEDBLOCK_DUAL := 3
		);
	FeederBlockControlType : 	STRUCT 
		PrimaryFeeder : FeederControlType;
		SecondaryFeeder : FeederControlType;
		PrimaryStart : BOOL;
		SecondaryStart : BOOL;
		SeparateMode : BOOL;
		FeederSwitch : BOOL;
	END_STRUCT;
	FeederBlockConfigType : 	STRUCT 
		PrimaryFeeder : FeederConfigType;
		SecondaryFeeder : FeederConfigType;
		DualFeederMode : BOOL;
	END_STRUCT;
	FeederBlockIOinType : 	STRUCT 
		PrimaryFeeder : FeederIOinType;
		SecondaryFeeder : FeederIOinType;
	END_STRUCT;
	FeederBlockIOoutType : 	STRUCT 
		PrimaryFeeder : FeederHandlerIOoutType;
		SecondaryFeeder : FeederHandlerIOoutType;
	END_STRUCT;
	FeederBlockUserInfoType : 	STRUCT 
		PrimaryFeeder : FeederUserInfoType;
		SecondaryFeeder : FeederUserInfoType;
	END_STRUCT;
END_TYPE
