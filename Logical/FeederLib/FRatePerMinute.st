
(* TODO: Add your comment here *)
FUNCTION FRatePerMinute
	sumx := 0;
	sumy := 0;
	sump := 0;
	sumx2 := 0;
	sumxy := 0;
	sumxp := 0;							

	FOR i := 0 TO lengthOfArray-1 DO
		weight ACCESS (weightArrayAdr + 32*i);
		position ACCESS (positionArrayAdr + 32*i);		
		sumy := sumy + weight;
		sump := sump + position;		
		sumxy := sumxy + (i*weight);
		sumxp := sumxp + (i*position);
	END_FOR
	sumx := (lengthOfArray*(lengthOfArray+1))/2;
	sumx2 := (lengthOfArray*(lengthOfArray+1)*(2*lengthOfArray+1))/6;
		
	sxx := sumx2 - (sumx*sumx)/UINT_TO_REAL(lengthOfArray);
	sxy := sumxy - (sumx*sumy)/UINT_TO_REAL(lengthOfArray);		
	sxp := sumxp - (sumx*sump)/UINT_TO_REAL(lengthOfArray);	
	k := sxy/sxx;
	kp := sxp/sxx;					
	
	FLinearRegrationKoef := (-k*60)/kp;					
END_FUNCTION
