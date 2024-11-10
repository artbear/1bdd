# language: ru

Функционал: Получение отчетов в формате JUnit-xml
	Как Разработчик
	Я Хочу получать отчеты в формате JUnit.xml
    Чтобы проверять поведение на специализированных CI-серверах

Контекст: Использование каталог тестовых фич
	Допустим установил каталог проекта "tests/fixtures" как текущий
	И удалил файл "./test-report.xml"

Сценарий: Получение отчета в формате JUnit-xml для успешного теста

	Тогда  проверка поведения фичи "БезПараметров" с передачей параметра "-junit-out ./test-report.xml" закончилась с кодом возврата 0
	И файл "./test-report.xml" существует
	И файл "./test-report.xml" содержит
	"""
       <testsuites name="1bdd" time="0" tests="1" failures="0" skipped="0">
           <testsuite name="Пустой функционал">
               <properties/>
               <testcase classname="Ничего не делаем" name="я ничего не делаю" status="passed"/>
               <testcase classname="Ничего не делаем" name="ничего не происходит" status="passed"/>
           </testsuite>
       </testsuites>
	"""

Сценарий: Получение отчета в формате JUnit-xml для падающего теста

	Тогда  проверка поведения фичи "ПадающийШаг" с передачей параметра "-junit-out ./test-report.xml" закончилась с кодом возврата 2
	И файл "./test-report.xml" существует
	И файл "./test-report.xml" содержит
	"""
       <testsuites name="1bdd" time="0" tests="1" failures="1" skipped="0">
           <testsuite name="Выполнение фич">
               <properties/>
               <testcase classname="После ошибочного шага следующие шаги сценария не выполняются" name="я запускаю падающий шаг с параметром &quot;Первый падающий шаг&quot;" status="failure">
                   <failure message="
	"""
	И файл "./test-report.xml" содержит
	"""
       ПадающийШаг.os / Ошибка в строке: 21 / ЯЗапускаюПадающийШагСПараметром-Первый падающий шаг}
	"""
	И файл "./test-report.xml" содержит
	"""
		;	 ВызватьИсключение СтрШаблон(&quot;ЯЗапускаюПадающийШагСПараметром-%1&quot;, ПарамСтрока);&#xD;"/>
	"""

Сценарий: Получение отчета в формате JUnit-xml для нереализованного теста

	Тогда  проверка поведения фичи "НеРеализованныйШаг" с передачей параметра "-junit-out ./test-report.xml" закончилась с кодом возврата 0
	И файл "./test-report.xml" существует
	И файл "./test-report.xml" содержит
	"""
       <testsuites name="1bdd" time="0" tests="1" failures="0" skipped="1">
           <testsuite name="Выполнение фич">
               <properties/>
               <testcase classname="После нереализованного шага следующие шаги сценария не выполняются" name="я запускаю нереализованный шаг" status="skipped"/>
		   </testsuite>
       </testsuites>
	"""
