﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Если НЕ ЗначениеЗаполнено(Объект.ИнтернетМагазин) Тогда
	//	Объект.ЭтоТест = Истина;
	//	ПолнаяВыгрузка = Истина;
	//КонецЕсли;
	НастройкиУстановить();
	
	Если Объект.ЭтоТест Тогда
		Элементы.ЭтоТест.Видимость	= Истина;
	КонецЕсли;
	ДоступУстановить();
КонецПроцедуры

&НаСервере
Процедура НастройкиУстановить()
	НаСервере().НастройкиУстановить(Объект);
КонецПроцедуры

&НаСервере
Процедура Алло(Сообщение)
	Если НЕ ПустаяСтрока(Сообщение) Тогда
		Сообщить(Сообщение);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ИмпортШтрихкодовНаСервере()
	НаСервере().ВыполнитьКоманду("GET_ITEMS");
КонецПроцедуры

&НаКлиенте
Процедура ИмпортШтрихкодов(Команда)
	Если ПроверитьЗаполнение() Тогда
		ИмпортШтрихкодовНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПолучитьЗаказыНаСервере()
	ТаблицаЗаказов = НаСервере().ПолучитьТаблицуЗаказовИзСайта();
	Сообщить(ТаблицаЗаказов.Количество());
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьЗаказы(Команда)
	ПолучитьЗаказыНаСервере();
КонецПроцедуры

&НаСервере
Процедура UPDATESTOCKНаСервере()
	НаСервере().ВыполнитьКоманду("UPDATE_STOCK");
КонецПроцедуры

&НаКлиенте
Процедура UPDATESTOCK(Команда)
	UPDATESTOCKНаСервере();
КонецПроцедуры

&НаСервере
Функция ПолучитьДатуДляОстатков()
	ТекущееВремя = ТекущаяДата();
	Разница = ТекущееВремя - УниверсальноеВремя(ТекущееВремя);
	Если Разница < 0 Тогда
		Разница = -Разница;
	КонецЕсли;	
	РазницаЧасы = Разница/3600;
	//Минуты = РазницаЧасы % 1;
	//ДобавкаМинуты = "00";
	//Если Минуты = 0 Тогда
	//	ДобавкаМинуты = "00";
	//ИначеЕсли Минуты = 0.5 Тогда
	//	ДобавкаМинуты = "30";
	//КонецЕсли;
	Добавка = "+" + ПеревестиВДвузначноеЧисло(Цел(РазницаЧасы)) + ":" + ?(РазницаЧасы % 1 = 0, "00", "30");
	Время = Формат(ТекущееВремя, "ДФ='гггг-ММ-дд''T''ЧЧ:мм:сс'");
	Возврат Время + Добавка;
КонецФункции

&НаСервере
Функция ПеревестиВДвузначноеЧисло(Число)
	Если Число > 9 Тогда
		Результат = Строка(Число);		
	Иначе
		Результат = "0" + Строка(Число);	
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаСервере
Процедура UPDATEPRICESНаСервере()
	НаСервере().SEND_PRICES();
КонецПроцедуры

&НаКлиенте
Процедура UPDATEPRICES(Команда)
	Если ПроверитьЗаполнение() Тогда
		Если Объект.ЭтоТест Тогда
			//
		Иначе
			UPDATEPRICESНаСервере();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновить(Команда)
	Если ПроверитьЗаполнение() Тогда
		КомандаОбновитьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура КомандаОбновитьНаСервере()
	Объект.Цены.Очистить();
	
	Объект.Цены.Загрузить(НаСервере().ВыгрузитьЦены(50));
КонецПроцедуры

&НаСервере
Процедура КомандаРегистрЦенЗаполнитьНаСервере()
	НаСервере().ВыполнитьКоманду("COPY_PRICES");
КонецПроцедуры

&НаКлиенте
Процедура КомандаРегистрЦенЗаполнить(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.ВидЦены) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнено",, "ВидЦены", "Объект.ВидЦены");
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.ВидЦеныБазис) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнено",, "ВидЦеныБазис", "Объект.ВидЦеныБазис");
	ИначеЕсли ПроверитьЗаполнение() Тогда
		КомандаРегистрЦенЗаполнитьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИнтернетМагазинПриИзменении(Элемент)
	НастройкиУстановить();
КонецПроцедуры

&НаСервере
Функция НаСервере()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаСервере
Функция СправочникСлужбДоставкиНаСервере()
	Ответ	= Новый ТабличныйДокумент;
	АдресРесурса	= "https://api.partner.market.yandex.ru/v2/delivery/services.json";
	ДополнительныеПараметры = РеквизитФормыВЗначение("Объект").ПолучитьЗаголовкиЗапросаHTTP();
	МассивДанных = КоннекторHTTP.GetJson(АдресРесурса,, ДополнительныеПараметры);
	Если ТипЗнч(МассивДанных.Получить("result")) = Тип("Соответствие")
	И ТипЗнч(МассивДанных.Получить("result").Получить("deliveryService")) = Тип("Массив")
	Тогда
		Макет = НаСервере().ПолучитьМакет("СправочникСлужбДоставки");
		Область = Макет.ПолучитьОбласть("Детали");
		Службы = МассивДанных.Получить("result").Получить("deliveryService");
		Для Каждого Служба Из Службы Цикл
			Область.Параметры.id	= Служба.Получить("id");
			Область.Параметры.name	= Служба.Получить("name");
			Ответ.Вывести(Область);
		КонецЦикла;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаКлиенте
Процедура КомандаСправочникСлужбДоставки(Команда)
	Ответ = СправочникСлужбДоставкиНаСервере();
	Ответ.Показать("Справочник служб доставки");
КонецПроцедуры

&НаСервере
Функция ПоказатьОстаткиНаСервере(Артикул="")
	Если Объект.ЭтоТест Тогда
		Ответ	= Новый ТабличныйДокумент;
		Макет = НаСервере().ПолучитьМакет("СправочникСлужбДоставки");
		Область = Макет.ПолучитьОбласть("Детали");
		МассивSKU	= АртикулыПример(Истина);
		Для Каждого ТекЭлемент Из МассивSKU Цикл
			Область.Параметры.id	= ТекЭлемент;
			Ответ.Вывести(Область);
		КонецЦикла;
		Возврат Ответ;
	КонецЕсли;
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1000
	|	Товар.Артикул + Характеристики.Наименование КАК SKU
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК Характеристики
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Товар
	|		ПО Характеристики.Владелец = Товар.Ссылка
	|ГДЕ
	|	Товар.Артикул >= &Артикул
	|
	|УПОРЯДОЧИТЬ ПО
	|	Товар.Артикул");
	Запрос.УстановитьПараметр("ИнтернетМагазин",	Объект.ИнтернетМагазин);
	Запрос.УстановитьПараметр("Артикул",			Артикул);
	Если ПустаяСтрока(Артикул) Тогда
		//Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 10
		//               |	Товар.Артикул + Характеристики.Наименование КАК SKU
		//               |ИЗ
		//               |	Справочник.ХарактеристикиНоменклатуры КАК Характеристики
		//               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Товар
		//               |		ПО Характеристики.Владелец = Товар.Ссылка
		//               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИнтернетМагазинОстатки КАК Остатки
		//               |		ПО Характеристики.Ссылка = Остатки.Характеристика
		//               |ГДЕ
		//               |	Остатки.Характеристика ЕСТЬ NULL
		//               |
		//               |УПОРЯДОЧИТЬ ПО
		//               |	Товар.Артикул";
		//Запрос.УстановитьПараметр("Артикул",			СтрРазделить(Артикул, ",", Ложь));
		МассивSKU	= АртикулыПример(Истина);
	Иначе
		МассивSKU	= Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
	КонецЕсли;

	warehouseId	= 1;
	Выборка = ИнтеграцияWB.ПолучитьОстаткиТоваров(МассивSKU, Объект.ИнтернетМагазин);
	
	ДанныеОТоварах	= Новый Массив;
	ДатаФормат		= _ТекущаяДатаСеанса();
	Для Каждого ТекСтрока Из Выборка Цикл
		Остаток = Новый Структура("warehouseId,shopSku", warehouseId, ТекСтрока.SKU);
		
		МассивАйтем = Новый Массив;
		МассивАйтем.Добавить(Новый Структура("type,updatedAt,count", "FIT", ДатаФормат, ТекСтрока.count));
		Остаток.Вставить("items", МассивАйтем);
		
		ДанныеОТоварах.Добавить(Остаток);
	КонецЦикла;
	
	ДокументРезультат = Новый ТекстовыйДокумент;
	ДокументРезультат.УстановитьТекст(JSONМодуль.ЗаписатьJSON1(Новый Структура("skus", ДанныеОТоварах)));
	Возврат ДокументРезультат.ПолучитьТекст();
КонецФункции

&НаСервере
Функция _ТекущаяДатаСеанса()
	Возврат ИнтеграцияИС.ДатаСЧасовымПоясом(ТекущаяДатаСеанса());
КонецФункции

