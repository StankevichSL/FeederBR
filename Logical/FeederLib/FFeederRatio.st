
(* TODO: Add your comment here *)
FUNCTION FFeederRatio
	sumx := 0;
	sumy := 0;
	sump := 0;
	sumx2 := 0;
	sumxy := 0;
	sumxp := 0;							

	FOR i := 0 TO lengthOfArray-1 DO
		sumy := sumy + W[i];
		sump := sump + V[i]/1000;		
		sumxy := sumxy + (W[i])*(UDINT_TO_LREAL(i+1));
		sumxp := sumxp + (V[i]/1000)*(UDINT_TO_LREAL(i+1));
	END_FOR
	sumx := ((lengthOfArray*(lengthOfArray+1))/2);
	sumx2 := (((lengthOfArray)*((lengthOfArray+1))*((2*lengthOfArray+1)))/6);
		
	sxx := sumx2 - (sumx*sumx)/UDINT_TO_LREAL(lengthOfArray);
	sxy := sumxy - (sumx*sumy)/UDINT_TO_LREAL(lengthOfArray);		
	sxp := sumxp - (sumx*sump)/UDINT_TO_LREAL(lengthOfArray);	
//	k := sxy/sxx;
//	kp := sxp/sxx;					
	
	FFeederRatio := LREAL_TO_REAL(-(sxy/sxx)/(sxp/sxx))*600;					
END_FUNCTION
