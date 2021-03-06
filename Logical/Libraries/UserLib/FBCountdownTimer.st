 
(**************************************************************
* �������������� ����: FBCountdownTimer
* ����: FBCountdownTimer.st
* ������: 19.11.2020
***************************************************************
* ��������:
- �������������� ���� ��������� ���� ��������� �������
� �������� ������������ � ������� ����������� �������

* ���������
�����:
- Start (BOOL) - ������� �� �����, ���� �� �������, ������ ����������� �����
- Time (TIME) - �������� ����� �� ������������ �������

������: 
- TimeLeft (TIME) - ���������� ����� �� ������������ �������
- DintTimeLeft (DINT) - ���������� ����� �� ������������ �������
- StrTimeLeft (STRING255) - ���������� ����� �� ������������ �������
- Stop (BOOL) - ������ �������� ������ �������

***************************************************************
������  |     ����     |    �����     |         ��������
---------------------------------------------------------------
V1.00.0 | 19.11.2020   | ������� �.�. | ��������� ��
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