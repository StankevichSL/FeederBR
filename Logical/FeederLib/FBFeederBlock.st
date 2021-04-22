
(* TODO: Add your comment here *)
FUNCTION_BLOCK FBFeederBlock
	IF Enable THEN
		CASE Status OF
			FEEDBLOCK_ERROR:
			FEEDBLOCK_INIT:
				PrimaryFeeder.Config := Config.PrimaryFeeder;
				PrimaryFeeder.IOin := IOin.PrimaryFeeder;
				PrimaryFeeder.Enable := TRUE;
				IF Config.DualFeederMode THEN
					SecondaryFeeder.Config := Config.SecondaryFeeder;
					SecondaryFeeder.IOin := IOin.SecondaryFeeder;
					SecondaryFeeder.Enable := TRUE;
					PrimaryFeeder();
					SecondaryFeeder();
					IF (PrimaryFeeder.Status = FEED_READY) AND (SecondaryFeeder.Status = FEED_READY) THEN
						Status := FEEDBLOCK_DUAL;
					END_IF
				ELSE
					PrimaryFeeder();
					IF (PrimaryFeeder.Status = FEED_READY) THEN
						Status := FEEDBLOCK_DUAL;
					END_IF
				END_IF				
			FEEDBLOCK_SINGLE:
				PrimaryFeeder.Control := Control.PrimaryFeeder;
				PrimaryFeeder.IOin := IOin.PrimaryFeeder;
				PrimaryFeeder.Start := Control.PrimaryStart;
				PrimaryFeeder();
				IOout.PrimaryFeeder := PrimaryFeeder.IOout;
				UserInfo.PrimaryFeeder := PrimaryFeeder.UserInfo;
			FEEDBLOCK_DUAL:
				PrimaryFeeder.IOin := IOin.PrimaryFeeder;
				SecondaryFeeder.IOin := IOin.SecondaryFeeder;
				IF Control.SeparateMode THEN
					PrimaryFeeder.Control := Control.PrimaryFeeder;					
					PrimaryFeeder.Start := Control.PrimaryStart;
					PrimaryFeeder();
			
					SecondaryFeeder.Control := Control.SecondaryFeeder;					
					SecondaryFeeder.Start := Control.SecondaryStart;
					SecondaryFeeder();
				ELSE
					IF Control.FeederSwitch THEN				
						SecondaryFeeder.Control := Control.PrimaryFeeder;
						SecondaryFeeder.Start := Control.PrimaryStart;
						SecondaryFeeder();
					ELSE
						PrimaryFeeder.Control := Control.PrimaryFeeder;
						PrimaryFeeder.Start := Control.PrimaryStart;
						PrimaryFeeder();
					END_IF
				END_IF
				IOout.PrimaryFeeder := PrimaryFeeder.IOout;
				UserInfo.PrimaryFeeder := PrimaryFeeder.UserInfo;
				
				IOout.SecondaryFeeder := SecondaryFeeder.IOout;
				UserInfo.SecondaryFeeder := SecondaryFeeder.UserInfo;	
		END_CASE
	END_IF	
END_FUNCTION_BLOCK
