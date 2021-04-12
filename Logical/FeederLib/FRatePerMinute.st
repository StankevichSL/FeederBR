
(* TODO: Add your comment here *)
FUNCTION FRatePerMinute
	sumx := 0;
	sumy := 0;
	sump := 0;
	sumx2 := 0;
	sumxy := 0;
	sumxp := 0;							

	FOR i := 0 TO lengthOfArray-1 DO
		sumy := sumy + W[i];
		sump := sump + V[i];		
		sumxy := sumxy + (i*W[i])*(UDINT_TO_LREAL(i+1)/1000);
		sumxp := sumxp + (i*W[i])*(UDINT_TO_LREAL(i+1)/1000);
	END_FOR
	sumx := ((lengthOfArray*(lengthOfArray+1))/2)/1000;
	sumx2 := (((lengthOfArray/10000)*((lengthOfArray+1)/10000)*((2*lengthOfArray+1)/10000))/6);
		
	sxx := sumx2 - (sumx*sumx)/UDINT_TO_REAL(lengthOfArray);
	sxy := sumxy - (sumx*sumy)/UDINT_TO_REAL(lengthOfArray);		
	sxp := sumxp - (sumx*sump)/UDINT_TO_REAL(lengthOfArray);	
//	k := sxy/sxx;
//	kp := sxp/sxx;					
	
	FRatePerMinute := LREAL_TO_REAL(((sxy/sxx)*10)/(sxp/sxx));					
END_FUNCTION
