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
		PowderRate : UINT; (*������� ����������� �������� ������� �������*)
		KZP : REAL; (*����������� ������� �������*)
		KZU : REAL; (*����������� ������ ������������ (0-99)*)
		GasRate : UINT; (*����������� �������� �������� ����*)
	END_STRUCT;
	FeederHandlerConfigType : 	STRUCT 
		PrepurgeTime : TIME := T#5s; (*����� ��������������� �������� ���������� ��������, ����� ������� �������*)
		PostpurgeTime : TIME := T#5s; (*����� �������� ���������� �������� ����� ��������� ������ �������*)
		AxisConfigLink : UDINT; (*������ �� ����� ������������ gLinkFeeder ����������� � Configuration Motion Config.mpaxisbasic*)
		ACPConfigLink : UDINT; (*������ �� ����� ������������ gAxis ����������� � Configuration Motion Acp10map.ncm*)
		AxisBasicParLink : UDINT; (*������ �� ��������� ������������ ���� MpAxisBasicParType*)
		AxisCyclicSetParLink : UDINT; (*������ �� ��������� ������������ ���� MpAxisCyclicSetParType*)
		GasCalibrateOut : CalibrationType; (*������������ ���������� ������ ������������� ����*)
		Ratio : USINT := 25; (*������������ ��������� �������� ����� �������*)
	END_STRUCT;
	FeederHandlerIOoutType : 	STRUCT 
		aoGasRate : INT; (*���������� ����������� �������*)
		doShutOff : BOOL; (*���������� ������ ������ ������������� ����, ��������� ��������*)
		doMixer : BOOL; (*��������� ������� ����� ��������*)
	END_STRUCT;
	FeederHandlerIOinType : 	STRUCT 
		aiGasRate : UINT; (*��������� ���������� �������*)
	END_STRUCT;
	FeederHandlerUserInfoType : 	STRUCT 
		Active : BOOL; (*���������� ������� �� ��������*)
		ActualSpeed : REAL; (*���������� ������� �������� �������� ����� � ����������� ��������*)
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
		ManualTareControl : BOOL; (*��������� ������� ������ ���������� ������������ �������������*)
		TareK : REAL; (*�� ���� ���������� ������� �������� ��� ������ ���������� ������������ �������������*)
		UpdateTareWeight : BOOL; (*���������� ������� ��� � ��� ���� Config.TareWeight*)
	END_STRUCT;
	FeederConfigType : 	STRUCT 
		Handler : FeederHandlerConfigType;
		GasCalibrateIn : CalibrationType; (*���������� ��������� ������� ������� ������������� ����*)
		WeightCalibrate : CalibrationType; (*���������� ��������� ������������*)
		DefaultTareK : REAL := 1; (*������������ ����������� �����������*)
		WarningWeight : REAL := 0.3; (*��� �������������� � ��*)
		AlarmWeight : REAL := 0.1; (*��� ������ � ��*)
		AlarmPrefix : STRING[80]; (*������� ����� ��� ������������ �������*)
		BufferDelay : TIME := T#10s; (*�������� ����� ������� ���������� ��������*)
		TareCalcDelay : TIME := T#10s; (*�������� ����� ������� ������� ������������� ������������ � ������� �� ������ ��������*)
		DefaultTareKUpdateDelay : TIME := T#10s; (*������ ���������� ������������� ������������ �� ��������� ��� ������ � ������ ���� ���������� ��������*)
		DeviationCalcDelay : TIME := T#10s; (*�������� ����� ������� ������� ������������ ���������� ������������� ������������*)
		ToGoToAutoDelay : TIME := T#10s; (*����� ����� ��������� � ����� ��������������� �������, � ������� �������� ����������� �������, ��� ������� ���������� ������������� ������������ ������ ���������*)
		RecordInBufferPerion : TIME := T#100ms; (*������ �������� � ����� ����� ��������� �����*)
		DeviationLimit : REAL := 0.2; (*��������� �������� ������������ ���������� ������������� ������������ ��� �������� � ���� �����*)
		ResetWeightLimit : REAL := 0.3; (*�������� ���� � ��, ��� ������ �������� ������� ����� ������ �� ����� ��������*)
		ControlWord : UINT := 29828; (*����������� ����� ��� �������������*)
		TareWeight : REAL := 0; (*��� ������ ����� �������� � ��*)
	END_STRUCT;
	FeederIOinType : 	STRUCT 
		Handler : FeederHandlerIOinType;
		aiWeight : DINT; (*��������� ������������*)
	END_STRUCT;
	FeederUserInfoType : 	STRUCT 
		Handler : FeederHandlerUserInfoType;
		Weight : REAL; (*������� ��� ������� � �������� � ��*)
		Rate : REAL; (*������� ������ ������� ��/���*)
		TareK : REAL; (*������� ������������ �����������*)
		Deviation : REAL; (*������� ����������� ���������� ������������� ������������*)
		IsAUTO : BOOL; (*������� �� ����� ��������������� ����������� ������� �������*)
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
		PrimaryStart : BOOL; (*����� ������� ��������*)
		SecondaryStart : BOOL; (*����� ������� ��������*)
		SeparateMode : BOOL; (*����� ���������� ������ �������, ��� false - ���������������� �����*)
		FeederSwitch : BOOL; (*������������ ���� ��������, false - ������*)
	END_STRUCT;
	FeederBlockConfigType : 	STRUCT 
		PrimaryFeederADR : UDINT; (*������ �� ��������� FeederConfigType ��� ������ �����*)
		SecondaryFeederADR : UDINT; (*������ �� ��������� FeederConfigType ��� ������ �����*)
		DualFeederMode : BOOL := TRUE; (*���������� ���� ��������, false - ����*)
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
	FeederBlockIOType : 	STRUCT 
		In : FeederBlockIOinType;
		Out : FeederBlockIOoutType;
	END_STRUCT;
END_TYPE