&НаКлиенте
Процедура ПоказатьОстатки(Результат, Параметры) Экспорт
	//Если НЕ ПустаяСтрока(Результат) Тогда
		ДокументРезультат = ПоказатьОстаткиНаСервере(Результат);
		Если НЕ ПустаяСтрока(ДокументРезультат) Тогда
			ПоказатьЗначение(, ДокументРезультат);
		КонецЕсли;
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказатьОстатки(Команда) Экспорт
	Если ПроверитьЗаполнение() Тогда
		Если Объект.ЭтоТест Тогда
			Ответ = ПоказатьОстаткиНаСервере();
			Ответ.Показать("SKU");
		Иначе
			ф=АртикулыПример();
			ПоказатьВводСтроки(Новый ОписаниеОповещения("ПоказатьОстатки", ЭтотОбъект), ф, "Введите Артикул (достаточно первых двух)");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция АртикулыПример(КакМассив=Ложь)
	Если КакМассив Тогда
		// тестовый запрос Яндекса
		СоответствиеДанных = НаСервере().МассивДанныхПолучить("YA_STOCKS");
		МассивДанных = СоответствиеДанных.Получить("skus");
		Возврат МассивДанных;
	КонецЕсли;
	Возврат "0KKB46570ODMID";
КонецФункции

&НаКлиенте
Процедура ЭтоТестПриИзменении(Элемент)
	ДоступУстановить();
КонецПроцедуры

&НаКлиенте
Процедура ДоступУстановить()
	Если Объект.ЭтоТест Тогда
		Элементы.UPDATEPRICES.Видимость						= Ложь;
		Элементы.КомандаСправочникСлужбДоставки.Видимость	= Истина;
	Иначе
		Элементы.UPDATEPRICES.Видимость						= Истина;
		Элементы.КомандаСправочникСлужбДоставки.Видимость	= Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АдресФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	КомандаФайлЗагрузить();
КонецПроцедуры

&НаКлиенте
Процедура КомандаФайлЗагрузить(Команда=Неопределено)
	ВариантЗагрузки = ?(Элементы.ГруппаОсновная.ТекущаяСтраница.Имя = "ГруппаЦены", 1, ?(Элементы.ГруппаОсновная.ТекущаяСтраница.Имя = "ГруппаКатегории", 3, 2));
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.Фильтр = "Файл Microsoft Excel (*.xlsx)|*.xlsx";
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(Новый ОписаниеОповещения("ВыборФайлаЗавершение", ЭтотОбъект, Новый Структура("Диалог", ДиалогОткрытияФайла)), ДиалогОткрытияФайла);
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаЗавершение(ВыбранныеФайлы, Контекст) Экспорт
	ДиалогОткрытияФайла = Контекст.Диалог;
	Если ТипЗнч(ВыбранныеФайлы) = Тип("Массив") Тогда
		ПолноеИмяФайла = ДиалогОткрытияФайла.ПолноеИмяФайла;
		Попытка
			НачатьПомещениеФайла(Новый ОписаниеОповещения("ВыполнитьЗагрузку", ЭтаФорма),, ПолноеИмяФайла, Ложь, УникальныйИдентификатор); 
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузку(Результат, Адрес, ПолноеИмяФайла, ДополнительныеПараметры) Экспорт 
	Если Результат Тогда
	    ЗагрузитьНаСервере(Адрес, Сред(ПолноеИмяФайла, СтрНайти(ПолноеИмяФайла, ".", НаправлениеПоиска.СКонца) + 1));
		Если ВариантЗагрузки = 1 И Объект.Цены.Количество() > 0 Тогда
			Элементы.ГруппаТабДок.Скрыть();
		ИначеЕсли ВариантЗагрузки = 2 И Объект.Размеры.Количество() > 0 Тогда
			Элементы.ГруппаТабДок.Скрыть();
		КонецЕсли;
    КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНаСервере(Знач Адрес, Расширение) 
	ФайлВременногоХранилища = ПолучитьИзВременногоХранилища(Адрес);
    ИмяФайла				= ПолучитьИмяВременногоФайла(Расширение);
	Попытка
	    ФайлВременногоХранилища.Записать(ИмяФайла);
	    УдалитьИзВременногоХранилища(Адрес);
		ТабДок.Прочитать(ИмяФайла);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
    УдалитьФайлы(ИмяФайла);
	//	загрузка файла
	Если ВариантЗагрузки = 1 Тогда
		Танкер1();
	ИначеЕсли ВариантЗагрузки = 3 Тогда
		Танкер3();
	Иначе
		Танкер2();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура Танкер3()
	//	заполнение Категории
	Объект.Категории.Очистить();
	
	Колонка_MopDivision			= 0;
	Колонка_MopDepartment		= 0;
	Колонка_MopSubDepartment	= 0;
	Колонка_MopCategory			= 0;
	Колонка_MopClass			= 0;
	Колонка_мп_Категория		= 0;
	Колонка_Комплектация		= 0;
	Колонка_КомплектацияID		= 0;
	Колонка_Категории			= 0;
	Колонка_КатегорияID			= 0;
	нн			= 1;
	ИмяКолонки	= "/";
	Пока НЕ ПустаяСтрока(ИмяКолонки) Цикл
		ИмяКолонки 	 = НРег(ТабДок.Область(1, нн, 1, нн).Текст);
		Если ИмяКолонки = "division" Тогда
			Колонка_MopDivision	= нн;
		ИначеЕсли ИмяКолонки = "department" Тогда
			Колонка_MopDepartment	= нн;
		ИначеЕсли ИмяКолонки = "subdepartment" Тогда
			Колонка_MopSubDepartment	= нн;
		ИначеЕсли НРег(ИмяКолонки) = "category" Тогда
			Колонка_MopCategory	= нн;
		ИначеЕсли НРег(ИмяКолонки) = "class" Тогда
			Колонка_MopClass	= нн;
		ИначеЕсли НРег(ИмяКолонки) = "koton id" Тогда
			Колонка_мп_Категория	= нн;
		ИначеЕсли СтрСравнить(ИмяКолонки, "Комплектация") = 0 Тогда
			Колонка_Комплектация	= нн;
		ИначеЕсли СтрСравнить(ИмяКолонки, "КомплектацияID") = 0 Тогда
			Колонка_КомплектацияID	= нн;
		ИначеЕсли СтрСравнить(ИмяКолонки, "Категория") = 0 Тогда
			Колонка_Категория		= нн;
		ИначеЕсли СтрСравнить(ИмяКолонки, "КатегорияID") = 0 Тогда
			Колонка_КатегорияID		= нн;
			
		ИначеЕсли Колонка_MopDivision * Колонка_MopDepartment * Колонка_MopSubDepartment * Колонка_MopCategory * Колонка_MopClass * Колонка_мп_Категория * Колонка_Комплектация * Колонка_КомплектацияID * Колонка_Категория * Колонка_КатегорияID > 0 Тогда
			Прервать;
		КонецЕсли;
		нн = нн + 1;
	КонецЦикла;
	
	Если Колонка_MopDivision * Колонка_MopDepartment * Колонка_MopSubDepartment * Колонка_MopCategory * Колонка_MopClass * Колонка_мп_Категория > 0 Тогда
		мм	= ?(Объект.ЭтоТест, 9, ТабДок.ВысотаТаблицы);
		Для нн = 2 По мм Цикл
			Атрибут	= ТабДок.Область(нн, Колонка_мп_Категория, нн, Колонка_мп_Категория).Текст;
			Если ПустаяСтрока(Атрибут) Тогда
				Продолжить;
			КонецЕсли;
			ТекСтрока	= Новый Структура("Ошибка,мп_Категория,MopDivision,MopDepartment,MopSubDepartment,MopCategory,MopClass", Ложь, Атрибут);
			Если Колонка_Комплектация * Колонка_КомплектацияID * Колонка_Категория * Колонка_КатегорияID > 0 Тогда
				ТекСтрока.Вставить("КатегорияID",		СокрЛП(ТабДок.Область(нн, Колонка_КатегорияID, нн, Колонка_КатегорияID).Текст));
				ТекСтрока.Вставить("Категория",			СокрЛП(ТабДок.Область(нн, Колонка_Категория, нн, Колонка_Категория).Текст));
				ТекСтрока.Вставить("КомплектацияID",	СокрЛП(ТабДок.Область(нн, Колонка_КомплектацияID, нн, Колонка_КомплектацияID).Текст));
				ТекСтрока.Вставить("Комплектация",		СокрЛП(ТабДок.Область(нн, Колонка_Комплектация, нн, Колонка_Комплектация).Текст));
			КонецЕсли;
			
			//Если мп_Категории_Найти(ТекСтрока) Тогда
			//	ЗаполнитьЗначенияСвойств(Объект.Категории.Добавить(), ТекСтрока);
			//	Продолжить;
			//КонецЕсли;
			
			ТекСтрока.Вставить("MopDivision", 		MopDivisionНайти(ТабДок.Область(нн, Колонка_MopDivision, нн, Колонка_MopDivision).Текст));
			ТекСтрока.Вставить("MopDepartment", 	MopDepartmentНайти(ТабДок.Область(нн, Колонка_MopDepartment, нн, Колонка_MopDepartment).Текст));
			ТекСтрока.Вставить("MopSubDepartment", 	MopSubDepartmentНайти(ТабДок.Область(нн, Колонка_MopSubDepartment, нн, Колонка_MopSubDepartment).Текст));
			ТекСтрока.Вставить("MopCategory", 		MopCategoryНайти(ТабДок.Область(нн, Колонка_MopCategory, нн, Колонка_MopCategory).Текст));
			ТекСтрока.Вставить("MopClass", 			MopClassНайти(ТабДок.Область(нн, Колонка_MopClass, нн, Колонка_MopClass).Текст));
			Если НЕ мп_Категории_Подобрать(ТекСтрока) Тогда
				ТекСтрока.Вставить("Ошибка",			Истина);
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(Объект.Категории.Добавить(), ТекСтрока);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция мп_Категории_Подобрать(Параметры)
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Категории.Ссылка КАК мп_Категория
	|ИЗ
	|	Справочник.мп_Категории КАК Категории
	|ГДЕ
	|	Категории._MopClass = &MopClass
	|	И Категории._MopCategory = &MopCategory
	|	И Категории._MopSubDepartment = &MopSubDepartment
	|	И Категории._MopDepartment = &MopDepartment
	|	И Категории._MopDivision = &MopDivision");
	Запрос.УстановитьПараметр("MopDivision",		Параметры.MopDivision);
	Запрос.УстановитьПараметр("MopDepartment",		Параметры.MopDepartment);
	Запрос.УстановитьПараметр("MopSubDepartment",	Параметры.MopSubDepartment);
	Запрос.УстановитьПараметр("MopCategory",		Параметры.MopCategory);
	Запрос.УстановитьПараметр("MopClass",			Параметры.MopClass);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Параметры, Выборка);
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

