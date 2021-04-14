
(* TODO: Add your comment here *)
FUNCTION_BLOCK FBFeederControl
	CASE Status OF
		FEEDCTRL_ERROR:
			// error case
		FEEDCTRL_INIT:
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
						END_IF;
					END_IF;
				END_IF;
			END_IF;			
		FEEDCTRL_READY_TO_FEED:
			IF (Start) THEN	
				Status := FEEDCTRL_PREPURGE;
			END_IF
			
			FlowReg := 0;
			Shutoff := TRUE;
			Mixer := FALSE;
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
			TON_Prepurge(PT := PrepurgeTime);
			
			FlowReg := GasSetpoint;
			Shutoff := FALSE;
			Mixer := TRUE;			
		FEEDCTRL_FEEDING:
			IF (Start) THEN				
				AxisCyclicSet.Velocity := PowderSetpoint;
			ELSE
				AxisCyclicSet.Velocity := 0;
				Status := FEEDCTRL_POSTPURGE;	
			END_IF
			
			FlowReg := GasSetpoint;			
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
			TON_Postpurge(PT := PostpurgeTime);
			
			FlowReg := GasSetpoint;
	END_CASE
	
	AxisBasic(MpLink := AxisConfigLink, Enable := 1, Parameters := ADR(AxisBasicPar), Axis := ACPConfigLink);
	AxisCyclicSet(MpLink := AxisConfigLink, Enable := 1, Parameters := ADR(AxisCyclicSetPar));	
	ActualSpeed := AxisBasic.Velocity;

END_FUNCTION_BLOCK
