
(* TODO:  Done?*)
FUNCTION_BLOCK FBRecordAlarmsInCore
	CASE Status OF
		AlarmControl_INIT:
			IF Enable THEN
				MpAlarmXConfigAlarm_0.MpLink := ADR(AlarmXCore);
				MpAlarmXConfigAlarm_0.Enable := TRUE;
				MpAlarmXConfigAlarm_0.Configuration := ADR(MpAlarmXAlarmConfigType_0);
				Status := AlarmControl_BIZY;
				IF (Prefix <> '') THEN
					FOR i := 0 TO ListSize-1 DO
						AlarmBVMListItem ACCESS (AlarmBVMListAdr + AlarmDVMListItemTypeSize*i);
						// ƒобавление префикса к сообщению аларма								
						AlarmBVMListItem.Config.Message := CONCAT(Prefix, AlarmBVMListItem.Config.Message);
					END_FOR
				END_IF
				
				IF (DeviceName <> '') THEN	
					FOR i := 0 TO ListSize-1 DO
						AlarmBVMListItem ACCESS (AlarmBVMListAdr + AlarmDVMListItemTypeSize*i);
						// добавление имени устройства к имени аларма
						AlarmBVMListItem.Name := CONCAT(DeviceName, AlarmBVMListItem.Name);
					END_FOR
				END_IF
				i := 0;
			END_IF
		AlarmControl_BIZY:
			// производитс€ запись ошибок из листа в €дро
			IF (i <= (ListSize-1)) THEN
				AlarmBVMListItem ACCESS (AlarmBVMListAdr + AlarmDVMListItemTypeSize*i);
				MpAlarmXConfigAlarm_0.Save := TRUE;			
				MpAlarmXConfigAlarm_0.Name := ADR(AlarmBVMListItem.Name);
				MpAlarmXAlarmConfigType_0 := AlarmBVMListItem.Config;
				MpAlarmXConfigAlarm_0();
				IF ((MpAlarmXConfigAlarm_0.CommandDone) AND (NOT(MpAlarmXConfigAlarm_0.CommandBusy))) THEN
					i := i + 1;
					MpAlarmXConfigAlarm_0.Save := FALSE;
					MpAlarmXConfigAlarm_0();
				END_IF
				IF MpAlarmXConfigAlarm_0.Error THEN
					Status := AlarmControl_ERROR;
				END_IF				
			ELSE
				Status := AlarmControl_DONE;
			END_IF			
		AlarmControl_DONE:
			// ќшибки записаны, блок в режиме ожидани€ перезаписи
			IF NOT Enable THEN
				Status := AlarmControl_INIT;
			END_IF
		AlarmControl_ERROR:	
			IF ResetError THEN
				IF MpAlarmXConfigAlarm_0.Error THEN
					MpAlarmXConfigAlarm_0.ErrorReset := TRUE;
					MpAlarmXConfigAlarm_0();
				ELSE
					ResetError := FALSE;
					Status := AlarmControl_INIT;
				END_IF				
			END_IF
	END_CASE
END_FUNCTION_BLOCK
