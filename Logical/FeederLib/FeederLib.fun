(*Insert your comment here.*)

{REDUND_ERROR} FUNCTION FRatePerMinute : REAL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		W : REFERENCE TO ARRAY[0..2399] OF REAL;
		V : REFERENCE TO ARRAY[0..2399] OF REAL;
		lengthOfArray : UDINT;
	END_VAR
	VAR
		sumx : LREAL;
		sumy : LREAL;
		sump : LREAL;
		sumx2 : LREAL;
		sumxy : LREAL;
		sumxp : LREAL;
		i : UDINT;
		weight : REFERENCE TO REAL;
		position : REFERENCE TO REAL;
		sxx : LREAL;
		sxy : LREAL;
		sxp : LREAL;
	END_VAR
END_FUNCTION
