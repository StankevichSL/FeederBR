
PROGRAM _INIT
	(* Insert code here *)
	
	MpAlarmXCore_0.MpLink := ADR(gAlarmXCore);
	MpAlarmXCore_0.Enable := TRUE;
	
	ConfigP.AlarmPrefix := '{$$FeederAlarms/Prefix1}';
	ConfigP.WarningWeight := 0.3;
	ConfigP.AlarmWeight := 0.1;	
	ConfigP.ResetWeightLimit := 0.1;	
	ConfigP.DefaultTareK := 0.85;	
	ConfigP.DeviationLimit := 0.2;
	ConfigP.TareCalcDelay := T#10s;
	ConfigP.ToGoToAutoDelay := T#10s;
	ConfigP.BufferDelay := T#10s;
	ConfigP.DeviationCalcDelay := T#10s;	
	ConfigP.Handler.ACPConfigLink := ADR(gAxis01);
	ConfigP.Handler.AxisBasicParLink := ADR(Par1);
	ConfigP.Handler.AxisConfigLink := ADR(gLinkFeeder1);
	ConfigP.Handler.AxisCyclicSetParLink := ADR(CyclicSet1);
	ConfigP.Handler.PostpurgeTime := T#5s;
	ConfigP.Handler.PrepurgeTime := T#5s;
	ConfigP.Handler.GasCalibrateOut.A :=  -0.12890000641345978;
	ConfigP.Handler.GasCalibrateOut.B := 659.57000732421875;
	ConfigP.Handler.GasCalibrateOut.C := 105.16000366210938;
	ConfigP.Handler.GasCalibrateOut.MaxValue := 9969;
	ConfigP.Handler.GasCalibrateOut.MinValue := 0;	
	ConfigP.WeightCalibrate.A := 0;
	ConfigP.WeightCalibrate.B := 5.82e-05;
	ConfigP.WeightCalibrate.C := -5.4242;
	ConfigP.WeightCalibrate.MaxValue := 60;
	ConfigP.WeightCalibrate.MinValue := 0;	
	ConfigP.Handler.GasCalibrateIn.A := 0;
	ConfigP.Handler.GasCalibrateIn.B := 0.0038000000640749931;
	ConfigP.Handler.GasCalibrateIn.C := -12.600000381469727;
	ConfigP.Handler.GasCalibrateIn.MaxValue := 50;
	ConfigP.Handler.GasCalibrateIn.MinValue := 0;
	ConfigS := ConfigP;
	
	ConfigS.AlarmPrefix := '{$$FeederAlarms/Prefix2}';
	ConfigS.Handler.ACPConfigLink := ADR(gAxis02);
	ConfigS.Handler.AxisBasicParLink := ADR(Par2);
	ConfigS.Handler.AxisConfigLink := ADR(gLinkFeeder2);
	ConfigS.Handler.AxisCyclicSetParLink := ADR(CyclicSet2);
	ConfigS.WeightCalibrate.C := -5.2;
	
	FeederConfig.PrimaryFeeder := ConfigP;
	FeederConfig.SecondaryFeeder := ConfigS;
	FeederConfig.DualFeederMode := FALSE;
	
	FeederBlock.Control.PrimaryFeeder.Handler.KZP := 100;
	FeederBlock.Control.PrimaryFeeder.Handler.KZU := 0;
	FeederBlock.Config := ADR(FeederConfig);
	FeederBlock.AlarmXCore := ADR(gAlarmXCore);
	FeederBlock.Enable := TRUE;
	
	var := 10;
	Counter.CounterLink := ADR(var);
	Counter.Delta := 0.1;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	MpAlarmXCore_0();
	FeederBlock();
	Counter.Weight := FeederBlock.UserInfo.PrimaryFeeder.Weight;
	Counter();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM