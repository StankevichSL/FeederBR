
(* TODO: Add your comment here *)
FUNCTION FStdDeviation
	sum := 0;
	FOR i := 0 TO lengthOfArray-1 DO
		sum := sum + Array[i];	
	END_FOR
	avg := sum/lengthOfArray;
	sum := 0;
	FOR i := 0 TO lengthOfArray-1 DO
		sum := sum + EXPT(Array[i]-avg, 2);
	END_FOR
	FStdDeviation := SQRT(sum/lengthOfArray);		
END_FUNCTION