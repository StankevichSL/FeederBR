
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
	
	Config.Handler.ACPConfigLink := ADR(gAxis01);
	Config.Handler.AxisBasicParLink := ADR(Par1);
	Config.Handler.AxisConfigLink := ADR(gLinkFeeder1);
	Config.Handler.AxisCyclicSetParLink := ADR(CyclicSet1);
	Config.Handler.PostpurgeTime := T#5s;
	Config.Handler.PrepurgeTime := T#5s;
	Config.Handler.GasCalibrateOut.A :=  -0.12890000641345978;
	Config.Handler.GasCalibrateOut.B := 659.57000732421875;
	Config.Handler.GasCalibrateOut.C := 105.16000366210938;
	Config.Handler.GasCalibrateOut.MaxValue := 9969;
	Config.Handler.GasCalibrateOut.MinValue := 0;
	
	
	Config.WeightCalibrate.A := 0;
	Config.WeightCalibrate.B := 5.82e-05;
	Config.WeightCalibrate.C := -5.4242;
	Config.WeightCalibrate.MaxValue := 60;
	Config.WeightCalibrate.MinValue := 0;
	
	Config.GasCalibrateIn.A := 0;
	Config.GasCalibrateIn.B := 0.0038000000640749931;
	Config.GasCalibrateIn.C := -12.600000381469727;
	Config.GasCalibrateIn.MaxValue := 50;
	Config.GasCalibrateIn.MinValue := 0;
	
	FeederBlock.Config.PrimaryFeeder := Config;
	Config.Handler.ACPConfigLink := ADR(gAxis02);
	Config.Handler.AxisBasicParLink := ADR(Par2);
	Config.Handler.AxisConfigLink := ADR(gLinkFeeder2);
	Config.Handler.AxisCyclicSetParLink := ADR(CyclicSet2);
	Config.WeightCalibrate.C := -5.2;
	FeederBlock.Config.SecondaryFeeder := Config;
	
	FeederBlock.Control.PrimaryFeeder.Handler.KZP := 100;
	FeederBlock.Control.PrimaryFeeder.Handler.KZU := 10;
	//	Handler.Config := Config.Handler;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	FeederBlock();
//	Handler();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM