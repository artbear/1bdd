﻿#Использовать logos

Перем Лог;

Перем БДД;

// TODO следующие экспорты нужны для работы соседних скриптов/шагов до появления повторно используемых шагов
Перем ВременныйКаталогФичи Экспорт;
Перем ФайлИсходнойФичи;
Перем ФайлФичи;
Перем СохраненныеПараметрыКоманднойСтроки;

Функция ПолучитьСписокШагов(КонтекстФреймворкаBDD) Экспорт
	БДД = КонтекстФреймворкаBDD;

	ВсеШаги = Новый Массив;

	ВсеШаги.Добавить("ЯПодготовилТестовыйКаталогДляФич");
	ВсеШаги.Добавить("ЯПодготовилСпециальнуюТестовуюФичу");
	ВсеШаги.Добавить("УстановилТестовыйКаталогКакТекущий");
	ВсеШаги.Добавить("ЯЗапустилГенерациюШаговФичи");
	ВсеШаги.Добавить("ЯПолучилСгенерированныйOs_ФайлВОжидаемомКаталоге");
	ВсеШаги.Добавить("ПроверкаПоведенияФичиЗакончиласьСКодомВозврата");
	ВсеШаги.Добавить("ЯПодставилФайлШаговСУжеРеализованнымиШагамиДляФичи");
	ВсеШаги.Добавить("ЯЗапустилВыполнениеФичиСПередачейПараметра");
	ВсеШаги.Добавить("ЯСоздалФайлФичиСТекстом");
	ВсеШаги.Добавить("ЯСоздалЕщеОдинКаталог");
	ВсеШаги.Добавить("УстановилКаталогКакТекущий");
	ВсеШаги.Добавить("ЯЗапустилВыполнениеФичи");
	ВсеШаги.Добавить("ПроверкаПоведенияФичСПередачейПараметраИзКаталогаЗакончиласьСКодомВозврата");

	Возврат ВсеШаги;
КонецФункции

Функция ИмяЛога() Экспорт
	Возврат "bdd.ПроверкаГенерации.feature";
КонецФункции

Процедура Инициализация() Экспорт
	СохраненныеПараметрыКоманднойСтроки = "";
КонецПроцедуры

//я подготовил тестовый каталог для фич
Процедура ЯПодготовилТестовыйКаталогДляФич() Экспорт
	Инициализация();

	ВременныйКаталогФичи = Новый Файл(ВременныеФайлы.СоздатьКаталог());
	Лог.Отладка("Использую временный каталог "+ВременныйКаталогФичи.ПолноеИмя);
КонецПроцедуры

//я подготовил специальную тестовую фичу "ПередачаПараметров"
Процедура ЯПодготовилСпециальнуюТестовуюФичу(ИмяФичи) Экспорт

	ФайлИсходнойФичи = ПолучитьФайлИсходнойФичи(ИмяФичи);

	ПодготовитьТестовыйКаталогСФичей(ФайлИсходнойФичи);

	ФайлФичи = ПолучитьТестовыйФайлФичи(ИмяФичи);
	Лог.Отладка("Подготовлена тестовая фича "+ФайлФичи.ПолноеИмя);
КонецПроцедуры

//я запустил генерацию шагов фичи "ПередачаПараметров"
Процедура ЯЗапустилГенерациюШаговФичи(ИмяФичи) Экспорт
	ПутьИсполнителяБДД = ОбъединитьПути(ПолучитьКаталогИсходников(), "bdd.os");
	ФайлИсполнителя = Новый Файл(ПутьИсполнителяБДД);
	Ожидаем.Что(ФайлИсполнителя.Существует(), "Ожидаем, что скрипт исполнителя шагов существует, а его нет. "+ФайлИсполнителя.ПолноеИмя).Равно(Истина);

	ИмяЛогаКоманды = ОбъединитьПути(ФайлФичи.Путь, "gen-log.txt");
	СтрокаКоманды = СтрШаблон("cmd /c oscript.exe %4 %1 gen %2 -debug on %3", ПутьИсполнителяБДД, ИмяФичи + ".feature",
		СуффиксПеренаправленияВывода(ИмяЛогаКоманды, Ложь), "-encoding=utf-8");
	Лог.Отладка("СтрокаКоманды "+СтрокаКоманды);

	КодВозврата = Неопределено;
	ЗапуститьПриложение(СтрокаКоманды, ФайлФичи.Путь, Истина, КодВозврата);

	ВывестиТекстФайла(ИмяЛогаКоманды);

	Ожидаем.Что(КодВозврата, "Ожидаем, что код возврата равен 0, а это не так").Равно(0);
КонецПроцедуры

//я получил сгенерированный os-файл в ожидаемом каталоге
Процедура ЯПолучилСгенерированныйOs_ФайлВОжидаемомКаталоге() Экспорт
	 ФайлШагов = Новый Файл(ОбъединитьПути(ФайлФичи.Путь, "step_definitions", ФайлФичи.ИмяБезРасширения+".os"));
	 Ожидаем.Что(ФайлШагов.Существует(), "Ожидаем, что файл исполнителя шагов существует, а его нет. "+ФайлШагов.ПолноеИмя).Равно(Истина);
КонецПроцедуры

//проверка поведения фичи "ПередачаПараметров" закончилась со статусом "НеРеализован"
Процедура ПроверкаПоведенияФичиЗакончиласьСоСтатусом(ИмяФичи, ОжидаемыйСтатусВыполненияСтрока) Экспорт
	Контекст = Новый Структура("Контекст", Новый Структура("Журнал", Новый Структура));
	ИсполнительБДД = ЗагрузитьСценарий(ОбъединитьПути(ПолучитьКаталогИсходников(), "bdd-exec.os"), Контекст);

	ОжидаемыйСтатусВыполнения = ИсполнительБДД.ВозможныеСтатусыВыполнения()[ОжидаемыйСтатусВыполненияСтрока];

	РезультатыВыполнения = ИсполнительБДД.ВыполнитьФичу(ФайлФичи);

	Ожидаем.Что(РезультатыВыполнения, "Ожидали, что дерево фич будет получено как дерево значений, а это не так").ИмеетТип("ДеревоЗначений");

	Функциональность0 = РезультатыВыполнения.Строки[0];
	СообщениеОбОшибке = СтрШаблон("Ожидали, что статус выполнения Функциональность0 будет %1, а это не так", ОжидаемыйСтатусВыполнения);
	Ожидаем.Что(Функциональность0.СтатусВыполнения, СообщениеОбОшибке).Равно(ОжидаемыйСтатусВыполнения);

КонецПроцедуры

//проверка поведения фичи "ПередачаПараметров" закончилась с кодом возврата 1
Процедура ПроверкаПоведенияФичиЗакончиласьСКодомВозврата(Знач ИмяФичи, Знач ОжидаемыйКодВозврата) Экспорт
	ПроверитьПоведениеФичиИлиКаталога(ИмяФичи, "", ОжидаемыйКодВозврата);
КонецПроцедуры

//проверка поведения фич с передачей параметра "" из каталога "." закончилась с кодом возврата 0
Процедура ПроверкаПоведенияФичСПередачейПараметраИзКаталогаЗакончиласьСКодомВозврата(Знач ПараметрыКоманднойСтроки, Знач ПутьКаталога, Знач ОжидаемыйКодВозврата) Экспорт
	ПроверитьПоведениеФичиИлиКаталога(ПутьКаталога, ПараметрыКоманднойСтроки, ОжидаемыйКодВозврата);
КонецПроцедуры