&НаСервереБезКонтекста
Функция MopDivisionНайти(Наименование)
	Ответ = Неопределено;
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Mop.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.MopDivision КАК Mop
	|ГДЕ
	|	Mop.Наименование = &Наименование");
	Запрос.УстановитьПараметр("Наименование",	Наименование);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Ответ = Выборка.Ссылка;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаСервереБезКонтекста
Функция MopDepartmentНайти(Наименование)
	Ответ = Неопределено;
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Mop.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.MopDepartment КАК Mop
	|ГДЕ
	|	Mop.Наименование = &Наименование");
	Запрос.УстановитьПараметр("Наименование",	Наименование);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Ответ = Выборка.Ссылка;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаСервереБезКонтекста
Функция MopSubDepartmentНайти(Наименование)
	Ответ = Неопределено;
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Mop.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.MopSubDepartment КАК Mop
	|ГДЕ
	|	Mop.Наименование = &Наименование");
	Запрос.УстановитьПараметр("Наименование",	Наименование);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Ответ = Выборка.Ссылка;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаСервереБезКонтекста
Функция MopCategoryНайти(Наименование)
	Ответ = Неопределено;
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Mop.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.MopCategory КАК Mop
	|ГДЕ
	|	Mop.Наименование = &Наименование");
	Запрос.УстановитьПараметр("Наименование",	Наименование);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Ответ = Выборка.Ссылка;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаСервереБезКонтекста
Функция MopClassНайти(Наименование)
	Ответ = Неопределено;
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Mop.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.MopClass КАК Mop
	|ГДЕ
	|	Mop.Наименование = &Наименование");
	Запрос.УстановитьПараметр("Наименование",	Наименование);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Ответ = Выборка.Ссылка;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаСервереБезКонтекста
Функция мп_Категории_Найти(Параметры)
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Категории.Ссылка КАК мп_Категория,
	|	Категории._MopDivision КАК MopDivision,
	|	Категории._MopDepartment КАК MopDepartment,
	|	Категории._MopSubDepartment КАК MopSubDepartment,
	|	Категории._MopCategory КАК MopCategory,
	|	Категории._MopClass КАК MopClass
	|ИЗ
	|	Справочник.мп_Категории КАК Категории
	|ГДЕ
	|	Категории.Наименование = &Наименование");
	Запрос.УстановитьПараметр("Наименование",	Параметры.мп_Категория);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Параметры, Выборка);
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

