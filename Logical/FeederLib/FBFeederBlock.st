
(* TODO: Add your comment here *)
FUNCTION_BLOCK FBFeederBlock
	IF Enable THEN
		CASE Status OF
			FEEDBLOCK_ERROR:
			FEEDBLOCK_INIT:
				ConfigPrimaryFeeder ACCESS Config.PrimaryFeederADR;
				PrimaryFeeder.Config := ConfigPrimaryFeeder;
				PrimaryFeeder.IOin := IOin.PrimaryFeeder;
				PrimaryFeeder.Enable := TRUE;
				TON_UpdateDefaultTareK1.PT := ConfigPrimaryFeeder.DefaultTareKUpdateDelay;
				IF Config.DualFeederMode THEN
					ConfigSecondaryFeeder ACCESS Config.SecondaryFeederADR;
					SecondaryFeeder.Config := ConfigSecondaryFeeder;
					SecondaryFeeder.IOin := IOin.SecondaryFeeder;
					SecondaryFeeder.Enable := TRUE;
					TON_UpdateDefaultTareK2.PT := ConfigSecondaryFeeder.DefaultTareKUpdateDelay;
					PrimaryFeeder();
					SecondaryFeeder();
					IF (PrimaryFeeder.Status = FEED_READY) AND (SecondaryFeeder.Status = FEED_READY) THEN
						Status := FEEDBLOCK_DUAL;
					END_IF
				ELSE
					PrimaryFeeder();
					IF (PrimaryFeeder.Status = FEED_READY) THEN
						Status := FEEDBLOCK_SINGLE;
					END_IF
				END_IF				
			FEEDBLOCK_SINGLE:
				PrimaryFeeder.Control := Control.PrimaryFeeder;
				PrimaryFeeder.IOin := IOin.PrimaryFeeder;
				PrimaryFeeder.Start := Control.PrimaryStart;
				PrimaryFeeder();
				
				// обновление тарировочного коэффициента по умолчанию	
				IF PrimaryFeeder.UserInfo.IsAUTO THEN
					TON_UpdateDefaultTareK1.IN := TRUE;
					TON_UpdateDefaultTareK1();
					IF TON_UpdateDefaultTareK1.Q THEN
						ConfigPrimaryFeeder.DefaultTareK := PrimaryFeeder.UserInfo.TareK;
						PrimaryFeeder.Config.DefaultTareK := ConfigPrimaryFeeder.DefaultTareK;
						TON_UpdateDefaultTareK1.IN := FALSE;
						TON_UpdateDefaultTareK1();
					END_IF	
				END_IF
				
				// Обновление веса тары
				IF Control.PrimaryFeeder.UpdateTareWeight THEN
					ConfigPrimaryFeeder.TareWeight := UserInfo.PrimaryFeeder.Weight;
					Control.PrimaryFeeder.UpdateTareWeight := FALSE;
				END_IF
				
				IOout.PrimaryFeeder := PrimaryFeeder.IOout;
				UserInfo.PrimaryFeeder := PrimaryFeeder.UserInfo;
			FEEDBLOCK_DUAL:
				PrimaryFeeder.IOin := IOin.PrimaryFeeder;
				SecondaryFeeder.IOin := IOin.SecondaryFeeder;
				IF Control.SeparateMode THEN
					PrimaryFeeder.Control := Control.PrimaryFeeder;					
					PrimaryFeeder.Start := Control.PrimaryStart;					
			
					SecondaryFeeder.Control := Control.SecondaryFeeder;					
					SecondaryFeeder.Start := Control.SecondaryStart;
				ELSE
					IF Control.FeederSwitch THEN				
						SecondaryFeeder.Control := Control.PrimaryFeeder;
						SecondaryFeeder.Start := Control.PrimaryStart;						
					ELSE
						PrimaryFeeder.Control := Control.PrimaryFeeder;
						PrimaryFeeder.Start := Control.PrimaryStart;
					END_IF
				END_IF
				PrimaryFeeder();
				// обновление тарировочного коэффициента по умолчанию	
				IF PrimaryFeeder.UserInfo.IsAUTO THEN
					TON_UpdateDefaultTareK1.IN := TRUE;
					TON_UpdateDefaultTareK1();
					IF TON_UpdateDefaultTareK1.Q THEN
						ConfigPrimaryFeeder.DefaultTareK := PrimaryFeeder.UserInfo.TareK;
						PrimaryFeeder.Config.DefaultTareK := ConfigPrimaryFeeder.DefaultTareK;
						TON_UpdateDefaultTareK1.IN := FALSE;
						TON_UpdateDefaultTareK1();
					END_IF	
				END_IF
				SecondaryFeeder();
				// обновление тарировочного коэффициента по умолчанию	
				IF SecondaryFeeder.UserInfo.IsAUTO THEN
					TON_UpdateDefaultTareK2.IN := TRUE;
					TON_UpdateDefaultTareK2();
					IF TON_UpdateDefaultTareK2.Q THEN
						ConfigSecondaryFeeder.DefaultTareK := SecondaryFeeder.UserInfo.TareK;
						SecondaryFeeder.Config.DefaultTareK := ConfigSecondaryFeeder.DefaultTareK;
						TON_UpdateDefaultTareK2.IN := FALSE;
						TON_UpdateDefaultTareK2();
					END_IF	
				END_IF
				
				// Обновление веса тары
				IF Control.SecondaryFeeder.UpdateTareWeight THEN
					ConfigSecondaryFeeder.TareWeight := UserInfo.SecondaryFeeder.Weight;
					Control.SecondaryFeeder.UpdateTareWeight := FALSE;
				END_IF
				
				// Обновление веса тары
				IF Control.PrimaryFeeder.UpdateTareWeight THEN
					ConfigPrimaryFeeder.TareWeight := UserInfo.PrimaryFeeder.Weight;
					Control.PrimaryFeeder.UpdateTareWeight := FALSE;
				END_IF
				
				IOout.PrimaryFeeder := PrimaryFeeder.IOout;
				UserInfo.PrimaryFeeder := PrimaryFeeder.UserInfo;
				
				IOout.SecondaryFeeder := SecondaryFeeder.IOout;
				UserInfo.SecondaryFeeder := SecondaryFeeder.UserInfo;	
		END_CASE
	END_IF	
END_FUNCTION_BLOCK
