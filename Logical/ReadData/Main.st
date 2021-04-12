
PROGRAM _INIT
	(* Insert code here *)
	Step := 1;
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
									IF flag THEN
										V[0] := V[2399] + ReadedValue/600;
									ELSE
										V[0] := 0;
									END_IF
								ELSE
									V[i] := V[i-1] + ReadedValue/60000;
								END_IF
								val := val + 1;
							7: val := 0;	
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

