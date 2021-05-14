(*FBFeederHandler*)

TYPE
	FeederHandlerStatusEnum : 
		(
		FEEDCTRL_ERROR := 0,
		FEEDCTRL_INIT := 1,
		FEEDCTRL_READY_TO_FEED := 2,
		FEEDCTRL_PREPURGE := 3,
		FEEDCTRL_FEEDING := 4,
		FEEDCTRL_POSTPURGE := 5
		);
	FeederHandlerControlType : 	STRUCT 
		PowderRate : UINT; (*Базовое управляющее значение расхода порошка*)
		KZP : REAL; (*Коэффициент захвата порошка*)
		KZU : REAL; (*Коэффициент запаса устойчивости (0-99)*)
		GasRate : UINT; (*Управляющее значение расходом газа*)
	END_STRUCT;
	FeederHandlerConfigType : 	STRUCT 
		PrepurgeTime : TIME := T#5s; (*Время предварительной продувки магистрали питателя, перед подачей порошка*)
		PostpurgeTime : TIME := T#5s; (*Время продувки магистрали питателя после остановки подачи порошка*)
		AxisConfigLink : UDINT; (*Ссылка на адрес конфигурации gLinkFeeder описываемой в Configuration Motion Config.mpaxisbasic*)
		ACPConfigLink : UDINT; (*Ссылка на адрес конфигурации gAxis описываемой в Configuration Motion Acp10map.ncm*)
		AxisBasicParLink : UDINT; (*Ссылка на структуру конфигурации типа MpAxisBasicParType*)
		AxisCyclicSetParLink : UDINT; (*Ссылка на структуру конфигурации типа MpAxisCyclicSetParType*)
		GasCalibrateOut : CalibrationType; (*Конфигурация калибровки подачи транспортного газа*)
		Ratio : USINT := 25; (*Передаточный множитель вращения диска питания*)
	END_STRUCT;
	FeederHandlerIOoutType : 	STRUCT 
		aoGasRate : INT; (*Управление регулятором расхода*)
		doShutOff : BOOL; (*Пережимной клапан подачи транспортного газа, нормально выключен*)
		doMixer : BOOL; (*Включения миксера полбы питателя*)
	END_STRUCT;
	FeederHandlerIOinType : 	STRUCT 
		aiGasRate : UINT; (*Показание регулятора расхода*)
	END_STRUCT;
	FeederHandlerUserInfoType : 	STRUCT 
		Active : BOOL; (*Отображает запущен ли питатель*)
		ActualSpeed : REAL; (*Отображает текущую скорость вращения диска в неизвестных единицах*)
	END_STRUCT;
END_TYPE

(*FBFeeder*)

