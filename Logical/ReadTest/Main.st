
PROGRAM _INIT
	(* Insert code here *)
	FBRead1.Enable := TRUE;
	FBRead1.strDevice := 'HardDisk';
	FBRead1.strFile := 'TestFile1';
	FBRead1.BytesToRead := 1;
	Offset := 0;
	FBRead1.Offset := Offset;
	TempString := ''; 
	i := 0;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)	
//	WHILE Read DO
			IF Read THEN
		FBRead1.Read := TRUE;
		FBRead1.Offset := Offset;
		i:= i+1;
		FBRead1();
		IF (FBRead1.byStep = 3) THEN
			IF (FBRead1.ReadedStr <> ',') THEN	
				IF (FBRead1.wStatus <> 65535) THEN
					IF (FBRead1.wStatus = 0) THEN
						IF (FBRead1.ReadedStr <> '$n') OR (FBRead1.ReadedStr <> '$r') THEN
							TempString := CONCAT(TempString,FBRead1.ReadedStr);	
						END_IF
						Offset := Offset + 1;
						FBRead1();
					ELSE
						//					Read := FALSE;
						//					FBRead1.Enable := FALSE;
						//					TempString := '';
						FBRead1();
					END_IF
				ELSE
					FBRead1();
				END_IF
			ELSE
				Read := FALSE;
				FBRead1.Read := FALSE;
				Offset := Offset + 1;
				ReadedValue := STRING_TO_REAL(TempString);
				TempString := ''; 
			END_IF		
		END_IF
//	END_WHILE	
		END_IF
END_PROGRAM

PROGRAM _EXIT
			(* Insert code here *)
	 
END_PROGRAM