Процедура ПроверитьПоведениеФичиИлиКаталога(Знач ИмяФичиИлиПутьКаталога, Знач ПараметрыКоманднойСтроки, ОжидаемыйКодВозврата)
	Если ИмяФичиИлиПутьКаталога = "КаталогТестовыйПолный" Тогда
		ИмяФичиИлиПутьКаталога = ВременныйКаталогФичи.ПолноеИмя;
	ИначеЕсли ИмяФичиИлиПутьКаталога = "КаталогТестовыйОтносительный" Тогда
		ИмяФичиИлиПутьКаталога = ОбъединитьПути("..", ВременныйКаталогФичи.Имя);
	КонецЕсли;

	ПутьИсполнителяБДД = ОбъединитьПути(ПолучитьКаталогИсходников(), "bdd.os");
	ФайлИсполнителя = Новый Файл(ПутьИсполнителяБДД);
	Ожидаем.Что(ФайлИсполнителя.Существует(), "Ожидаем, что скрипт исполнителя шагов существует, а его нет. "+ФайлИсполнителя.ПолноеИмя).Равно(Истина);

	ФайлФичиИлиКаталога = Новый Файл(ИмяФичиИлиПутьКаталога);
	Если Не ФайлФичиИлиКаталога.Существует() Тогда
		ФайлФичиИлиКаталога = Новый Файл(ИмяФичиИлиПутьКаталога + ".feature");
	КонецЕсли;

	ИмяЛогаКоманды = ОбъединитьПути(ТекущийКаталог(), "exec-log.txt");
	СтрокаКоманды = СтрШаблон("cmd /c oscript.exe %4 %1 %2 %3 %5", ПутьИсполнителяБДД, ФайлФичиИлиКаталога.ПолноеИмя,
		СохраненныеПараметрыКоманднойСтроки, "-encoding=utf-8", СуффиксПеренаправленияВывода(ИмяЛогаКоманды, Ложь));
	Лог.Отладка("СтрокаКоманды "+СтрокаКоманды);

	КодВозврата = Неопределено;
	ЗапуститьПриложение(СтрокаКоманды, ТекущийКаталог(), Истина, КодВозврата);

	ВывестиТекстФайла(ИмяЛогаКоманды);

	Ожидаем.Что(КодВозврата, "ПроверитьПоведениеФичиИлиКаталога").Равно(ОжидаемыйКодВозврата);
КонецПроцедуры

//я запустил выполнение фичи "ФичаБезШагов" с передачей параметра "-require СтруктураСценария.feature"
Процедура ЯЗапустилВыполнениеФичиСПередачейПараметра(Знач ИмяФичи, Знач ПараметрыКоманднойСтроки) Экспорт
	СохраненныеПараметрыКоманднойСтроки = ПараметрыКоманднойСтроки;
КонецПроцедуры

//я запустил выполнение фичи "ПередачаПараметров"
Процедура ЯЗапустилВыполнениеФичи(Знач ИмяФичи) Экспорт
	СохраненныеПараметрыКоманднойСтроки = "";
КонецПроцедуры

//я подставил файл шагов с уже реализованными шагами для фичи "ПередачаПараметров"()
Процедура ЯПодставилФайлШаговСУжеРеализованнымиШагамиДляФичи(ИмяФичи) Экспорт
	ИмяИсполнителяШагов = ФайлИсходнойФичи.ИмяБезРасширения+ ".os";
	ИсходныйФайлИсполнителяШагов = Новый Файл(ОбъединитьПути(ФайлИсходнойФичи.Путь, "step_definitions", ИмяИсполнителяШагов ));
	ФайлИсполнителяШагов = Новый Файл(ОбъединитьПути(ФайлФичи.Путь, "step_definitions", ИмяИсполнителяШагов ));

	Если ФайлИсполнителяШагов.Существует() Тогда
		УдалитьФайлы(ФайлИсполнителяШагов.ПолноеИмя);
	КонецЕсли;
	КопироватьФайл(ИсходныйФайлИсполнителяШагов.ПолноеИмя, ФайлИсполнителяШагов.ПолноеИмя);
КонецПроцедуры

//установил тестовый каталог как текущий
Процедура УстановилТестовыйКаталогКакТекущий() Экспорт
	 УстановитьТекущийКаталог(ВременныйКаталогФичи.ПолноеИмя);
КонецПроцедуры

//я создал еще один каталог "lib"
Процедура ЯСоздалЕщеОдинКаталог(ИмяКаталога) Экспорт
	 СоздатьКаталог(ОбъединитьПути(ВременныйКаталогФичи.ПолноеИмя, ИмяКаталога));
КонецПроцедуры

//установил каталог "lib" как текущий
Процедура УстановилКаталогКакТекущий(ИмяКаталога) Экспорт
	УстановитьТекущийКаталог(ОбъединитьПути(ВременныйКаталогФичи.ПолноеИмя, ИмяКаталога));
КонецПроцедуры