TYPE
	FeederStatusEnum : 
		(
		FEED_ERROR := 0,
		FEED_INIT := 1,
		FEED_PAUSE := 2,
		FEED_RESET := 3,
		FEED_READY := 4,
		FEED_FEEDING := 5
		);
	FeederControlType : 	STRUCT 
		Handler : FeederHandlerControlType;
		ManualTareControl : BOOL; (*Включение ручного режима управления тарировочным коэффициентом*)
		TareK : REAL; (*Из этой переменной берутся значения при ручном управлении тарировочным коэффициентом*)
		UpdateTareWeight : BOOL; (*Записывает текущий вес в вес тары Config.TareWeight*)
	END_STRUCT;
	FeederConfigType : 	STRUCT 
		Handler : FeederHandlerConfigType;
		GasCalibrateIn : CalibrationType; (*Калибровка показаний датчика расхода транспортного газа*)
		WeightCalibrate : CalibrationType; (*Калибровка показаний тензодатчика*)
		DefaultTareK : REAL := 1; (*Тарировочный коэффициент поумолчанию*)
		WarningWeight : REAL := 0.3; (*Вес придупреждения в кг*)
		AlarmWeight : REAL := 0.1; (*Вес ошибки в кг*)
		AlarmPrefix : STRING[80]; (*Префикс колбы для формирования алармов*)
		BufferDelay : TIME := T#10s; (*Задержка перед началом заполнения буфферов*)
		TareCalcDelay : TIME := T#10s; (*Задержка перед началом расчета тарировочного коэффициента и расхода по данным буфферов*)
		DefaultTareKUpdateDelay : TIME := T#10s; (*Период обновления тарировочного коэффициента по умолчанию при работе в режиме АВТО управления расходом*)
		DeviationCalcDelay : TIME := T#10s; (*Задержка перед началом расчета стандартного откланения тарировочного коэффициента*)
		ToGoToAutoDelay : TIME := T#10s; (*Время перед переходом в режим автоуправлением расхода, в течении которого проверяется условие, что текущее откланение тарировочного коэффициента меньше заданного*)
		RecordInBufferPerion : TIME := T#100ms; (*Запись значений в буфер через указанное время*)
		DeviationLimit : REAL := 0.2; (*Пороговое значение стандартного откланения тарировочного коэффициента для перехода в авто режим*)
		ResetWeightLimit : REAL := 0.3; (*Значение веса в кг, для сброса значений буферов после выхода из паузы питателя*)
		ControlWord : UINT := 29828; (*Контрольное слово для тензодатчиков*)
		TareWeight : REAL := 0; (*Вес пустой колбы питателя в кг*)
	END_STRUCT;
	FeederIOinType : 	STRUCT 
		Handler : FeederHandlerIOinType;
		aiWeight : DINT; (*Показания тензодатчика*)
	END_STRUCT;
	FeederUserInfoType : 	STRUCT 
		Handler : FeederHandlerUserInfoType;
		Weight : REAL; (*Текущий вес порошка в питетеле в кг*)
		Rate : REAL; (*Текущий расход порошка гр/мин*)
		TareK : REAL; (*Текущий тарировочный коэффициент*)
		Deviation : REAL; (*Текущее стандартное откланение тарировочного коэффициента*)
		IsAUTO : BOOL; (*Включен ли режим автоматического поддержания расхода порошка*)
	END_STRUCT;
END_TYPE

(*FBFeederBlock*)

TYPE
	FeederBlockStatusEnum : 
		(
		FEEDBLOCK_ERROR := 0,
		FEEDBLOCK_INIT := 1,
		FEEDBLOCK_SINGLE := 2,
		FEEDBLOCK_DUAL := 3
		);
	FeederBlockControlType : 	STRUCT 
		PrimaryFeeder : FeederControlType;
		SecondaryFeeder : FeederControlType;
		PrimaryStart : BOOL; (*Старт первого питателя*)
		SecondaryStart : BOOL; (*Старт второго питателя*)
		SeparateMode : BOOL; (*Режим раздельной подачи порошка, при false - последовательный режим*)
		FeederSwitch : BOOL; (*Переключение колб питателя, false - первый*)
	END_STRUCT;
	FeederBlockConfigType : 	STRUCT 
		PrimaryFeederADR : UDINT; (*Ссылка на структуру FeederConfigType для первой колбы*)
		SecondaryFeederADR : UDINT; (*Ссылка на структуру FeederConfigType для второй колбы*)
		DualFeederMode : BOOL := TRUE; (*Количество колб питателя, false - одна*)
	END_STRUCT;
	FeederBlockIOinType : 	STRUCT 
		PrimaryFeeder : FeederIOinType;
		SecondaryFeeder : FeederIOinType;
	END_STRUCT;
	FeederBlockIOoutType : 	STRUCT 
		PrimaryFeeder : FeederHandlerIOoutType;
		SecondaryFeeder : FeederHandlerIOoutType;
	END_STRUCT;
	FeederBlockUserInfoType : 	STRUCT 
		PrimaryFeeder : FeederUserInfoType;
		SecondaryFeeder : FeederUserInfoType;
	END_STRUCT;
	FeederBlockIOType : 	STRUCT 
		In : FeederBlockIOinType;
		Out : FeederBlockIOoutType;
	END_STRUCT;
END_TYPE
