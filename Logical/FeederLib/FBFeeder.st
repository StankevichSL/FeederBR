
(* TODO: Add your comment here *)
FUNCTION_BLOCK FBFeeder
	IF Enable THEN
		CASE Status OF
			FEED_ERROR:
			FEED_INIT:
				FBControl.Enable := TRUE;
				FBControl.Config; //!
				TON_BufferDelay.PT := Config.BufferDelay;
				i := 0;
				IF FBControl.Status = FEEDCTRL_READY_TO_FEED THEN
					Status := FEED_READY;
				END_IF
			FEED_READY:
				IF Start THEN
					FBControl.Start := TRUE;
				END_IF
				IF FBControl.Status = FEEDCTRL_FEEDING THEN
					Status := FEED_FEEDING;
				END_IF			
			FEED_FEEDING:	
				IF NOT WriteInBuffer THEN
					TON_BufferDelay.IN := TRUE;
					TON_BufferDelay();
					IF TON_BufferDelay.Q THEN
						WriteInBuffer := TRUE;
					END_IF
				ELSE
					W[i] := Weigth;
					T[i] := Clock;
					IF i = 0 THEN
						P[0] := P[2399] + Velocity;
					ELSE
						P[i] := P[i-1] + Velocity;
					END_IF					
				END_IF				
			FEED_RESET:
				FOR i := 0 TO 2399 DO
					W[i] := 0;
					T[i] := 0;
					P[i] := 0;
					WriteInBuffer := FALSE;		
				END_FOR
				i := 0;
				Status := FEED_READY;
		
		END_CASE
		FBControl();
	END_IF
END_FUNCTION_BLOCK
