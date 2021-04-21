 
(**************************************************************
* Функциональный блок: FBCountdownTimer
* Файл: FBCountdownTimer.st
* Создан: 19.11.2020
***************************************************************
* Описание:
- Функциональный блок выполняет роль обратного таймера
с функцией срабатывания и выводом оставшегося времени

* Интерфейс
Входы:
- Start (BOOL) - Триггер на старт, пока он включен, таймер отсчитывает время
- Time (TIME) - Заданное время до срабатывания таймера

Выходы: 
- TimeLeft (TIME) - Актуальное время до срабатывания таймера
- DintTimeLeft (DINT) - Актуальное время до срабатывания таймера
- StrTimeLeft (STRING255) - Актуальное время до срабатывания таймера
- Stop (BOOL) - Таймер закончил отсчет времени

***************************************************************
Версия  |     Дата     |    Автор     |         Описание
---------------------------------------------------------------
V1.00.0 | 19.11.2020   | Топалов И.К. | Написание ФБ
**************************************************************)


FUNCTION_BLOCK FBCountdownTimer
		
	TON_0(PT:= Time);
	IF EDGEPOS(Start) THEN
		TON_0.IN := TRUE;
	END_IF
	
	IF (NOT Start) THEN
		TON_0.IN := FALSE;
		Stop := FALSE;
	END_IF
	
	IF (TON_0.Q) THEN
		TON_0.IN := FALSE;
		Stop := TRUE;			
	END_IF
	
	temp_sec := TIME_TO_DINT(Time - TON_0.ET)/1000;
	temp_min := DINT_TO_STRING(temp_sec/60);
	temp_min := CONCAT(temp_min,':');
	temp_str := DINT_TO_STRING(temp_sec MOD 60);			
	
	StrTimeLeft := CONCAT(temp_min,temp_str);
	DintTimeLeft := temp_sec;
	TimeLeft := Time - TON_0.ET;
	
END_FUNCTION_BLOCK