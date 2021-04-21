
(* TODO: Add your comment here *)
FUNCTION FBlink
	
	//LCRPFM_0(enable := EnablePulse, x := 1, max_value := 1, min_value := 0, t_pulse := PulseTime, t_pause := PauseTime);
	
	CASE BlinkMode  OF
		
		BLINKMODE_CONSTANT_OFF:
			
			EnablePulse := FALSE;
		
		BLINKMODE_CONSTANT_ON:
			
			EnablePulse := TRUE;
			PulseTime := 1;
			PauseTime := 0;
			
		BLINKMODE_SLOW:
			
			EnablePulse := TRUE;
			PulseTime := 1;
			PauseTime := 1;
			
		BLINKMODE_MEDIUM:
			
			EnablePulse := TRUE;
			PulseTime := 0.5;
			PauseTime := 0.5;
			
		BLINKMODE_FAST:
			
			EnablePulse := TRUE;
			PulseTime := 0.25;
			PauseTime := 0.25;		
		
	END_CASE
	
	
	
	
	
	
	
	
END_FUNCTION
