
(* TODO: Add your comment here *)
FUNCTION_BLOCK FBSpendTotalizer
	
	CASE Status OF
		SPENDTOTALIZER_INIT:
			TON_WeightCheckPeriod.PT := Period;
			Status := SPENDTOTALIZER_WAIT;
		SPENDTOTALIZER_BIZY:			
			TON_WeightCheckPeriod();
			IF TON_WeightCheckPeriod.Q THEN
				IF ((TempVal - Weight) > Delta) AND ((TempVal - Weight) > 0) THEN
					CounterLink := CounterLink + (TempVal - Weight);
					TempVal := Weight;
				END_IF
				TON_WeightCheckPeriod.IN := FALSE;
				TON_WeightCheckPeriod();
				TON_WeightCheckPeriod.IN := TRUE;
			END_IF	
			IF NOT Active THEN
				IF ((TempVal - Weight) < Delta) AND ((TempVal - Weight) > 0) THEN
					CounterLink := CounterLink + (TempVal - Weight);
					TempVal := Weight;
				END_IF
				TON_WeightCheckPeriod.IN := FALSE;
				TON_WeightCheckPeriod();
				Status := SPENDTOTALIZER_PAUSE;
			END_IF
		SPENDTOTALIZER_PAUSE:
			IF Active THEN
				IF (ABS(TempVal - Weight) > 10*Delta) THEN
					Status := SPENDTOTALIZER_WAIT;
				ELSE
					Status := SPENDTOTALIZER_BIZY;				
				END_IF
			END_IF
			TON_WeightCheckPeriod.IN := TRUE;
		SPENDTOTALIZER_WAIT:
			IF Active THEN
				TempVal := Weight;
				Status := SPENDTOTALIZER_BIZY;
			END_IF
	END_CASE
	
END_FUNCTION_BLOCK
