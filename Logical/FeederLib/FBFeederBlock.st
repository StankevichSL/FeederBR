
(* TODO: Add your comment here *)
FUNCTION_BLOCK FBFeederBlock
	IF Enable THEN
		CASE Status OF
			FEEDBLOCK_ERROR:
			FEEDBLOCK_INIT:
				PrimaryFeeder.Config := Config.PrimaryFeeder;
				PrimaryFeeder.AlarmXCore := AlarmXCore;
				// тарировочный для ручного ружима
				Control.PrimaryFeeder.TareK := PrimaryFeeder.Config.DefaultTareK;
				PrimaryFeeder.IOin := IOin.PrimaryFeeder;
				PrimaryFeeder.Enable := TRUE;
				TON_UpdateDefaultTareK1.PT := Config.PrimaryFeeder.DefaultTareKUpdateDelay;
				IF Config.DualFeederMode THEN
					SecondaryFeeder.AlarmXCore := AlarmXCore;
					SecondaryFeeder.Config := Config.SecondaryFeeder;
					// тарировочный для ручного ружима
					Control.SecondaryFeeder.TareK := SecondaryFeeder.Config.DefaultTareK;
					SecondaryFeeder.IOin := IOin.SecondaryFeeder;
					SecondaryFeeder.Enable := TRUE;
					TON_UpdateDefaultTareK2.PT := Config.SecondaryFeeder.DefaultTareKUpdateDelay;
					SecondaryFeeder();
					IF (PrimaryFeeder.Status = FEED_READY) AND (SecondaryFeeder.Status = FEED_READY) THEN
						Status := FEEDBLOCK_DUAL;
					END_IF
					TON_SwitchFeeder1Off.PT := Config.SecondaryFeeder.Handler.PrepurgeTime;
					TOF_SwitchFeeder2Off.PT := Config.PrimaryFeeder.Handler.PrepurgeTime;
				ELSE
					IF (PrimaryFeeder.Status = FEED_READY) THEN
						Status := FEEDBLOCK_SINGLE;
					END_IF
				END_IF		
				PrimaryFeeder();
			FEEDBLOCK_SINGLE:
				// режим работы когда есть только одна колба
				PrimaryFeeder.Config := Config.PrimaryFeeder;
				PrimaryFeeder.Control := Control.PrimaryFeeder;
				PrimaryFeeder.IOin := IOin.PrimaryFeeder;
	//			PrimaryFeeder.Start := Control.PrimaryStart;
				PrimaryFeeder();
				
				// обновление тарировочного коэффициента по умолчанию	
				IF PrimaryFeeder.UserInfo.IsAUTO THEN
					TON_UpdateDefaultTareK1.IN := TRUE;
					TON_UpdateDefaultTareK1();
					IF TON_UpdateDefaultTareK1.Q THEN
						Config.PrimaryFeeder.DefaultTareK := PrimaryFeeder.UserInfo.TareK;
						PrimaryFeeder.Config.DefaultTareK := Config.PrimaryFeeder.DefaultTareK;
						// тарировочный для ручного ружима
						Control.PrimaryFeeder.TareK := PrimaryFeeder.Config.DefaultTareK;
						TON_UpdateDefaultTareK1.IN := FALSE;
						TON_UpdateDefaultTareK1();
					END_IF	
				END_IF
				
				// Обновление веса тары
				IF Control.PrimaryFeeder.UpdateTareWeight THEN
					Config.PrimaryFeeder.TareWeight := UserInfo.PrimaryFeeder.Weight;
					Control.PrimaryFeeder.UpdateTareWeight := FALSE; 
				END_IF
				
				IOout.PrimaryFeeder := PrimaryFeeder.IOout;
				UserInfo.PrimaryFeeder := PrimaryFeeder.UserInfo;
			FEEDBLOCK_DUAL:
				// режим работы при наличии 2-х колб
				PrimaryFeeder.Config := Config.PrimaryFeeder;
				PrimaryFeeder.IOin := IOin.PrimaryFeeder;
				
				SecondaryFeeder.Config := Config.SecondaryFeeder;
				SecondaryFeeder.IOin := IOin.SecondaryFeeder;
				
				IF Config.SeparateMode THEN
					PrimaryFeeder.Control := Control.PrimaryFeeder;
					SecondaryFeeder.Control := Control.SecondaryFeeder;
				ELSE
					IF Config.FeederSwitch THEN
						Control.PrimaryFeeder.ManualTareControl := FALSE;
						SecondaryFeeder.Control := Control.SecondaryFeeder;
						SecondaryFeeder.Control.Handler.Robot := Control.PrimaryFeeder.Handler.Robot;						
					ELSE
						Control.SecondaryFeeder.ManualTareControl := FALSE;
						PrimaryFeeder.Control := Control.PrimaryFeeder;
					END_IF
					//Delayed switch off of feeders when FeederChoice is changed
					TON_SwitchFeeder1Off(IN := Config.FeederSwitch); //When FeederChoice is True Timer is activated
					TOF_SwitchFeeder2Off(IN := Config.FeederSwitch); //When FeederChoice is False Timer is activated
		
					R_TRIG_SwitchFeeder1Off(CLK := TON_SwitchFeeder1Off.Q); // Catching timer expiration  and generating pulse to switch off feeder
					F_TRIG_SwitchFeeder2Off(CLK := TOF_SwitchFeeder2Off.Q);
					IF (R_TRIG_SwitchFeeder1Off.Q) THEN						
						PrimaryFeeder.Control.Handler.Robot.Start := FALSE;
					END_IF
					IF (F_TRIG_SwitchFeeder2Off.Q) THEN
						SecondaryFeeder.Control.Handler.Robot.Start := FALSE;
					END_IF
				END_IF
				
				PrimaryFeeder();
				SecondaryFeeder();
				
				UserInfo.PrimaryFeeder := PrimaryFeeder.UserInfo;
				UserInfo.SecondaryFeeder := SecondaryFeeder.UserInfo;
				
				IOout.PrimaryFeeder := PrimaryFeeder.IOout;	
				IOout.SecondaryFeeder := SecondaryFeeder.IOout;	
				
				// обновление тарировочного коэффициента по умолчанию	
				IF PrimaryFeeder.UserInfo.IsAUTO THEN
					TON_UpdateDefaultTareK1.IN := TRUE;
					TON_UpdateDefaultTareK1();
					IF TON_UpdateDefaultTareK1.Q THEN
						Config.PrimaryFeeder.DefaultTareK := PrimaryFeeder.UserInfo.TareK;
						PrimaryFeeder.Config.DefaultTareK := Config.PrimaryFeeder.DefaultTareK;
						// тарировочный для ручного ружима
						Control.PrimaryFeeder.TareK := PrimaryFeeder.Config.DefaultTareK;
						TON_UpdateDefaultTareK1.IN := FALSE;
						TON_UpdateDefaultTareK1();
					END_IF	
				END_IF
				
				// обновление тарировочного коэффициента по умолчанию	
				IF SecondaryFeeder.UserInfo.IsAUTO THEN
					TON_UpdateDefaultTareK2.IN := TRUE;
					TON_UpdateDefaultTareK2();
					IF TON_UpdateDefaultTareK2.Q THEN
						Config.SecondaryFeeder.DefaultTareK := SecondaryFeeder.UserInfo.TareK;
						SecondaryFeeder.Config.DefaultTareK := Config.SecondaryFeeder.DefaultTareK;
						// тарировочный для ручного ружима
						Control.SecondaryFeeder.TareK := SecondaryFeeder.Config.DefaultTareK;
						TON_UpdateDefaultTareK2.IN := FALSE;
						TON_UpdateDefaultTareK2();
					END_IF	
				END_IF
				
				// Обновление веса тары
				IF Control.SecondaryFeeder.UpdateTareWeight THEN
					Config.SecondaryFeeder.TareWeight := Config.SecondaryFeeder.TareWeight + UserInfo.SecondaryFeeder.Weight;
					Control.SecondaryFeeder.UpdateTareWeight := FALSE;
				END_IF
				
				// Обновление веса тары
				IF Control.PrimaryFeeder.UpdateTareWeight THEN
					Config.PrimaryFeeder.TareWeight := Config.PrimaryFeeder.TareWeight + UserInfo.PrimaryFeeder.Weight;
					Control.PrimaryFeeder.UpdateTareWeight := FALSE;
				END_IF	
		END_CASE
	END_IF	
END_FUNCTION_BLOCK
