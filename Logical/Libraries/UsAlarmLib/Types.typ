(*----------------------------------------------------------------AlarmList------------------------------------------------------------------------------------------------------------------------------------------
В случае замены типов необходимо определить AlarmsListTypeSize*)

TYPE
	AlarmControlStatusTypeEnum : 
		(
		AlarmControl_INIT := 0,
		AlarmControl_BIZY := 1,
		AlarmControl_DONE := 2,
		AlarmControl_ERROR := 3
		);
	AlarmBVMItemType : 	STRUCT  (*Alarm list boolean value monitor type*)
		Config : MpAlarmXAlarmConfigType; (*Alarm config*)
		Name : STRING[80]; (*Alarm name*)
		MonitoredValueAdr : UDINT; (*Adress of boolean monitored value*)
		TriggerValue : BOOL := TRUE;
	END_STRUCT;
END_TYPE
