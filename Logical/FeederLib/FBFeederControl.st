
(* TODO: Add your comment here *)
FUNCTION_BLOCK FBFeederControl
	IF Enable THEN
		CASE Status OF
			FEEDCTRL_ERROR:
				// error case
			FEEDCTRL_INIT:
				// добавить проверку чтобы AxisConfigLink != 0
				AxisBasic.MpLink := Config.AxisConfigLink;
				AxisBasic.Enable := TRUE;
				AxisBasic.Parameters := Config.AxisBasicParLink;
				AxisBasic.Axis := Config.ACPConfigLink;
			
				AxisCyclicSet.MpLink := Config.AxisConfigLink;
				AxisCyclicSet.Enable := TRUE;
				AxisCyclicSet.Parameters := Config.AxisCyclicSetParLink;
			
				IF (AxisBasic.Active) THEN 
					UserInfo.Active := TRUE;
					AxisBasic.Power := 1;
					IF (AxisBasic.PowerOn) THEN 
						IF (AxisBasic.IsHomed = 0) THEN 
							AxisBasic.Home := 1;
						ELSE
							AxisBasic.Home := 0;
							IF (AxisCyclicSet.Active) THEN
								AxisCyclicSet.CyclicVelocity := 1;
								Status := FEEDCTRL_READY_TO_FEED;
							END_IF;
						END_IF;
					END_IF;
				END_IF;			
			FEEDCTRL_READY_TO_FEED:
				IF (Start) THEN	
					Status := FEEDCTRL_PREPURGE;
				END_IF
			
				IO.Out.aoGasRate := 0;
				IO.Out.doShutOff := TRUE;
				IO.Out.doMixer := FALSE;
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
			
				IO.Out.aoGasRate := Calibrate(Control.GasRate,Config.GasCalibrateOut);
				IO.Out.doShutOff := FALSE;
				IO.Out.doMixer := TRUE;			
			FEEDCTRL_FEEDING:
				IF (Start) THEN				
					AxisCyclicSet.Velocity := ((Control.PowderRate*(100+Control.KZU))/Control.KZP)*TareK;
				ELSE
					AxisCyclicSet.Velocity := 0;
					Status := FEEDCTRL_POSTPURGE;	
				END_IF
			
				IO.Out.aoGasRate := Calibrate(Control.GasRate,Config.GasCalibrateOut);			
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
			
				IO.Out.aoGasRate := Calibrate(Control.GasRate,Config.GasCalibrateOut);
		END_CASE	
		AxisBasic();
		AxisCyclicSet();	
		UserInfo.ActualSpeed := AxisBasic.Velocity;
	END_IF

END_FUNCTION_BLOCK
