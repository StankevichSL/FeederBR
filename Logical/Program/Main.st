
PROGRAM _INIT		
	tempStr := '';
	RD.DeviceName := 'HardDisk';
	RD.FileName := 'TestFile1';
	RD.Ena := FALSE;
	RD.Offset := 0;
	RD.Size := 1;
	i := 0;
END_PROGRAM

PROGRAM _CYCLIC

	IF Start THEN
		// T
		RD.Ena := TRUE;
		RD();
		WHILE (RD.Symbol <> ',') DO
			IF (RD.wStatus <> 65535) THEN
				IF (RD.wStatus = 0) THEN
					IF (RD.Symbol <> '$n') THEN
						tempStr := CONCAT(tempStr,RD.Symbol);
						RD();
					END_IF
				ELSE
					Start := FALSE;
					RD.Ena := FALSE;
					tempStr := '';
				END_IF
			ELSE
				RD();
			END_IF
		END_WHILE
		T := STRING_TO_REAL(tempStr);
		tempStr := '';
		//W
		RD.Ena := TRUE;
		RD();
		WHILE (RD.Symbol <> ',') DO
			IF (RD.wStatus <> 65535) THEN
				IF (RD.wStatus = 0) THEN
					IF (RD.Symbol <> '$n') THEN
						tempStr := CONCAT(tempStr,RD.Symbol);
						RD();
					END_IF
				ELSE
					Start := FALSE;
					RD.Ena := FALSE;
					tempStr := '';
				END_IF
			ELSE
				RD();
			END_IF
		END_WHILE
		W[i] := STRING_TO_REAL(tempStr);
		Weight := STRING_TO_REAL(tempStr);
		tempStr := '';
		// T
		RD.Ena := TRUE;
		RD();
		WHILE (RD.Symbol <> ',') DO
			IF (RD.wStatus <> 65535) THEN
				IF (RD.wStatus = 0) THEN
					IF (RD.Symbol <> '$n') THEN
						tempStr := CONCAT(tempStr,RD.Symbol);	
						RD();
					END_IF
				ELSE
					Start := FALSE;
					RD.Ena := FALSE;
					tempStr := '';
				END_IF
			ELSE
				RD();
			END_IF
		END_WHILE
		tempStr := '';
		// V
		RD.Ena := TRUE;
		RD();
		WHILE (RD.Symbol <> ',') DO
			IF (RD.wStatus <> 65535) THEN
				IF (RD.wStatus = 0) THEN
					IF (RD.Symbol <> '$n') THEN
						tempStr := CONCAT(tempStr,RD.Symbol);	
						RD();
					END_IF
				ELSE
					Start := FALSE;
					RD.Ena := FALSE;
					tempStr := '';
				END_IF
			ELSE
				RD();
			END_IF
		END_WHILE
		IF (i = 0) THEN
			IF override THEN
				V[0] := V[2399] + STRING_TO_REAL(tempStr);
			ELSE
				V[0] := 0;
			END_IF
		ELSE
			V[i] :=	V[i-1] + STRING_TO_REAL(tempStr);			
		END_IF
		tempStr := '';
		//T
		RD.Ena := TRUE;
		RD();
		WHILE (RD.Symbol <> ',') DO
			IF (RD.wStatus <> 65535) THEN
				IF (RD.wStatus = 0) THEN
					IF (RD.Symbol <> '$n') THEN
						tempStr := CONCAT(tempStr,RD.Symbol);	
						RD();
					END_IF
				ELSE
					Start := FALSE;
					RD.Ena := FALSE;
					tempStr := '';
				END_IF
			ELSE
				RD();
			END_IF
		END_WHILE
		tempStr := '';
		// KT
		RD.Ena := TRUE;
		RD();
		WHILE (RD.Symbol <> ',') DO
			IF (RD.wStatus <> 65535) THEN
				IF (RD.wStatus = 0) THEN
					IF (RD.Symbol <> '$n') THEN
						tempStr := CONCAT(tempStr,RD.Symbol);	
						RD();
					END_IF
				ELSE
					Start := FALSE;
					RD.Ena := FALSE;
					tempStr := '';
				END_IF
			ELSE
				RD();
			END_IF
		END_WHILE
		KT := STRING_TO_REAL(tempStr);
		tempStr := '';
		// T
		RD.Ena := TRUE;
		RD();
		WHILE (RD.Symbol <> ',') DO
			IF (RD.wStatus <> 65535) THEN
				IF (RD.wStatus = 0) THEN
					IF (RD.Symbol <> '$n') THEN
						tempStr := CONCAT(tempStr,RD.Symbol);	
						RD();
					END_IF
				ELSE
					Start := FALSE;
					RD.Ena := FALSE;
					tempStr := '';
				END_IF
			ELSE
				RD();
			END_IF
		END_WHILE
		tempStr := '';
		// RT
		RD.Ena := TRUE;
		RD();
		WHILE (RD.Symbol <> ',') DO
			IF (RD.wStatus <> 65535) THEN
				IF (RD.wStatus = 0) THEN
					IF (RD.Symbol <> '$n') THEN
						tempStr := CONCAT(tempStr,RD.Symbol);	
						RD();
					END_IF
				ELSE
					Start := FALSE;
					RD.Ena := FALSE;
					tempStr := '';
				END_IF
			ELSE
				RD();
			END_IF
		END_WHILE
		RD();
		RT := STRING_TO_REAL(tempStr);
		tempStr := '';
		RD();
				
//		Wei := W;
//		Vel := V;
//		Tim := T;
//		Ena := TRUE;
//		RateCalc.Weigth := W;
		//		RateCalc.MeasuredPowderRate := V;
		IF RD.wStatus <> 0 THEN
			Start := FALSE;
		END_IF
		
		IF i = 2399 THEN
			i := 0;
			override := TRUE;
		ELSE
			i := i + 1;
		END_IF
		
		IF override THEN
			Ktare := FRatePerMinute(ADR(W),ADR(V), 2400);
		ELSE
			IF (i > 100) THEN
				Ktare := FRatePerMinute(ADR(W),ADR(V), i+1);
			END_IF
		END_IF
		
	ELSE
		RD.Ena := FALSE;
		RD();
		i := 0;
		override := FALSE;
	END_IF
	
END_PROGRAM

PROGRAM _EXIT
(* Insert code here *)
	 
END_PROGRAM

