//----------------------------------------------------------
//This Source Code Form is subject to the terms of the
//Mozilla Public License, v.2.0. If a copy of the MPL
//was not distributed with this file, You can obtain one
//at http://mozilla.org/MPL/2.0/.
//---------------------------------------------------------

///////////////////////////////////////////////////////////////////
// Стартовый модуль синхронизатора

#Использовать tempfiles
#Использовать cmdline
#Использовать logos

Перем Лог;
Перем УдалятьВременныеФайлы;

///////////////////////////////////////////////////////////////////
//{ Прикладные процедуры и функции

Функция РазобратьАргументыКоманднойСтроки()

	Если АргументыКоманднойСтроки.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;

	Парсер = Новый ПарсерАргументовКоманднойСтроки();

	ДобавитьКомандуExec(Парсер);
	ДобавитьКомандуGenerate(Парсер);
	ДобавитьКомандуHelp(Парсер);
	ДобавитьАргументыПоУмолчанию(Парсер);

	Параметры = Парсер.Разобрать(АргументыКоманднойСтроки);

	Возврат Параметры;

КонецФункции

Процедура ДобавитьКомандуExec(Знач Парсер)

	Команда = Парсер.ОписаниеКоманды("exec");

	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "ПутьФичи");

	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-out");
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-debug");
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-verbose");
	Парсер.ДобавитьКоманду(Команда);

КонецПроцедуры

Процедура ДобавитьКомандуGenerate(Знач Парсер)

	Команда = Парсер.ОписаниеКоманды("generate");

	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "ПутьФичи");

	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-out");
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-debug");
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-verbose");
	Парсер.ДобавитьКоманду(Команда);

КонецПроцедуры

Процедура ДобавитьКомандуHelp(Знач Парсер)

	Команда = Парсер.ОписаниеКоманды("help");

	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "КомандаДляСправки");
	Парсер.ДобавитьКоманду(Команда);

КонецПроцедуры

Процедура ДобавитьАргументыПоУмолчанию(Знач Парсер)

	Парсер.ДобавитьПараметр("ПутьФичи");

	Парсер.ДобавитьИменованныйПараметр("-out");
	Парсер.ДобавитьИменованныйПараметр("-debug");
	Парсер.ДобавитьИменованныйПараметр("-verbose");

КонецПроцедуры

Функция ВыполнитьОбработку(Знач Параметры)

	Если ТипЗнч(Параметры) = Тип("Структура") Тогда
		УстановитьРежимОтладкиПриНеобходимости(Параметры.ЗначенияПараметров);
		КодВозврата = ВыполнитьКоманду(Параметры);
	Иначе

		УстановитьРежимОтладкиПриНеобходимости(Параметры);

		КодВозврата = ВыполнитьФичу(Параметры["ПутьФичи"]);

	КонецЕсли;

	Возврат КодВозврата;
КонецФункции

Функция ВыполнитьКоманду(Знач ОписаниеКоманды)

	УстановитьРежимОтладкиПриНеобходимости(ОписаниеКоманды.ЗначенияПараметров);

	КодВозврата = 0;
	Если ОписаниеКоманды.Команда = "exec" Тогда
		КодВозврата = ВыполнитьФичу(ОписаниеКоманды.ЗначенияПараметров["ПутьФичи"]);
	ИначеЕсли ОписаниеКоманды.Команда = "generate" Тогда
		СоздатьФайлРеализацииШагов(ОписаниеКоманды.ЗначенияПараметров["ПутьФичи"]);
	ИначеЕсли ОписаниеКоманды.Команда = "help" Тогда
		ВывестиСправкуПоКомандам(ОписаниеКоманды.ЗначенияПараметров["КомандаДляСправки"]);
	Иначе
		ВызватьИсключение "Неизвестная команда: " + ОписаниеКоманды.Команда;
	КонецЕсли;

	Возврат КодВозврата;
КонецФункции

Функция ВыполнитьФичу(ПутьФичи)
	Лог.Отладка("ПутьФичи "+ПутьФичи);

	Контекст = Новый Структура("Контекст", Новый Структура("Журнал", Новый Структура));

	ПутьИсполнителя = ОбъединитьПути(ТекущийСценарий().Каталог, "bdd-exec.os");
	Лог.Отладка("Создаю исполнителя. Путь "+ПутьИсполнителя);
	ИсполнительБДД = ЗагрузитьСценарий(ПутьИсполнителя, Контекст);

	ДопЛог = Логирование.ПолучитьЛог(ИсполнительБДД.ИмяЛога());
	ДопЛог.УстановитьУровень(Лог.Уровень());

	ФайлФичи = Новый Файл(ПутьФичи);
	РезультатыВыполнения = ИсполнительБДД.ВыполнитьФичу(ФайлФичи);

	КодВозврата = ИсполнительБДД.ВозможныеКодыВозвратовПроцесса()[РезультатыВыполнения.Строки[0].СтатусВыполнения];

	ИсполнительБДД.ВывестиИтоговыеРезультатыВыполнения(РезультатыВыполнения);

	Возврат КодВозврата;
