(*----------------------------------------------------------------Alarms------------------------------------------------------------------------------------------------------------------------------------------*)

FUNCTION_BLOCK FBRecordAlarmsInCore
	VAR_INPUT
		Enable : BOOL;
		AlarmBVMListAdr : UDINT; (*Ссылка на массив алармов*)
		ListSize : USINT; (*Количество элементов в массиве*)
		AlarmXCore : MpComIdentType;
		Prefix : STRING[80];
		DeviceName : STRING[80];
		ResetError : BOOL;
	END_VAR
	VAR_OUTPUT
		Status : AlarmControlStatusTypeEnum := AlarmControl_INIT;
	END_VAR
	VAR
		i : USINT := 0;
		MpAlarmXAlarmConfigType_0 : MpAlarmXAlarmConfigType;
		MpAlarmXConfigAlarm_0 : MpAlarmXConfigAlarm;
		AlarmBVMListItem : REFERENCE TO AlarmBVMItemType;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK FBCheckAlarmValues
	VAR_INPUT
		Enable : BOOL;
		AlarmBVMListAdr : UDINT; (*Ссылка на массив алармов*)
		ListSize : USINT; (*Количество элементов в массиве*)
		AlarmXCore : MpComIdentType;
		ResetError : BOOL;
	END_VAR
	VAR_OUTPUT
		Status : AlarmControlStatusTypeEnum := AlarmControl_INIT;
	END_VAR
	VAR
		i : USINT := 0;
		AlarmListItem : REFERENCE TO AlarmBVMItemType;
		boolVal : REFERENCE TO BOOL; (*Value for compare monitoried and trigger values*)
		AlarmXSetStatus : DINT;
		AlarmXResetStatus : DINT;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK FBAlarmListControl (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL;
		AlarmBVMListAdr : UDINT; (*Ссылка на массив алармов*)
		ListSize : USINT; (*Количество элементов в массиве*)
		AlarmXCore : MpComIdentType;
		Prefix : STRING[80];
		DeviceName : STRING[80];
		ResetError : BOOL;
	END_VAR
	VAR_OUTPUT
		Status : AlarmControlStatusTypeEnum := AlarmControl_INIT;
	END_VAR
	VAR
		RecordAlarm : FBRecordAlarmsInCore;
		CheckAlarm : FBCheckAlarmValues;
	END_VAR
END_FUNCTION_BLOCK
