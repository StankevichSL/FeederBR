(* TODO:  Done?*)
FUNCTION_BLOCK FBAlarmListControl
	CASE Status OF
		AlarmControl_INIT:
			RecordAlarm.AlarmBVMListAdr := AlarmBVMListAdr;
			RecordAlarm.AlarmXCore := AlarmXCore;
			RecordAlarm.ListSize := ListSize;
			RecordAlarm.Prefix := Prefix;
			RecordAlarm.DeviceName := DeviceName;
			RecordAlarm.Enable := TRUE;
			RecordAlarm();
		
			CheckAlarm.AlarmBVMListAdr := AlarmBVMListAdr;
			CheckAlarm.AlarmXCore := AlarmXCore;
			CheckAlarm.ListSize := ListSize;
			CheckAlarm.Enable := TRUE;
			Status := AlarmControl_BIZY;
		AlarmControl_BIZY:
			// Ожидание записи Аларм листа в ядро
			RecordAlarm();
			IF (RecordAlarm.Status = AlarmControl_DONE) THEN
				Status := AlarmControl_DONE;				
			END_IF
			IF  RecordAlarm.Status = AlarmControl_ERROR THEN
				Status := AlarmControl_ERROR;
			END_IF;
		AlarmControl_DONE:
			// Мониторинг переменных, основной режим работы функционального блока
			CheckAlarm();
			IF CheckAlarm.Status = AlarmControl_ERROR THEN
				Status := AlarmControl_ERROR;
			END_IF			
			IF NOT Enable THEN
				RecordAlarm.Enable := FALSE;
				RecordAlarm();
				CheckAlarm.Enable := FALSE;
				CheckAlarm();
				Status := AlarmControl_INIT;
			END_IF			
		AlarmControl_ERROR:
			// Сброс ошибок в подконтрольных фб
			IF ResetError THEN
				IF  RecordAlarm.Status = AlarmControl_ERROR THEN
					RecordAlarm.ResetError := TRUE;
					RecordAlarm();
				END_IF;
				IF CheckAlarm.Status = AlarmControl_ERROR THEN
					CheckAlarm.ResetError := TRUE;
					CheckAlarm();
				END_IF
				IF ((RecordAlarm.Status <> AlarmControl_ERROR) AND (CheckAlarm.Status <> AlarmControl_ERROR)) THEN
					Status := AlarmControl_INIT;
					ResetError := FALSE;
				END_IF				
			END_IF
	END_CASE
END_FUNCTION_BLOCK
