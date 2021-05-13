
(* TODO: Add your comment here *)
FUNCTION_BLOCK FBFeeder
	IF Enable THEN								
		CASE Status OF
			FEED_ERROR:
			FEED_INIT:				
				FBControl.Enable := TRUE;
				FBControl.TareK := Config.DefaultTareK;				
				
				TON_BufferDelay.PT := Config.BufferDelay;
				TON_TareCalcDelay.PT := Config.TareCalcDelay;
				TON_DeviationCalcDelay.PT := Config.DeviationCalcDelay;
				TON_ToGoToAutoDelay.PT := Config.ToGoToAutoDelay;				
				
				i := 0;
				j := 0;
				
				UserInfo.Rate := 0;
				UserInfo.TareK := 0;
				UserInfo.Deviation := 0;
				IF FBControl.Status = FEEDCTRL_READY_TO_FEED THEN
					Status := FEED_READY;
				END_IF
			FEED_READY:
				IF Start THEN
					FBControl.Start := TRUE;
				END_IF
				IF Reset THEN
					Status := FEED_RESET;
				END_IF
				IF FBControl.Status = FEEDCTRL_FEEDING THEN
					Status := FEED_FEEDING;
				END_IF
			FEED_FEEDING:	
				IF Start THEN
					TON_WriteInBufferPeriod.IN := TRUE;
					TON_WriteInBufferPeriod();
					// регулировка частоты записи в буффер
					IF TON_WriteInBufferPeriod.Q THEN	
						TON_WriteInBufferPeriod.IN := FALSE;
						TON_WriteInBufferPeriod();
						
						IF NOT WriteInWTP THEN
							// задержка заполнения буфферов W T P
							TON_BufferDelay.IN := TRUE;
							TON_BufferDelay();
							IF TON_BufferDelay.Q THEN
								WriteInWTP := TRUE;
								TON_BufferDelay.IN := FALSE;								
							END_IF
						ELSE
							// заполнение буфера W T P
							WBuffer[i] := UserInfo.Weight;
							IF i = 0 THEN
								PBuffer[0] := PBuffer[2399] + FBControl.UserInfo.ActualSpeed/100000;
								TBuffer[0] := TBuffer[2399] + 0.1;
							ELSE
								PBuffer[i] := PBuffer[i-1] + FBControl.UserInfo.ActualSpeed/100000;
								TBuffer[i] := TBuffer[i-1] + 0.1;
							END_IF

							IF i = 2399 THEN
								i := 0;
								RewriteWTP := TRUE;
							ELSE
								i := i + 1;
							END_IF
					
							IF NOT WriteInTareK THEN
								// задержка заполнения буффера тарировочного коэффициента
								TON_TareCalcDelay.IN := TRUE;
								TON_TareCalcDelay();
								IF TON_TareCalcDelay.Q THEN
									WriteInTareK := TRUE;
									TON_TareCalcDelay.IN := FALSE;									
								END_IF
							ELSE
								// заполнение буффера тарировочного коэффициента
								IF RewriteWTP THEN
									UserInfo.TareK := USINT_TO_REAL(Config.Handler.Ratio)*FFeederRatio(ADR(WBuffer),ADR(PBuffer),ADR(TBuffer),2399)/0.6;
								ELSE
									UserInfo.TareK := USINT_TO_REAL(Config.Handler.Ratio)*FFeederRatio(ADR(WBuffer),ADR(PBuffer),ADR(TBuffer),i)/0.6;	
								END_IF
								TareKBuffer[j] := UserInfo.TareK;
								
								IF j = 2399 THEN
									j := 0;
									RewriteTareK := TRUE;
								ELSE
									j := j + 1;
								END_IF
						
								IF NOT CalcDeviation THEN
									// задержка расчета стандартной погрешности татировочного коэффициента
									TON_DeviationCalcDelay.IN := TRUE;
									TON_DeviationCalcDelay();
									IF TON_DeviationCalcDelay.Q THEN
										CalcDeviation := TRUE;
										TON_DeviationCalcDelay.IN := FALSE;
									END_IF
								ELSE
									// расчет стандартного откланения погрешности тарировочного коэффициента
									IF RewriteTareK THEN
										UserInfo.Deviation := FStdDeviation(ADR(TareKBuffer),2399);
									ELSE
										UserInfo.Deviation := FStdDeviation(ADR(TareKBuffer),j);
									END_IF							
								END_IF						
							END_IF					
						END_IF						
						
					END_IF
					// Выбор тарировочного коэффициента в зависимости от конфигурации
					IF Control.ManualTareControl THEN
						FBControl.TareK := Control.TareK;
					ELSE
						IF NOT UserInfo.IsAUTO THEN
							FBControl.TareK := Config.DefaultTareK;
							IF CalcDeviation THEN
								IF (UserInfo.Deviation <> 0) AND (UserInfo.Deviation < Config.DeviationLimit) THEN
									TON_ToGoToAutoDelay.IN := TRUE;
									IF TON_ToGoToAutoDelay.Q THEN
										UserInfo.IsAUTO := TRUE;
										TON_ToGoToAutoDelay.IN := FALSE;
									END_IF;
								ELSE
									TON_ToGoToAutoDelay.IN := FALSE;									
								END_IF				
								TON_ToGoToAutoDelay();
							ELSE
								FBControl.TareK := Config.DefaultTareK;
							END_IF
						ELSE
							IF UserInfo.Deviation > Config.DeviationLimit THEN
								UserInfo.IsAUTO := FALSE;
							ELSE					
								FBControl.TareK := UserInfo.TareK;							
							END_IF				
						END_IF			
					END_IF
				ELSE
					FBControl.Start := FALSE;
					Status := FEED_PAUSE;
				END_IF				
			FEED_RESET:
				FOR i := 0 TO 2399 DO
					WBuffer[i] := 0;
					TBuffer[i] := 0;
					PBuffer[i] := 0;
					TareKBuffer[i] := 0;
				END_FOR
				i := 0;
				j := 0;
				
				RewriteWTP := FALSE;
				RewriteTareK := FALSE;
				WriteInWTP := FALSE;		
				WriteInTareK := FALSE;
				CalcDeviation := FALSE;
				UserInfo.IsAUTO := FALSE;
				
				TON_BufferDelay.IN := FALSE;
				TON_BufferDelay();
				TON_TareCalcDelay.IN := FALSE;
				TON_TareCalcDelay();
				TON_DeviationCalcDelay.IN := FALSE;
				TON_DeviationCalcDelay();
				
				
				Reset := FALSE;
				Status := FEED_READY;
				
				UserInfo.Rate := 0;
				UserInfo.TareK := 0;
				UserInfo.Deviation := 0;
			FEED_PAUSE:		
				IF Start THEN
					Status := FEED_READY;
					IF RewriteWTP THEN
						IF i = 0 THEN
							IF ABS(WBuffer[2399]-UserInfo.Weight) > Config.ResetWeightLimit THEN
								Status := FEED_RESET;
							END_IF
						ELSE
							IF ABS(WBuffer[i-1]-UserInfo.Weight) > Config.ResetWeightLimit THEN
								Status := FEED_RESET;
							END_IF
						END_IF
					ELSE
						IF (i <> 0) AND (ABS(WBuffer[i-1]-UserInfo.Weight) > Config.ResetWeightLimit) THEN
							Status := FEED_RESET;
						END_IF
					END_IF
				END_IF
		END_CASE
		FBControl.Config := Config.Handler;
		FBControl.Control := Control.Handler;
		FBControl.IOin := IOin.Handler;
		FBControl();
		UserInfo.Handler := FBControl.UserInfo;
		UserInfo.Weight := CalibrateREAL(DINT_TO_REAL(IOin.aiWeight), Config.WeightCalibrate) - Config.TareWeight;
		UserInfo.Rate := FBControl.UserInfo.ActualSpeed*UserInfo.TareK*0.6/USINT_TO_REAL(Config.Handler.Ratio);
		IOout := FBControl.IOout;
	ELSE
		Status := FEED_INIT;
	END_IF
END_FUNCTION_BLOCK