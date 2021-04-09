
PROGRAM _INIT
	(* Initialize variables *)
	FBRead.Enable := TRUE;
	FBRead.strDevice := 'HardDisk';
	FBRead.strFile := 'TestFile1';
	BytesToRead := 1;
	Offset := 0;
END_PROGRAM

PROGRAM _CYCLIC
(* Insert code here *)
	IF Read THEN
		FBRead.Read := TRUE;
		FBRead.BytesToRead := BytesToRead;
		FBRead.Offset := Offset;
			
		flag:= TRUE;
//		WHILE flag DO
			FBRead();
			IF (FBRead.wStatus = 0) AND (FBRead.byStep = 3) THEN
				IF (FBRead.ReadedStr <> '') THEN
					IF FBRead.ReadedStr = Separator THEN
						ReadedValue := STRING_TO_REAL(TempString);
						TempString := '';				
						CASE var1 OF
							1: W[i] := ReadedValue;	
								var1 := var1 + 1;
							3: V[i] := ReadedValue;
								var1 := var1 + 1;
							7: var1 := 0;	
								IF i = 2399 THEN
									i := 0;
								ELSE
									i := i + 1;
								END_IF
							ELSE
								var1 := var1 + 1;
						END_CASE
						flag := FALSE;
					ELSE
						IF (FBRead.ReadedStr <> '$n') AND (FBRead.ReadedStr <> '$r') THEN 
							TempString := CONCAT(TempString,FBRead.ReadedStr);
						ELSE
							FBRead();
						END_IF
					END_IF
					Offset := Offset + 1;
					//				Read := FALSE;
				END_IF
			ELSE
				FBRead();
			END_IF
//		END_WHILE
	ELSE
		FBRead.Read := FALSE;
	END_IF
		
	FBRead();
END_PROGRAM

PROGRAM _EXIT
(* Insert code here *)
	 
END_PROGRAM

