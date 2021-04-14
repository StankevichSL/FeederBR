
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
		sump := sump + V[i];
		sumx := sumx + T[i];
		sumx2 := sumx2 + T[i]*T[i];
		sumxy := sumxy + (W[i])*(T[i]);
		sumxp := sumxp + (V[i])*(T[i]);
	END_FOR
	
	sxx := sumx2 - (sumx*sumx)/UDINT_TO_LREAL(lengthOfArray);
	sxy := sumxy - (sumx*sumy)/UDINT_TO_LREAL(lengthOfArray);
	sxp := sumxp - (sumx*sump)/UDINT_TO_LREAL(lengthOfArray);
	
	FFeederRatio := LREAL_TO_REAL(-(sxy/sxx)/(sxp/sxx))*6;
END_FUNCTION
