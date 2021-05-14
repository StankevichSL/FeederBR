(* TODO: Done?*)
FUNCTION_BLOCK FBCheckAlarmValues	
	CASE Status OF
		AlarmControl_INIT:
			IF (AlarmBVMListAdr > 0) THEN
				IF Enable THEN
			(*	AlarmXCore ACCESS AlarmXCore;*)
				Status := AlarmControl_BIZY;
				END_IF			
			ELSE
				Status := AlarmControl_ERROR;
				// AlarmBVMListAdr empty
			END_IF
			
		AlarmControl_BIZY:
			// Мониторинг переменных			
			FOR i:=0 TO ListSize-1 DO
				AlarmListItem ACCESS (AlarmBVMListAdr + i*AlarmDVMListItemTypeSize);
				boolVal ACCESS (AlarmListItem.MonitoredValueAdr);
				IF (AlarmListItem.TriggerValue = boolVal) THEN
					AlarmXSetStatus := MpAlarmXSet(AlarmXCore, AlarmListItem.Name);
				ELSE					
					AlarmXResetStatus := MpAlarmXReset(AlarmXCore, AlarmListItem.Name);
				END_IF
			END_FOR
			IF NOT Enable THEN
				Status := AlarmControl_DONE;
			END_IF
			// в случае возникновения ошибок Set/Reset алармов в ядре
//			IF ((AlarmXResetStatus <> 0) OR (AlarmXSetStatus <> 0)) THEN
//				Status := AlarmControl_ERROR;
//			END_IF
			
		AlarmControl_DONE:
			// Ожидание продолжения мониторинга переменных
			IF Enable THEN
				Status := AlarmControl_BIZY;
			END_IF;
			
		AlarmControl_ERROR:
			IF ResetError THEN
				Status := AlarmControl_INIT;
				ResetError := FALSE;
			END_IF
	END_CASE
END_FUNCTION_BLOCK
