FUNCTION InRange_Percent
	
	Value := ActualValue - TargetValue ;
	DeviationValue := TargetValue*(DeviationInPercents/100);
	
	
	IF (Value <= DeviationValue) AND (Value >= DeviationValue*(-1)) THEN
		InRange_Percent := TRUE ;
	END_IF
	
	IF (Value > DeviationValue) AND (Value < DeviationValue*(-1)) THEN
		InRange_Percent := FALSE ;
	END_IF
	
	
END_FUNCTION
