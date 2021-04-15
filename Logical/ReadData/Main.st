
PROGRAM _INIT
	(* Insert code here *)
	Step := 1;
	i := 0;
	j := 0;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	IF Start THEN
		CASE Step OF
			0 : (*error*)
			1 : (*init*) 
				i := 0;
				Step := 4;
				offset := 0;
				val := 0;
				flag := FALSE;
				FBRead.Enable := TRUE;
				FBRead.strDevice := 'HardDisk';
				FBRead.strFile := 'TestFile1';
			2 : (*parsing*)
				SeparatorPosition := FIND(buffer_str,',');
				WHILE SeparatorPosition > 0 DO
					//				IF SeparatorPosition > 0 THEN
					IF SeparatorPosition > 1 THEN
						temp_str := MID(buffer_str,SeparatorPosition - 1,1);
						NewLinePosition := FIND(temp_str,'$n');
						IF NewLinePosition > 0 THEN
							temp_str := DELETE(temp_str,NewLinePosition,1);
						END_IF
						buffer_str := DELETE(buffer_str,SeparatorPosition,1);
						ReadedValue := STRING_TO_REAL(temp_str);
						temp_str := '';
						CASE val OF
							1: W[i] := ReadedValue;
								val := val + 1;
							3: IF i=0 THEN
									Velocity := ReadedValue;
									IF flag THEN
										V[0] := V[2399] + Velocity/100000;
										T[0] := T[2399] + 0.001;
									ELSE
										V[0] := 0;
										T[0] := 0;
									END_IF
								ELSE
									V[i] := V[i-1] + Velocity/100000;
									T[i] := T[i-1] + 0.001;
								END_IF
								val := val + 1;
							7: val := 0;								
								IF flag THEN
									Ktare[j] := FFeederRatio(ADR(W), ADR(V), ADR(T), 2400);
									IF flag1 THEN
										StdDeviation := FStdDeviation(ADR(Ktare),2400);
									ELSE
										StdDeviation := FStdDeviation(ADR(Ktare),j);
									END_IF
									Rate := Velocity*Ktare[j];
									IF j = 2399 THEN
										j := 0;	
										flag1 := TRUE;
									ELSE
										j := j + 1;
									END_IF
								ELSE
									IF i > 200 THEN
										Ktare[j] := FFeederRatio(ADR(W), ADR(V), ADR(T), i+1);
										Rate := Velocity*Ktare[j];
										IF (j>10) THEN
											StdDeviation := FStdDeviation(ADR(Ktare),j);
										END_IF
										IF j = 2399 THEN
											j := 0;									
										ELSE
											j := j + 1;
										END_IF
									END_IF
								END_IF
								
								IF i = 2399 THEN
									i := 0;
									flag := TRUE;
								ELSE
									i := i + 1;
								END_IF
							ELSE
								val := val + 1;
						END_CASE					
					ELSE
						buffer_str := DELETE(buffer_str,1,1);
					END_IF
					//				ELSE
					SeparatorPosition := FIND(buffer_str,',');
				END_WHILE
				Step := 3;				
				//				END_IF
			3 : (*end of buffer*)
				Step := 4;
				offset := offset + BytesToRead - LEN(buffer_str);
			4 : (*read file*)
				FBRead.Read := TRUE;
				FBRead.BytesToRead := BytesToRead;
				FBRead.Offset := offset;
				FBRead();
				IF (FBRead.wStatus = 0) AND (FBRead.byStep = 3) THEN
					Step := 5;
					buffer_str := FBRead.ReadedStr;
				END_IF
			5 : (*check end of line*)
				//				NewLinePosition := FIND(buffer_str,'$n');
				Step := 2;
			ELSE
				Step := 0;
		END_CASE
	END_IF
END_PROGRAM

PROGRAM _EXIT
				(* Insert code here *)
	 
				END_PROGRAM

