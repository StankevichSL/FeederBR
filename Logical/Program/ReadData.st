
(* TODO: Add your comment here *)
FUNCTION_BLOCK FB_ReadData
	Enable_trig(CLK := Ena);
	Disable_trig(CLK := Ena);
	
	IF Enable_trig.Q THEN
		IF (FileName = '') OR (DeviceName = '') THEN
			Ena := FALSE;
			Status := 'Incorrect FileName or DeviceName';
		ELSE
			Status := '';
			
			(**** Try to open existing file ****)
			FOpen.enable    := 1;
			FOpen.pDevice   := ADR(DeviceName);
			FOpen.pFile     := ADR(FileName);
			FOpen.mode      := FILE_RW;  (* Read and write access *)
			(* Call FBK *)
			FOpen();
			(* Get FBK output information *)
			dwIdent := FOpen.ident;
			wStatus := FOpen.status;
			(* Verify status (20708 -> File doesn't exist) *)
			IF (wStatus = 20708) THEN
				Status := 'File doesnt exist';
			ELSE
				IF (wStatus = 0) THEN
					Status := 'OK';
				ELSE
					IF (wStatus <> 65535) THEN
						
						Status := 'Open file error';

					END_IF
				END_IF
			END_IF
		END_IF		
	ELSE
		IF Ena THEN
			IF ((Offset + Size) > FOpen.filelen) THEN
				Status := 'EOF';
				wStatus := 5;
				Ena := FALSE;
			ELSE
				(**** Read data from file ****)
				(* Initialize file read structure *)
				FRead.enable    := 1;
				FRead.ident     := dwIdent;
				FRead.offset    := Offset;
				FRead.pDest     := ADR(Symbol);
				FRead.len       := Size;
				(* Call FBK *)
				FRead();
				(* Get status *)
				wStatus := FRead.status;
				(* Verify status *)
				IF (wStatus = 0) THEN
					Status := 'OK';
					Offset := Offset + Size;
				ELSE
					IF (wStatus <> 65535) THEN
						Status := 'Reading file error';
						Ena := FALSE;						
					END_IF
				END_IF
			END_IF
		END_IF
	END_IF
	
	IF Disable_trig.Q OR (wStatus = 5) THEN
		(**** Close file ****)
		(* Initialize file close structure *)
		FClose.enable   := 1;
		FClose.ident    := dwIdent;
		(* Call FBK *)
		FClose();
		(* Get status *)
		wStatus := FClose.status;
		Offset := 0;
		(* Verify status *)
		//			IF (wStatus = 0) THEN
		//				byStep := 6;
		//			ELSE
		//				IF (wStatus <> 65535) THEN
		//					byErrorLevel := 5;
		//					byStep := 0;
		//					IF (wStatus = 20799) THEN
		//						wError := FileIoGetSysError();
		//					END_IF
		//				END_IF
		//			END_IF
	END_IF
	
END_FUNCTION_BLOCK