&НаСервере
Процедура Танкер1()
	Колонка_sku			= 0;
	Колонка_ЦенаБазис	= 0;
	Колонка_Цена		= 0;
	Колонка_Артикул		= 0;
	нн		= 1;
	ИмяКолонки			= "/";
	Пока НЕ ПустаяСтрока(ИмяКолонки) Цикл
		ИмяКолонки 	 = ТабДок.Область(1, нн, 1, нн).Текст;
		Если НРег(ИмяКолонки) = "sku" Тогда
			Колонка_sku	= нн;
		ИначеЕсли НРег(ИмяКолонки) = "first price" Тогда
			Колонка_ЦенаБазис	= нн;
		ИначеЕсли НРег(ИмяКолонки) = "last price" Тогда
			Колонка_Цена	= нн;
		ИначеЕсли НРег(ИмяКолонки) = "sale price" Тогда		//	Sale Price
			Колонка_Цена	= нн;
		ИначеЕсли НРег(ИмяКолонки) = "option" Тогда
			Колонка_Артикул	= нн;
			
		ИначеЕсли Колонка_ЦенаБазис * Колонка_Цена * Колонка_Артикул > 0 Тогда
			Прервать;
		КонецЕсли;
		нн = нн + 1;
	КонецЦикла;
	
	//	заполнение ЦЕНЫ
	_Артикул	= "@";
	Период		= НачалоЧаса(ТекущаяДатаСеанса());
	Объект.Цены.Очистить();
	Если Колонка_Артикул + Колонка_sku > 0 Тогда
		нн	= 1;
		Пока нн <= ?(Объект.ЭтоТест, 99, ТабДок.ВысотаТаблицы) Цикл
			нн = нн + 1;
			Артикул	= "";
			Если Колонка_Артикул = 0 Тогда
				Артикул	= Лев(ТабДок.Область(нн, Колонка_sku, нн, Колонка_sku).Текст, 14);
			Иначе
				Артикул	= ТабДок.Область(нн, Колонка_Артикул, нн, Колонка_Артикул).Текст;
			КонецЕсли;
			Если ПустаяСтрока(Артикул) Тогда
				Прервать;
			ИначеЕсли _Артикул = Артикул Тогда
				Продолжить;
			Иначе
				_Артикул = Артикул;
				
				ТекСтрока	= Новый Структура("Номенклатура", НоменклатураНайти(Артикул));
				Если НЕ ЗначениеЗаполнено(ТекСтрока.Номенклатура) Тогда Продолжить; КонецЕсли;
				
				Ошибок	= ?(Колонка_ЦенаБазис=0, 1, 0) + ?(Колонка_Цена=0, 2, 0);
				Если Колонка_ЦенаБазис > 0 Тогда
					ТекСтрока.Вставить("ЦенаБазис", ТабДок.Область(нн, Колонка_ЦенаБазис, нн, Колонка_ЦенаБазис).Текст);
					Ошибок	= Ошибок + ?(ПустаяСтрока(ТекСтрока.ЦенаБазис), 1, 0);
				КонецЕсли;
				Если Колонка_Цена > 0 Тогда
					ТекСтрока.Вставить("Цена", ТабДок.Область(нн, Колонка_Цена, нн, Колонка_Цена).Текст);
					Ошибок	= Ошибок + ?(ПустаяСтрока(ТекСтрока.Цена), 2, 0);
				КонецЕсли;
				Если Ошибок > 1 Тогда
					Прервать;
				Иначе
					ТекСтрока.Вставить("Период",		Период);
					ЗаполнитьЗначенияСвойств(Объект.Цены.Добавить(), ТекСтрока);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура Танкер2()
	Колонка_sku			= 0;
	Колонка_Размер		= 20;
	Колонка_Вес			= 21;
	Колонка_Артикул		= 0;
	нн		= 2;
	ИмяКолонки			= "/";
	Пока НЕ ПустаяСтрока(ИмяКолонки) Цикл
		ИмяКолонки 	 = ТабДок.Область(3, нн, 3, нн).Текст;
		Если ИмяКолонки = "SKU на Яндексе" Тогда
			Колонка_sku	= нн;
		ИначеЕсли ИмяКолонки = "Габариты с учетом упаковки (см)" Тогда
			Колонка_Размер	= нн;
		ИначеЕсли ИмяКолонки = "Вес с учетом упаковки (брутто, кг)" Тогда
			Колонка_Вес	= нн;
		ИначеЕсли НРег(ИмяКолонки) = "ваш sku" Тогда
			Колонка_Артикул	= нн;
			
		ИначеЕсли Колонка_sku * Колонка_Размер * Колонка_Вес * Колонка_Артикул > 0 Тогда
			Прервать;
		КонецЕсли;
		нн = нн + 1;
	КонецЦикла;
	
	//	заполнение РАЗМЕРЫ
	Объект.Размеры.Очистить();
	Если Колонка_sku * Колонка_Размер * Колонка_Вес * Колонка_Артикул > 0 Тогда
		нн	= 4;
		Пока нн <= ?(Объект.ЭтоТест, 99, ТабДок.ВысотаТаблицы) Цикл
			нн = нн + 1;
			ТекСтрока	= Новый Структура;
			ТекСтрока.Вставить("ЯндексSKU",	ТабДок.Область(нн, Колонка_sku, нн, Колонка_sku).Текст);
			ТекСтрока.Вставить("Артикул",	ТабДок.Область(нн, Колонка_Артикул, нн, Колонка_Артикул).Текст);
			ТекСтрока.Вставить("Размеры", 	ТабДок.Область(нн, Колонка_Размер, нн, Колонка_Размер).Текст);
			ТекСтрока.Вставить("Вес",		ТабДок.Область(нн, Колонка_Вес, нн, Колонка_Вес).Текст);
			Если ПустаяСтрока(ТекСтрока.ЯндексSKU) Тогда
				Прервать;
			Иначе
				мРазмеры = СтрРазделить(ТекСтрока.Размеры, "/");
				Если мРазмеры.Количество() = 3 Тогда
					ТекСтрока.Вставить("Длина", мРазмеры.Получить(0));
					ТекСтрока.Вставить("Ширина", мРазмеры.Получить(1));
					ТекСтрока.Вставить("Высота", мРазмеры.Получить(2));
				КонецЕсли;
				ЗаполнитьЗначенияСвойств(Объект.Размеры.Добавить(), ТекСтрока);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция НоменклатураНайти(Артикул)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Номенклатура.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Номенклатура КАК Номенклатура
	                      |ГДЕ
	                      |	Номенклатура.Артикул = &Артикул
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Номенклатура.ПометкаУдаления");
	Запрос.УстановитьПараметр("Артикул",	Артикул);
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.Ссылка, Справочники.Номенклатура.ПустаяСсылка());
КонецФункции

