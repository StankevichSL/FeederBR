(*Insert your comment here.*)

{REDUND_ERROR} FUNCTION FFeederRatio : REAL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		W : REFERENCE TO ARRAY[0..2399] OF REAL;
		V : REFERENCE TO ARRAY[0..2399] OF REAL;
		T : REFERENCE TO ARRAY[0..2399] OF REAL;
		lengthOfArray : UDINT;
	END_VAR
	VAR
		sxx : LREAL;
		sxy : LREAL;
		sxp : LREAL;
		sumx : LREAL;
		sumy : LREAL;
		sump : LREAL;
		sumx2 : LREAL;
		sumxy : LREAL;
		sumxp : LREAL;
		i : UDINT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION FStdDeviation : REAL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Array : REFERENCE TO ARRAY[0..2399] OF REAL;
		lengthOfArray : UDINT;
	END_VAR
	VAR
		avg : REAL;
		sum : REAL;
		i : UDINT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION_BLOCK FBFeederHandler (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL;
		Start : BOOL;
		Config : FeederHandlerConfigType;
		Control : FeederHandlerControlType;
		TareK : REAL;
		IOin : FeederHandlerIOinType;
	END_VAR
	VAR_OUTPUT
		UserInfo : FeederHandlerUserInfoType;
		Status : FeederHandlerStatusEnum := FEEDCTRL_INIT;
		IOout : FeederHandlerIOoutType;
	END_VAR
	VAR
		AxisBasic : MpAxisBasic;
		AxisCyclicSet : MpAxisCyclicSet;
		TON_Prepurge : TON;
		TON_Postpurge : TON;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK FBFeeder (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : {REDUND_UNREPLICABLE} BOOL;
		Reset : BOOL;
		Start : BOOL;
		Config : FeederConfigType;
		Control : FeederControlType;
		AlarmXCore : UDINT;
		IOin : FeederIOinType;
	END_VAR
	VAR_OUTPUT
		IOout : FeederHandlerIOoutType;
		UserInfo : FeederUserInfoType;
		Status : FeederStatusEnum := FEED_INIT;
	END_VAR
	VAR
		FBControl : FBFeederHandler;
		TON_TareCalcDelay : TON;
		TON_DeviationCalcDelay : TON;
		TON_ToGoToAutoDelay : TON;
		TON_BufferDelay : TON;
		TON_WriteInBufferPeriod : TON := (PT:=T#100ms);
		WBuffer : ARRAY[0..2399] OF REAL;
		TBuffer : ARRAY[0..2399] OF REAL;
		PBuffer : ARRAY[0..2399] OF REAL;
		TareKBuffer : ARRAY[0..2399] OF REAL;
		i : UINT;
		j : UINT;
		WriteInWTP : BOOL := FALSE;
		WriteInTareK : BOOL := FALSE;
		RewriteWTP : BOOL := FALSE;
		RewriteTareK : BOOL := FALSE;
		CalcDeviation : BOOL := FALSE;
		AlarmList : ARRAY[0..1] OF AlarmBVMItemType := [(Config:=(Message:='{$$FeederAlarms/Warning.Weight}',Code:=602,Severity:=1),Name:='WarningWeight'),(Config:=(Message:='{$$FeederAlarms/Alarm.Weight}',Code:=603,Severity:=1),Name:='AlarmWeight')];
	END_VAR
	VAR CONSTANT
		alarmListSize : USINT := 2;
	END_VAR
	VAR
		AlarmControl : FBAlarmListControl;
		AXCore : REFERENCE TO MpComIdentType;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK FBFeederBlock (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : {REDUND_UNREPLICABLE} BOOL;
		Config : REFERENCE TO FeederBlockConfigType;
		Control : REFERENCE TO FeederBlockControlType;
		IOin : FeederBlockIOinType;
		AlarmXCore : {REDUND_UNREPLICABLE} UDINT;
	END_VAR
	VAR_OUTPUT
		Status : FeederBlockStatusEnum := FEEDBLOCK_INIT;
		IOout : FeederBlockIOoutType;
		UserInfo : FeederBlockUserInfoType;
	END_VAR
	VAR
		PrimaryFeeder : FBFeeder;
		SecondaryFeeder : FBFeeder;
		TON_UpdateDefaultTareK1 : TON := (PT:=T#100ms);
		TON_UpdateDefaultTareK2 : TON := (PT:=T#100ms);
		ConfigPrimaryFeeder : REFERENCE TO FeederConfigType;
		ConfigSecondaryFeeder : REFERENCE TO FeederConfigType;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK FBSpendTotalizer (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Active : {REDUND_UNREPLICABLE} BOOL;
		Period : TIME := T#1m;
		Weight : REAL;
		Delta : REAL;
		CounterLink : REFERENCE TO REAL;
	END_VAR
	VAR_OUTPUT
		Status : SpendTotalizerStatusEnum := SPENDTOTALIZER_INIT;
	END_VAR
	VAR
		TON_WeightCheckPeriod : TON;
		TempVal : REAL;
	END_VAR
END_FUNCTION_BLOCK
