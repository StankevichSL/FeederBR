(*----------------------------------------------------------------Others------------------------------------------------------------------------------------------------------------------------------------------*)

TYPE
	StepActiveEnumType : 
		(
		STEPACTIVE_STOP,
		STEPACTIVE_INITIALIZATION,
		STEPACTIVE_RUN
		);
	Errors : 
		(
		NO_ERRORS,
		ARGON_PRESSURE_IS_TO_LOW,
		AIR_PRESSURE_IS_TO_LOW
		);
	VentilateValveSensType : 	STRUCT 
		TopVentilateValveIsOpened : BOOL;
		TopVentilateValveIsClosed : BOOL;
		BottomVentilateValveIsOpened : BOOL;
		BottomVentilateValveIsClosed : BOOL;
	END_STRUCT;
	CalibrationType : 	STRUCT 
		A : REAL;
		B : REAL;
		C : REAL;
		MaxValue : REAL;
		MinValue : REAL;
	END_STRUCT;
	ReactionsType : 	STRUCT 
		Warning : BOOL;
		WarningAlarm : BOOL;
		AlarmStopAll : BOOL;
		Signal : BOOL;
		AlarmSignalAndStopAll : BOOL;
	END_STRUCT;
	BlinkModeType : 
		(
		BLINKMODE_CONSTANT_ON, (*Постоянный сигнал включен*)
		BLINKMODE_CONSTANT_OFF, (*Постоянный сигнал выключен*)
		BLINKMODE_SLOW, (*Мигание период 1000 мс*)
		BLINKMODE_MEDIUM, (*Мигание период 500 мс*)
		BLINKMODE_FAST (*Мигание период 250 мс*)
		);
	FBRobotAlarmsIOInType : 	STRUCT 
		diRobotError : BOOL;
		diBatteryAlarm : BOOL;
		diESTOP : BOOL;
		diInputSimulated : BOOL;
		diOutputSimulated : BOOL;
	END_STRUCT;
END_TYPE

(*Sts*)

TYPE
	FBStatusEnumType : 
		(
		Init := 0,
		Idle := 1,
		Bizy := 2,
		Done := 3,
		Error := 4
		);
END_TYPE
