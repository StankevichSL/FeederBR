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
		Start : {REDUND_UNREPLICABLE} BOOL;
		Config : FeederHandlerConfigType;
		Control : FeederHandlerControlType;
		TareK : REAL;
	END_VAR
	VAR_OUTPUT
		UserInfo : FeederHandlerUserInfoType;
		Status : FeederHandlerStatusEnum := FEEDCTRL_INIT;
		IO : FeederHandlerIOType;
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
		Start : BOOL;
		Reset : BOOL;
		Config : FeederConfigType;
		Control : FeederControlType;
		IOin : FeederIOinType;
	END_VAR
	VAR_OUTPUT
		UserInfo : FeederUserInfoType;
		Status : FeederStatusEnum;
	END_VAR
	VAR
		FBControl : FBFeederHandler;
		TON_TareCalcDelay : TON;
		TON_DeviationCalcDelay : TON;
		TON_ToGoToAutoDelay : TON;
		TON_BufferDelay : TON;
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
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK FBFeederBlock (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR_OUTPUT
		Status : FeederBlockStatusEnum;
	END_VAR
END_FUNCTION_BLOCK
