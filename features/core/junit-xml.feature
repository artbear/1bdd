# language: ru

Функционал: Получение отчетов в формате JUnit-xml
	Как Разработчик
	Я Хочу получать отчеты в формате JUnit.xml
    Чтобы проверять поведение на специализированных CI-серверах

Контекст: Использование каталог тестовых фич
	Допустим установил каталог проекта "tests\fixtures" как текущий
	И удалил файл "./test-report.xml"

Сценарий: Получение отчета в формате JUnit-xml для успешного теста

	Тогда  проверка поведения фичи "БезПараметров" с передачей параметра "-junit-out ./test-report.xml" закончилась с кодом возврата 0
	И файл "./test-report.xml" существует
	И в файле "./test-report.xml" есть строка 
	"""
       <testsuites name="1bdd" time="0" tests="1" failures="0" skipped="0">
           <testsuite name="Пустой функционал">
               <properties />
               <testcase classname="Ничего не делаем" name="Ничего не делаем" status="passed" />
           </testsuite>
       </testsuites>
	"""
	# И в файле "./test-report.xml" есть строка "СТРАННОЕ"
	# И файл junit "./test-report.xml" правильного формата
