# language: ru

Функционал: Выполнение фич
	Как Разработчик фич
	Я Хочу иметь легкий путь для выполнения сценариев по имени
	Чтобы мне не нужно было выполнять полный набор тестовых наборов, когда мне это не нужно

Контекст: Каталог проекта устанавливаю как текущий
	Допустим установил каталог проекта "tests\fixtures" как текущий

Сценарий: При указании ключа фильтрации элементов фич выполняется только определенный сценарий
	Тогда проверка поведения фичи "ПадающиеСценарии" с передачей параметра '-name "Второй неверный сценарий дубль"' закончилась с кодом возврата 2
	И в лог-файле запуска продукта есть строка "ЯЗапускаюПадающийШагСПараметром-Первый падающий шаг из дубля второго сценария"
	И в лог-файле запуска продукта есть строка "Второй неверный сценарий"
	И в лог-файле запуска продукта отсутствует строка "Первый неверный сценарий"
	И в лог-файле запуска продукта отсутствует строка "Первый падающий шаг из первого сценария"
	И в лог-файле запуска продукта есть строка "3 Сценарий ( 0 Пройден, 0 Не реализован, 1 Сломался, 2 Не выполнялся )"
	И в лог-файле запуска продукта есть строка "6 Шаг ( 0 Пройден, 0 Не реализован, 1 Сломался, 5 Не выполнялся )"

Сценарий: При указании ключа фильтрации элементов фич выполняется только несколько сценариев
	Тогда проверка поведения фичи "ПадающиеСценарии" с передачей параметра '-name "Второй неверный сценарий"' закончилась с кодом возврата 2
	И в лог-файле запуска продукта есть строка "ЯЗапускаюПадающийШагСПараметром-Первый падающий шаг из второго сценария"
	И в лог-файле запуска продукта есть строка "ЯЗапускаюПадающийШагСПараметром-Первый падающий шаг из дубля второго сценария"
	И в лог-файле запуска продукта есть строка "Второй неверный сценарий"
	И в лог-файле запуска продукта есть строка "Второй неверный сценарий дубль"
	И в лог-файле запуска продукта отсутствует строка "Первый неверный сценарий"
	И в лог-файле запуска продукта отсутствует строка "Первый падающий шаг из первого сценария"
	И в лог-файле запуска продукта есть строка "3 Сценарий ( 0 Пройден, 0 Не реализован, 2 Сломался, 1 Не выполнялся )"
	И в лог-файле запуска продукта есть строка "6 Шаг ( 0 Пройден, 0 Не реализован, 2 Сломался, 4 Не выполнялся )"
