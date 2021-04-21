
(* Calibrate output signal by Ax2+Bx+C *)
FUNCTION Calibrate 
	
	value := CalibrationData.A*IN*IN+CalibrationData.B*IN+CalibrationData.C;
	Calibrate := REAL_TO_INT(LIMIT(CalibrationData.MinValue, value, CalibrationData.MaxValue));
	
END_FUNCTION

(* Calibrate output signal by Ax2+Bx+C *)
FUNCTION CalibrateREAL 
	
	value := CalibrationData.A*IN*IN+CalibrationData.B*IN+CalibrationData.C;
	CalibrateREAL := LIMIT(CalibrationData.MinValue, value, CalibrationData.MaxValue);
	
END_FUNCTION