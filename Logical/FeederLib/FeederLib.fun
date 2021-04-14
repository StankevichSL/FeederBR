(*Insert your comment here.*)

{REDUND_ERROR} FUNCTION FFeederRatio : REAL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		W : REFERENCE TO ARRAY[0..2399] OF REAL;
		V : REFERENCE TO ARRAY[0..2399] OF REAL;
		T : REFERENCE TO ARRAY[0..2399] OF REAL;
		lengthOfArray : UDINT;
	END_VAR
	VAR
		sxx : LREAL;
		sxy : LREAL;
		sxp : LREAL;
		sumx : LREAL;
		sumy : LREAL;
		sump : LREAL;
		sumx2 : LREAL;
		sumxy : LREAL;
		sumxp : LREAL;
		i : UDINT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION FStdDeviation : REAL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Array : REFERENCE TO ARRAY[0..2399] OF REAL;
		lengthOfArray : UDINT;
	END_VAR
	VAR
		avg : REAL;
		sum : REAL;
	END_VAR
	VAR_INPUT
		i : UDINT;
	END_VAR
END_FUNCTION
