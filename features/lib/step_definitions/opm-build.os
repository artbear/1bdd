﻿// Реализация шагов BDD-фич/сценариев с помощью фреймворка https://github.com/artbear/1bdd
#Использовать tempfiles

Перем БДД; // контекст фреймворка 1bdd

// Метод выдает список шагов, реализованных в данном файле-шагов
Функция ПолучитьСписокШагов(КонтекстФреймворкаBDD) Экспорт
	БДД = КонтекстФреймворкаBDD;

	ВсеШаги = Новый Массив;

	ВсеШаги.Добавить("ЯСобираюПакетВоВременномКаталоге");
	ВсеШаги.Добавить("ЯУстанавливаюПакетИзФайлаСобранногоПакета");
	ВсеШаги.Добавить("ЯВыполняюКомандуПолученияВерсииУстановленногоПакета");
	ВсеШаги.Добавить("ВерсияУстановленногоПакетаРавнаВерсииПакетаИзКонтекста");

	Возврат ВсеШаги;
КонецФункции

// Реализация шагов

// Процедура выполняется перед запуском каждого сценария
Процедура ПередЗапускомСценария(Знач Узел) Экспорт

КонецПроцедуры

// Процедура выполняется после завершения каждого сценария
Процедура ПослеЗапускаСценария(Знач Узел) Экспорт

КонецПроцедуры

// Я собираю пакет во временном каталоге
Процедура ЯСобираюПакетВоВременномКаталоге() Экспорт
	ПутьВременногоКаталога = БДД.ПолучитьИзКонтекста("ВременныйКаталог");
	СтрокаЗапуска = СтрШаблон("opm build --out %2 %1", ТекущийКаталог(), ПутьВременногоКаталога);
	КодВозврата = ВыполнитьКоманду(СтрокаЗапуска);

	Ожидаем.Что(КодВозврата,
		"Ожидали, что сборка пакета (opm build) завершится с кодом возврата 0, а получили другое значение").
		Равно(0);
КонецПроцедуры

// я устанавливаю пакет из файла собранного пакета
Процедура ЯУстанавливаюПакетИзФайлаСобранногоПакета() Экспорт
	ЗапоминаюСобранныйФайлПакетаВКонтексте();
	ЗапоминаюВерсиюСобранногоПакетаВКонтексте();
	ФайлСобранногоПакета = БДД.ПолучитьИзКонтекста("ФайлСобранногоПакета");

	СтрокаЗапуска = СтрШаблон("opm install -f %1 -l", ФайлСобранногоПакета.Имя);
	КодВозврата = ВыполнитьКоманду(СтрокаЗапуска);

	Ожидаем.Что(КодВозврата, "ВыполнитьЛокальнуюУстановкуСобранногоПакета КодВозврата").Равно(0);

КонецПроцедуры

// я выполняю команду получения версии установленного пакета "oscript src\main.os version"
Процедура ЯВыполняюКомандуПолученияВерсииУстановленногоПакета(Знач СтрокаЗапуска) Экспорт
	УстановленнаяВерсияПакета = "";
	КодВозврата = ВыполнитьКоманду(СтрокаЗапуска, УстановленнаяВерсияПакета);
	Ожидаем.Что(КодВозврата, "Должны были получить код возврата 0, а это не так").Равно(0);
	УстановленнаяВерсияПакета = СокрЛП(УстановленнаяВерсияПакета);
	БДД.СохранитьВКонтекст("УстановленнаяВерсияПакета", УстановленнаяВерсияПакета);

КонецПроцедуры

// версия установленного пакета равна версии пакета из контекста
Процедура ВерсияУстановленногоПакетаРавнаВерсииПакетаИзКонтекста() Экспорт
	УстановленнаяВерсияПакета = БДД.ПолучитьИзКонтекста("УстановленнаяВерсияПакета");
	ВерсияСобранногоПакета = БДД.ПолучитьИзКонтекста("ВерсияСобранногоПакета");

	ВерсияСобранногоПакета = СокрЛП(ВерсияСобранногоПакета);

	СообщениеОшибки = СтрШаблон("Ожидали, что установленная версия <%1> равна версии из исходников проекта",
								УстановленнаяВерсияПакета);
	Если УстановленнаяВерсияПакета <> ВерсияСобранногоПакета 
		И Найти(УстановленнаяВерсияПакета, ВерсияСобранногоПакета) = Неопределено Тогда

		ВызватьИсключение СообщениеОшибки;

	КонецЕсли;
КонецПроцедуры

Функция ВыполнитьКоманду(Знач СтрокаКоманды, ТекстВывода = "")
	Команда = Новый Команда;
	Команда.ПоказыватьВыводНемедленно(Истина);

	Команда.УстановитьСтрокуЗапуска(СтрокаКоманды);

	КодВозврата = Команда.Исполнить();
	ТекстВывода = Команда.ПолучитьВывод();

	Если КодВозврата <> 0 Тогда
		Сообщить(ТекстВывода);
	КонецЕсли;
	Возврат КодВозврата;
КонецФункции

// запоминаю собранный файл пакета в контексте
Процедура ЗапоминаюСобранныйФайлПакетаВКонтексте() // Экспорт
	ПутьВременногоКаталога = БДД.ПолучитьИзКонтекста("ВременныйКаталог");
	МассивФайлов = НайтиФайлы(ПутьВременногоКаталога, "*.ospx", Ложь);
	Ожидаем.Что(МассивФайлов.Количество(), "Должны были найти только 1 собранный пакет, а не несколько").Равно(1);
	ФайлПакета = МассивФайлов[0];
	БДД.СохранитьВКонтекст("ФайлСобранногоПакета", ФайлПакета);
КонецПроцедуры

// я выполняю команду получения версии установленного пакета
Процедура ЗапоминаюВерсиюСобранногоПакетаВКонтексте() // Экспорт
	ФайлПакета = БДД.ПолучитьИзКонтекста("ФайлСобранногоПакета");
	РегулярноеВыражение = Новый РегулярноеВыражение("([^-]+-[^-]+|[^-]+)-(\d+\.(\d+\.)*\d+)\.ospx");
	Совпадения = РегулярноеВыражение.НайтиСовпадения(ФайлПакета.Имя);
	СообщениеОшибки = СтрШаблон("Должны были файл пакета с правильным форматом имени, а это не так. <%1>", ФайлПакета.Имя);
	Ожидаем.Что(Совпадения.Количество(), СообщениеОшибки).Равно(1);
	Ожидаем.Что(Совпадения[0].Группы.Количество(), "Количество групп должно быть 1").БольшеИлиРавно(3);
	ИмяСобранногоПакета = Совпадения[0].Группы[1].Значение;
	ВерсияПакета = Совпадения[0].Группы[2].Значение;

	БДД.СохранитьВКонтекст("ИмяСобранногоПакета", ИмяСобранногоПакета);
	БДД.СохранитьВКонтекст("ВерсияСобранногоПакета", ВерсияПакета);
КонецПроцедуры
