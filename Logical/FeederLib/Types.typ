
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
END_TYPE