&НаСервере
Процедура КомандаЦеныЗаписатьНаСервере()
	НаСервере().ЦеныЗаписать();
КонецПроцедуры

&НаКлиенте
Процедура КомандаЦеныЗаписать(Команда)
	Если ПустаяСтрока(ПолноеИмяФайла) Тогда
		//
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.ВидЦены) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнено",, "ВидЦены", "Объект.ВидЦены");
	ИначеЕсли ПроверитьЗаполнение() Тогда
		КомандаЦеныЗаписатьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаРазмерыВыгрузитьНаСайт(Команда)
	КомандаРазмерыВыгрузитьНаСайтНаСервере();
КонецПроцедуры

&НаСервере
Процедура КомандаРазмерыВыгрузитьНаСайтНаСервере()
	НаСервере().РазмерыЗаписать();
КонецПроцедуры

&НаСервере
Функция CARDS_CREATEНаСервере()
	ИмяФайла = НаСервере().CARDS_CREATE();
	Если НЕ ПустаяСтрока(ИмяФайла) Тогда
		Возврат ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяФайла));
	КонецЕсли;
	Возврат "";
КонецФункции

&НаКлиенте
Процедура CARDS_CREATE(Команда)
	Адрес	= CARDS_CREATEНаСервере();
	Если НЕ ПустаяСтрока(Адрес) Тогда
		ФайлВременногоХранилища = ПолучитьИзВременногоХранилища(Адрес);
    	ИмяФайла				= ПолучитьИмяВременногоФайла(".yml");
		Попытка
		    ФайлВременногоХранилища.Записать(ИмяФайла);
		    УдалитьИзВременногоХранилища(Адрес);
			//ТабДок.Прочитать(ИмяФайла);
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
		//УдалитьФайлы(ИмяФайла);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура КомандаКатегорииЗаписатьНаСервере()
	Для Каждого ТекСтрока Из Объект.Категории Цикл
		Если ТекСтрока.Ошибка И ТипЗнч(ТекСтрока.мп_Категория) = Тип("Строка") Тогда
			НовКатегория	= Справочники.мп_Категории.СоздатьЭлемент();
			НовКатегория.Наименование		= ТекСтрока.мп_Категория;
			НовКатегория._MopDivision		= ТекСтрока.MopDivision;
			НовКатегория._MopDepartment		= ТекСтрока.MopDepartment;
			НовКатегория._MopSubDepartment	= ТекСтрока.MopSubDepartment;
			НовКатегория._MopCategory		= ТекСтрока.MopCategory;
			НовКатегория._MopClass			= ТекСтрока.MopClass;
			НовКатегория.УстановитьНовыйКод();
			Если НовКатегория.ПроверитьЗаполнение() Тогда
				Попытка
					НовКатегория.Записать();
					ТекСтрока.Категория	= НовКатегория.Ссылка;
					ТекСтрока.Ошибка	= Ложь;
				Исключение
					Сообщить(ОписаниеОшибки());
					Прервать;
				КонецПопытки;
			Иначе
				Прервать;
			КонецЕсли;
		КонецЕсли;
		Если НЕ ТекСтрока.Ошибка Тогда
			Если НЕ ПустаяСтрока(ТекСтрока.КатегорияID) И НЕ ПустаяСтрока(ТекСтрока.Категория) Тогда
				НЗ = РегистрыСведений.мп_ДанныеКарточек.СоздатьНаборЗаписей();
				НЗ.Отбор.Аттрибут.Установить(Справочники.мп_АттрибутыКарточек.КатегорияID);
				НЗ.Отбор.СсылкаОбъекта.Установить(ТекСтрока.мп_Категория);
				НЗ.Отбор.ИнтернетМагазин.Установить(Справочники.ИнтернетМагазины.ПустаяСсылка());
				НЗ.Прочитать();
				Если НЗ.Количество() = 0 Тогда
					ТекЗапись = НЗ.Добавить();
					ТекЗапись.Аттрибут		= Справочники.мп_АттрибутыКарточек.КатегорияID;
					ТекЗапись.СсылкаОбъекта	= ТекСтрока.мп_Категория;
					ТекЗапись.Значение		= ТекСтрока.КатегорияID;
					НЗ.Записать();
				КонецЕсли;
				НЗ = РегистрыСведений.мп_ДанныеКарточек.СоздатьНаборЗаписей();
				НЗ.Отбор.Аттрибут.Установить(Справочники.мп_АттрибутыКарточек.Категория);
				НЗ.Отбор.СсылкаОбъекта.Установить(ТекСтрока.мп_Категория);
				НЗ.Отбор.ИнтернетМагазин.Установить(Справочники.ИнтернетМагазины.ПустаяСсылка());
				НЗ.Прочитать();
				Если НЗ.Количество() = 0 Тогда
					ТекЗапись = НЗ.Добавить();
					ТекЗапись.Аттрибут		= Справочники.мп_АттрибутыКарточек.Категория;
					ТекЗапись.СсылкаОбъекта	= ТекСтрока.мп_Категория;
					ТекЗапись.Значение		= ТекСтрока.Категория;
					НЗ.Записать();
				КонецЕсли;
			КонецЕсли;
				
			Если НЕ ПустаяСтрока(ТекСтрока.КомплектацияID) И НЕ ПустаяСтрока(ТекСтрока.Комплектация) Тогда
				НЗ = РегистрыСведений.мп_ДанныеКарточек.СоздатьНаборЗаписей();
				НЗ.Отбор.Аттрибут.Установить(Справочники.мп_АттрибутыКарточек.КомплектацияID);
				НЗ.Отбор.СсылкаОбъекта.Установить(ТекСтрока.мп_Категория);
				НЗ.Отбор.ИнтернетМагазин.Установить(Справочники.ИнтернетМагазины.ПустаяСсылка());
				НЗ.Прочитать();
				Если НЗ.Количество() = 0 Тогда
					ТекЗапись = НЗ.Добавить();
					ТекЗапись.Аттрибут		= Справочники.мп_АттрибутыКарточек.КомплектацияID;
					ТекЗапись.СсылкаОбъекта	= ТекСтрока.мп_Категория;
					ТекЗапись.Значение		= ТекСтрока.КомплектацияID;
					НЗ.Записать();
				КонецЕсли;
				НЗ = РегистрыСведений.мп_ДанныеКарточек.СоздатьНаборЗаписей();
				НЗ.Отбор.Аттрибут.Установить(Справочники.мп_АттрибутыКарточек.Комплектация);
				НЗ.Отбор.СсылкаОбъекта.Установить(ТекСтрока.мп_Категория);
				НЗ.Отбор.ИнтернетМагазин.Установить(Справочники.ИнтернетМагазины.ПустаяСсылка());
				НЗ.Прочитать();
				Если НЗ.Количество() = 0 Тогда
					ТекЗапись = НЗ.Добавить();
					ТекЗапись.Аттрибут		= Справочники.мп_АттрибутыКарточек.Комплектация;
					ТекЗапись.СсылкаОбъекта	= ТекСтрока.мп_Категория;
					ТекЗапись.Значение		= ТекСтрока.Комплектация;
					НЗ.Записать();
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КомандаКатегорииЗаписать(Команда)
	КомандаКатегорииЗаписатьНаСервере();
	ОбновитьОтображениеДанных();
КонецПроцедуры
