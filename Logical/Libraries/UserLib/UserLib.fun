(*----------------------------------------------------------------Others------------------------------------------------------------------------------------------------------------------------------------------*)

{REDUND_OK} FUNCTION_BLOCK FBComparebValueDelay (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Delay : {REDUND_UNREPLICABLE} TIME; (*Задержка проверки переменной*)
		ActualValue : {REDUND_UNREPLICABLE} BOOL;
		TargetValue : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR_OUTPUT
		Out : BOOL;
	END_VAR
	VAR
		TON_0 : TON;
		TON_1 : TON;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK FBCountdownTimer
	VAR_INPUT
		Start : BOOL; (*Триггер на старт, пока он включен, таймер отсчитывает время*)
		Time : TIME; (*Заданное время до срабатывания таймера*)
	END_VAR
	VAR_OUTPUT
		TimeLeft : TIME; (*Актуальное время до срабатывания таймера*)
		DintTimeLeft : DINT; (*Актуальное время до срабатывания таймера*)
		StrTimeLeft : STRING[255]; (*Актуальное время до срабатывания таймера*)
		Stop : BOOL; (*Таймер закончил отсчет времени*)
	END_VAR
	VAR
		TON_0 : TON;
		temp_sec : DINT;
		temp_min : STRING[80];
		temp_str : STRING[80];
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_OK} FUNCTION InRange_Percent : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		ActualValue : REAL;
		TargetValue : REAL;
		DeviationInPercents : REAL; (*Значение несоответствия целевому в процентах*)
	END_VAR
	VAR
		DeviationValue : REAL;
		Value : REAL;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION CalibrateREAL : REAL (*Calibrate output signal by Ax2+Bx+C*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		IN : REAL;
		CalibrationData : CalibrationType;
	END_VAR
	VAR
		value : REAL;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION Calibrate : INT (*Calibrate output signal by Ax2+Bx+C*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		IN : INT;
		CalibrationData : CalibrationType;
	END_VAR
	VAR
		value : REAL;
	END_VAR
END_FUNCTION

{REDUND_OK} FUNCTION FBlink : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		BlinkMode : BlinkModeType;
	END_VAR
	VAR
		PulseTime : REAL;
		PauseTime : REAL;
		EnablePulse : BOOL;
	END_VAR
END_FUNCTION

{REDUND_OK} FUNCTION_BLOCK FBRobotAlarms (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		IOIn : FBRobotAlarmsIOInType;
	END_VAR
	VAR
		(*AlarmsList : ARRAY[1..255] OF AlarmsListType := [(Name:='ErrorBatteryAlarm',Config:=(Code:=4000,Severity:=5)),254(0)];*)
		(*FBAlarmListDiscrValMon_0 : FBAlarmListDiscrValMon;*)
	END_VAR
END_FUNCTION_BLOCK