КонецФункции

Процедура СоздатьФайлРеализацииШагов(ПутьФичи)
	Лог.Отладка("ПутьФичи "+ПутьФичи);

	ПутьГенератора = ОбъединитьПути(ТекущийСценарий().Каталог, "bdd-generate.os");
	Лог.Отладка("Создаю помощника для генерации файла шагов. Путь "+ПутьГенератора);
	ГенераторШагов = ЗагрузитьСценарий(ПутьГенератора);

	ДопЛог = Логирование.ПолучитьЛог(ГенераторШагов.ИмяЛога());
	ДопЛог.УстановитьУровень(Лог.Уровень());

	ФайлФичи = Новый Файл(ПутьФичи);
	ФайлШагов = ГенераторШагов.СоздатьФайлРеализацииШагов(ФайлФичи);
КонецПроцедуры

Процедура УстановитьРежимОтладкиПриНеобходимости(Знач Параметры)
	Если Параметры["-debug"] = "on" Тогда
		Лог.УстановитьУровень(УровниЛога.Отладка);
		УдалятьВременныеФайлы = Ложь;
	КонецЕсли;
	Если Параметры["-verbose"] = "on" Тогда
		Лог.УстановитьУровень(УровниЛога.Отладка);
	КонецЕсли;
КонецПроцедуры

Процедура ПоказатьИнформациюОПараметрахКоманднойСтроки()

	Сообщить("Выполнение сценариев BDD для Gherkin-спецификаций.");
	Сообщить("Использование: ");
	Сообщить("	bdd <features-path> [ключи]");
	Сообщить("	bdd <команда> <параметры команды> [ключи]");
	Сообщить("Возможные команды:");
	Сообщить("	exec
			|	generate");

	Сообщить("Возможные ключи:");
	Сообщить("	-out <путь лог-файла>
			|	-debug <on|off> - включает режим отладки (полный лог + остаются временные файлы)
			|	-verbose <on|off> - включается полный лог");

	Сообщить("Для подсказки по конкретной команде наберите bdd help <команда>");

КонецПроцедуры

Процедура ВывестиСправкуПоКомандам(Знач Команда) Экспорт

	Если Команда = "exec" Тогда

		Сообщить("Выполняет сценарии BDD для Gherkin-спецификаций");
		Сообщить("bdd exec <features-path> [ключи]");
		Сообщить("Возможные ключи:");
		Сообщить("	-out <путь лог-файла>
				|	-debug <on|off> - включает режим отладки (полный лог + остаются временные файлы)
				|	-verbose <on|off> - включается полный лог");

	ИначеЕсли Команда = "generate" Тогда

		Сообщить("Создает заготовки шагов для указанных Gherkin-спецификаций");
		Сообщить("bdd generate <features-path> [ключи]");
		Сообщить("Возможные ключи:");
		Сообщить("	-out <путь лог-файла>
				|	-debug <on|off> - включает режим отладки (полный лог + остаются временные файлы)
				|	-verbose <on|off> - включается полный лог");

	Иначе
		Сообщить("Неизвестная команда: " + Команда);
	КонецЕсли;

КонецПроцедуры

Процедура УдалитьВременныеФайлыПриНеобходимости()
	Если УдалятьВременныеФайлы Тогда
		ВременныеФайлы.Удалить();
	КонецЕсли;
КонецПроцедуры
//}

///////////////////////////////////////////////////////////////////
//{ Точка входа в приложение

Лог = Логирование.ПолучитьЛог("oscript.app.bdd");
УдалятьВременныеФайлы = Истина;

КодВозврата = 0;

Попытка
	Параметры = РазобратьАргументыКоманднойСтроки();
	Если Параметры <> Неопределено Тогда
		КодВозврата = ВыполнитьОбработку(Параметры);
	Иначе
		ПоказатьИнформациюОПараметрахКоманднойСтроки();
		Лог.Ошибка("Указаны некорректные аргументы командной строки");
		УдалитьВременныеФайлыПриНеобходимости();
		ЗавершитьРаботу(0);
	КонецЕсли;
	УдалитьВременныеФайлыПриНеобходимости();
	Лог.Закрыть();
	ЗавершитьРаботу(КодВозврата);
Исключение
	Лог.Ошибка(ОписаниеОшибки());
	УдалитьВременныеФайлыПриНеобходимости();
	Лог.Закрыть();
	ЗавершитьРаботу(-1);
КонецПопытки;
//}