//я создал файл фичи "ФичаБезШагов" с текстом
//"""
//# language: ru
//Функционал: Библиотечные шаги
//Сценарий: Использование шагов из другой фичи
//	Когда я передаю параметр "Минимальный"
//	Тогда я получаю параметр "Минимальный"
//"""
Процедура ЯСоздалФайлФичиСТекстом(Знач ИмяФичи, Знач ТекстФичи) Экспорт
	ЗаписьФайла = Новый ЗаписьТекста(ПутьВоВременномКаталоге(ИмяФичи + ".feature"), "utf-8");

	Для Счетчик = 1 По СтрЧислоСтрок(ТекстФичи) Цикл
		Строка = СтрПолучитьСтроку(ТекстФичи, Счетчик);
		ЗаписьФайла.ЗаписатьСтроку(Строка);
		//Лог.Отладка("Записываю в файл шагов ----- "+Строка);
	КонецЦикла;

	ЗаписьФайла.Закрыть();
КонецПроцедуры

Функция ПолучитьТестовыйФайлФичи(ИмяФичи)
	ФайлТекущегоКаталога = Новый Файл(ТекущийКаталог());
	ФайлФичи = Новый Файл(ОбъединитьПути(ФайлТекущегоКаталога.ПолноеИмя, ИмяФичи+".feature"));
	Возврат ФайлФичи;
КонецФункции

// TODO дубль метода с несколькими тестовыми файлами
Процедура ПодготовитьТестовыйКаталогСФичей(ФайлИсходнойФичи)
	ФайлТекущегоКаталога = Новый Файл(ТекущийКаталог());

	КопироватьФайл(ФайлИсходнойФичи.ПолноеИмя, ОбъединитьПути(ФайлТекущегоКаталога.ПолноеИмя, ФайлИсходнойФичи.Имя ));

	ИмяИсполнителяШагов = ФайлИсходнойФичи.ИмяБезРасширения+ ".os";
	КаталогИсполнителяШагов = ОбъединитьПути(ФайлТекущегоКаталога.ПолноеИмя, "step_definitions" );
	СоздатьКаталог(КаталогИсполнителяШагов);

	ФайлИсполнителяШагов = Новый Файл(ОбъединитьПути(КаталогИсполнителяШагов, ИмяИсполнителяШагов ));

	Ожидаем.Что(ФайлИсполнителяШагов.Существует(), "Ожидаем, что файл исполнителя шагов не существует, а он есть. "+ФайлИсполнителяШагов.ПолноеИмя).Равно(Ложь);
КонецПроцедуры

Процедура ВывестиТекстФайла(Знач ИмяФайла, Знач Кодировка = Неопределено)

	Файл = Новый Файл(ИмяФайла);
	Если НЕ Файл.Существует() Тогда
		Лог.Отладка("Не существует лог-файл <"+ИмяФайла+">");
		Возврат;
	КонецЕсли;

	Если Кодировка = Неопределено Тогда
		Кодировка = "utf-8";
	КонецЕсли;

	ЧТ = Новый ЧтениеТекста(ИмяФайла, Кодировка);
	СтрокаФайла = ЧТ.Прочитать();
	ЧТ.Закрыть();

	Лог.Информация("");
	Лог.Информация("  ----------------    ----------------    ----------------  ");
	Лог.Информация(СтрокаФайла);
	Лог.Информация("  ----------------    ----------------    ----------------  ");
	Лог.Информация("");

КонецПроцедуры

Функция СуффиксПеренаправленияВывода(Знач ИмяФайлаПриемника, Знач УчитыватьStdErr = Истина)
	Возврат "> """ + ИмяФайлаПриемника + """" + ?(УчитыватьStdErr, " 2>&1", "");
КонецФункции

Функция ПолучитьКаталогИсходников() Экспорт
	КаталогПроекта = ОбъединитьПути(ТекущийСценарий().Каталог, "..", "..", "..");
	Возврат ОбъединитьПути(КаталогПроекта, "src");
КонецФункции // ПолучитьКаталогИсходников()

Функция ПолучитьФайлИсходнойФичи(ИмяФичи)
	Возврат Новый Файл(ОбъединитьПути(ТекущийСценарий().Каталог, "..", ИмяФичи+".feature"));
КонецФункции // ПолучитьФайлИсходнойФичи()

Функция ПутьВоВременномКаталоге(ИмяФайла)
	Возврат ОбъединитьПути(ВременныйКаталогФичи.ПолноеИмя, ИмяФайла);
КонецФункции // ПутьВоВременномКаталоге(ИмяФайла)

Лог = Логирование.ПолучитьЛог(ИмяЛога());
//Лог.УстановитьУровень(УровниЛога.Отладка);
СохраненныеПараметрыКоманднойСтроки = "";
