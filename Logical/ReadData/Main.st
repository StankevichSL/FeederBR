
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
			
		flag:= FALSE;
		//		WHILE flag DO
		FBRead();
		IF (FBRead.wStatus = 0) AND (FBRead.byStep = 3) THEN
			IF (FBRead.ReadedStr <> '') THEN
				IF FBRead.ReadedStr = Separator THEN
					ReadedValue := STRING_TO_REAL(TempString);
					TempString := '';				
					CASE var1 OF
						1: Wei := ReadedValue;
							W[i] := Wei;	
							var1 := var1 + 1;
						3: Vel := ReadedValue;
							IF i=0 THEN
								IF flag THEN
									V[0] := V[2399] + Vel/60;
								ELSE
									V[0] := 0;
								END_IF
							ELSE
								V[i] := V[i-1] + Vel/60;
							END_IF
							var1 := var1 + 1;
						7: var1 := 0;	
							IF i = 2399 THEN
								i := 0;
								flag := TRUE;
							ELSE
								i := i + 1;
							END_IF
							IF flag THEN
								Ktare := FRatePerMinute(ADR(W), ADR(V), 2400);
							ELSE
								IF i > 200 THEN
									Ktare := FRatePerMinute(ADR(W), ADR(V), i + 1);
								END_IF
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

