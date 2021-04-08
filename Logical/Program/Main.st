
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
		RD();
		tempStr := RD.Symbol;
		Start := FALSE;
	END_IF
	
END_PROGRAM

PROGRAM _EXIT
(* Insert code here *)
	 
END_PROGRAM