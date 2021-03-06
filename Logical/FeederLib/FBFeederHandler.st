
(* TODO: Add your comment here *)
FUNCTION_BLOCK FBFeederHandler
	IF Enable THEN
		CASE Status OF
			FEEDCTRL_ERROR:
				// error case
			FEEDCTRL_INIT:		
				AxisBasic.MpLink := Config.AxisConfigLink;
				AxisBasic.Enable := TRUE;
				AxisBasic.Parameters := Config.AxisBasicParLink;
				AxisBasic.Axis := Config.ACPConfigLink;
		
		
				AxisCyclicSet.MpLink := Config.AxisConfigLink;
				AxisCyclicSet.Enable := TRUE;
				AxisCyclicSet.Parameters := Config.AxisCyclicSetParLink;
				
				IF (AxisBasic.Active) THEN 					
					AxisBasic.Power := 1;
					IF (AxisBasic.PowerOn) THEN 
						IF (AxisBasic.IsHomed = 0) THEN 
							AxisBasic.Home := 1;
						ELSE
							AxisBasic.Home := 0;
							IF (AxisCyclicSet.Active) THEN
								AxisCyclicSet.CyclicVelocity := 1;
								Status := FEEDCTRL_READY_TO_FEED;
							END_IF
						END_IF
					END_IF
				END_IF
				
			FEEDCTRL_READY_TO_FEED:
				IF (Start) THEN	
					Status := FEEDCTRL_PREPURGE;
				END_IF
				UserInfo.Active := FALSE;
				IOout.aoGasRate := 0;
				IOout.doShutOff := TRUE;
				IOout.doMixer := FALSE;
			FEEDCTRL_PREPURGE:
				IF (Start) THEN
					IF (TON_Prepurge.Q) THEN 
						TON_Prepurge.IN := 0;		
						Status := FEEDCTRL_FEEDING;
					ELSE 
						TON_Prepurge.IN := 1;
					END_IF
				ELSE
					TON_Prepurge.IN := 0;
					Status := FEEDCTRL_READY_TO_FEED;
				END_IF
				TON_Prepurge(PT := Config.PrepurgeTime);
			
				IOout.aoGasRate := Calibrate(Control.GasRate,Config.GasCalibrateOut);
				IOout.doShutOff := FALSE;
				IOout.doMixer := TRUE;		
				
				UserInfo.Active := TRUE;
			FEEDCTRL_FEEDING:
				IF (Start) THEN				
					AxisCyclicSet.Velocity := ((LIMIT(0,(Control.PowderRate/(TareK*10)),100)*(100+Control.KZU))/Control.KZP)*Config.Ratio/0.6;
				ELSE
					AxisCyclicSet.Velocity := 0;
					Status := FEEDCTRL_POSTPURGE;	
				END_IF
			
				IOout.aoGasRate := Calibrate(Control.GasRate,Config.GasCalibrateOut);			
			FEEDCTRL_POSTPURGE:
				IF (Start) THEN
					TON_Postpurge.IN := 0;
					Status := FEEDCTRL_FEEDING;
				ELSE
					IF (TON_Postpurge.Q) THEN
						TON_Postpurge.IN := 0;
						Status := FEEDCTRL_READY_TO_FEED;
					ELSE
						TON_Postpurge.IN := 1;
					END_IF
				END_IF			
				TON_Postpurge(PT := Config.PostpurgeTime);
			
				IOout.aoGasRate := Calibrate(Control.GasRate,Config.GasCalibrateOut);
		END_CASE	
		// �������� �������� ����� AxisConfigLink != 0
		AxisBasic();
		AxisCyclicSet();
		
		UserInfo.ActualSpeed := AxisBasic.Velocity;
		UserInfo.TransportGasRate := CalibrateREAL(IOin.aiGasRate,Config.GasCalibrateIn);
	END_IF

END_FUNCTION_BLOCK
