
FUNCTION_BLOCK FB_ReadData
	VAR_INPUT RETAIN
		Ena : BOOL := FALSE;
		FileName : STRING[32];
		DeviceName : STRING[32];
	END_VAR
	VAR_INPUT
		Offset : UDINT := 0;
		Size : UDINT := 1;
	END_VAR
	VAR_OUTPUT
		Status : STRING[80]; (*0-ok*)
		Symbol : STRING[80];
		wStatus : UINT;
	END_VAR
	VAR
		FOpen : FileOpen;
		FRead : FileRead;
		FClose : FileClose;
		Enable_trig : R_TRIG; (*Триггер старта расчета расхода*)
		Disable_trig : F_TRIG; (*Триггер остановки расчета расхода*)
		dwIdent : UDINT;
	END_VAR
END_FUNCTION_BLOCK
