
(* TODO: Add your comment here *)
FUNCTION_BLOCK FBFeederBlock
	IF Enable THEN
		CASE Status OF
			FEEDBLOCK_ERROR:
			FEEDBLOCK_INIT:
				PrimaryFeeder.Config := Config.PrimaryFeeder;
				PrimaryFeeder.AlarmXCore := AlarmXCore;
				// ������������ ��� ������� ������
				Control.PrimaryFeeder.TareK := PrimaryFeeder.Config.DefaultTareK;
				PrimaryFeeder.IOin := IOin.PrimaryFeeder;
				PrimaryFeeder.Enable := TRUE;
				TON_UpdateDefaultTareK1.PT := Config.PrimaryFeeder.DefaultTareKUpdateDelay;
				IF Config.DualFeederMode THEN
					SecondaryFeeder.AlarmXCore := AlarmXCore;
					SecondaryFeeder.Config := Config.SecondaryFeeder;
					// ������������ ��� ������� ������
					Control.SecondaryFeeder.TareK := SecondaryFeeder.Config.DefaultTareK;
					SecondaryFeeder.IOin := IOin.SecondaryFeeder;
					SecondaryFeeder.Enable := TRUE;
					TON_UpdateDefaultTareK2.PT := Config.SecondaryFeeder.DefaultTareKUpdateDelay;
					SecondaryFeeder();
					IF (PrimaryFeeder.Status = FEED_READY) AND (SecondaryFeeder.Status = FEED_READY) THEN
						Status := FEEDBLOCK_DUAL;
					END_IF
				ELSE
					IF (PrimaryFeeder.Status = FEED_READY) THEN
						Status := FEEDBLOCK_SINGLE;
					END_IF
				END_IF		
				PrimaryFeeder();
			FEEDBLOCK_SINGLE:
				// ����� ������ ����� ���� ������ ���� �����
				PrimaryFeeder.Config := Config.PrimaryFeeder;
				PrimaryFeeder.Control := Control.PrimaryFeeder;
				PrimaryFeeder.IOin := IOin.PrimaryFeeder;
				PrimaryFeeder.Start := Control.PrimaryStart;
				PrimaryFeeder();
				
				// ���������� ������������� ������������ �� ���������	
				IF PrimaryFeeder.UserInfo.IsAUTO THEN
					TON_UpdateDefaultTareK1.IN := TRUE;
					TON_UpdateDefaultTareK1();
					IF TON_UpdateDefaultTareK1.Q THEN
						Config.PrimaryFeeder.DefaultTareK := PrimaryFeeder.UserInfo.TareK;
						PrimaryFeeder.Config.DefaultTareK := Config.PrimaryFeeder.DefaultTareK;
						// ������������ ��� ������� ������
						Control.PrimaryFeeder.TareK := PrimaryFeeder.Config.DefaultTareK;
						TON_UpdateDefaultTareK1.IN := FALSE;
						TON_UpdateDefaultTareK1();
					END_IF	
				END_IF
				
				// ���������� ���� ����
				IF Control.PrimaryFeeder.UpdateTareWeight THEN
					Config.PrimaryFeeder.TareWeight := UserInfo.PrimaryFeeder.Weight;
					Control.PrimaryFeeder.UpdateTareWeight := FALSE; 
				END_IF
				
				IOout.PrimaryFeeder := PrimaryFeeder.IOout;
				UserInfo.PrimaryFeeder := PrimaryFeeder.UserInfo;
			FEEDBLOCK_DUAL:
				// ����� ������ ��� ������� 2-� ����
				PrimaryFeeder.Config := Config.PrimaryFeeder;
				PrimaryFeeder.IOin := IOin.PrimaryFeeder;
				SecondaryFeeder.Config := Config.SecondaryFeeder;
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
				// ���������� ������������� ������������ �� ���������	
				IF PrimaryFeeder.UserInfo.IsAUTO THEN
					TON_UpdateDefaultTareK1.IN := TRUE;
					TON_UpdateDefaultTareK1();
					IF TON_UpdateDefaultTareK1.Q THEN
						Config.PrimaryFeeder.DefaultTareK := PrimaryFeeder.UserInfo.TareK;
						PrimaryFeeder.Config.DefaultTareK := Config.PrimaryFeeder.DefaultTareK;
						// ������������ ��� ������� ������
						Control.PrimaryFeeder.TareK := PrimaryFeeder.Config.DefaultTareK;
						TON_UpdateDefaultTareK1.IN := FALSE;
						TON_UpdateDefaultTareK1();
					END_IF	
				END_IF
				SecondaryFeeder();
				// ���������� ������������� ������������ �� ���������	
				IF SecondaryFeeder.UserInfo.IsAUTO THEN
					TON_UpdateDefaultTareK2.IN := TRUE;
					TON_UpdateDefaultTareK2();
					IF TON_UpdateDefaultTareK2.Q THEN
						Config.SecondaryFeeder.DefaultTareK := SecondaryFeeder.UserInfo.TareK;
						SecondaryFeeder.Config.DefaultTareK := Config.SecondaryFeeder.DefaultTareK;
						// ������������ ��� ������� ������
						Control.SecondaryFeeder.TareK := SecondaryFeeder.Config.DefaultTareK;
						TON_UpdateDefaultTareK2.IN := FALSE;
						TON_UpdateDefaultTareK2();
					END_IF	
				END_IF
				
				// ���������� ���� ����
				IF Control.SecondaryFeeder.UpdateTareWeight THEN
					Config.SecondaryFeeder.TareWeight := UserInfo.SecondaryFeeder.Weight;
					Control.SecondaryFeeder.UpdateTareWeight := FALSE;
				END_IF
				
				// ���������� ���� ����
				IF Control.PrimaryFeeder.UpdateTareWeight THEN
					Config.PrimaryFeeder.TareWeight := UserInfo.PrimaryFeeder.Weight;
					Control.PrimaryFeeder.UpdateTareWeight := FALSE;
				END_IF
				
				IOout.PrimaryFeeder := PrimaryFeeder.IOout;
				UserInfo.PrimaryFeeder := PrimaryFeeder.UserInfo;
				
				IOout.SecondaryFeeder := SecondaryFeeder.IOout;
				UserInfo.SecondaryFeeder := SecondaryFeeder.UserInfo;	
		END_CASE
	END_IF	
END_FUNCTION_BLOCK
