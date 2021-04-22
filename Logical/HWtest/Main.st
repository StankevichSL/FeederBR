
PROGRAM _INIT
	(* Insert code here *)
	
	Config.AlarmPrefix := '123123';
	
	Config.WarningWeight := 0.3;
	Config.AlarmWeight := 0.1;	
	Config.ResetWeightLimit := 0.1;
	
	Config.DefaultTareK := 1;	
	Config.DeviationLimit := 0.1;
	Config.EnableAutoRateControl := FALSE;
	
	
	Config.TareCalcDelay := T#10s;
	Config.ToGoToAutoDelay := T#10s;
	Config.BufferDelay := T#10s;
	Config.DeviationCalcDelay := T#10s;
	
	Config.Handler.ACPConfigLink := ADR();
	Config.Handler.AxisBasicParLink := ADR();
	Config.Handler.AxisConfigLink := ADR();
	Config.Handler.AxisCyclicSetParLink := ADR();
	Config.Handler.PostpurgeTime := T#5s;
	Config.Handler.PrepurgeTime := T#5s;
	Config.Handler.GasCalibrateOut.A := 0;
	Config.Handler.GasCalibrateOut.B := 0.0038000000640749931;
	Config.Handler.GasCalibrateOut.C := -12.600000381469727;
	Config.Handler.GasCalibrateOut.MaxValue := 50;
	Config.Handler.GasCalibrateOut.MinValue := 0;
	
	
	Config.WeightCalibrate.A := 0;
	Config.WeightCalibrate.B := 5.82e-05;
	Config.WeightCalibrate.C := -5.4242;
	Config.WeightCalibrate.MaxValue := 60;
	Config.WeightCalibrate.MinValue := 0;
	
	Config.GasCalibrateIn.A := -0.12890000641345978;
	Config.GasCalibrateIn.B := 659.57000732421875;
	Config.GasCalibrateIn.C := 105.16000366210938;
	Config.GasCalibrateIn.MaxValue := 9969;
	Config.GasCalibrateIn.MinValue := 0;
	

END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM