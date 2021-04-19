
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
	FeederBlockStatusEnum : 
		(
		FEEDBLOCK_ERROR := 0,
		FEEDBLOCK_INIT := 1,
		FEEDBLOCK_WORK := 2
		);
	FeederStatusEnum : 
		(
		FEED_ERROR := 0,
		FEED_INIT := 1,
		FEED_PAUSE := 2,
		FEED_RESET := 3,
		FEED_READY := 4,
		FEED_FEEDING := 5
		);
	FeederControlConfigType : 	STRUCT 
		PrepurgeTime : TIME;
		PostpurgeTime : TIME;
		AxisConfigLink : UDINT;
		ACPConfigLink : UDINT;
		AxisBasicParLink : UDINT;
		AxisCyclicSetParLink : UDINT;
	END_STRUCT;
	FeederControlControlType : 	STRUCT 
		GasSetpoint : INT;
		PowderSetpoint : LREAL;
	END_STRUCT;
	FeederControlOutType : 	STRUCT 
		Shutoff : BOOL;
		Mixer : BOOL;
		FlowReg : INT;
		ActualSpeed : REAL;
	END_STRUCT;
	FeederConfigType : 	STRUCT 
		AutoMode : BOOL;
		DefaultTareK : REAL;
		Deviation : REAL; (*Value of standart deviation TareK to go to auto feed mode*)
		SwitchWeight : REAL; (*Value of weigth to switch feeder*)
		BufferDelay : TIME; (*Delay to charge buffers *)
	END_STRUCT;
	FeederControlType : 	STRUCT 
		DiskVelocityKoef : REAL := 1;
		SeparateMode : BOOL;
	END_STRUCT;
END_TYPE
