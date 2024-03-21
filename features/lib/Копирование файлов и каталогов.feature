# language: ru

Функционал: Копирование файлов и каталогов
    Как Пользователь
    Я хочу иметь возможность быстро и просто копировать файлы в разные каталоги, в т.ч. и предопределенные
    например, РабочийКаталог, ТекущийКаталог или "." или любой ранее заданный СпециальныйКаталог
    Чтобы я мог проще протестировать и автоматизировать больше действий на OneScript

# Инициализация рабочего каталога и создание каталогов
Контекст:
    Дано Я создаю временный каталог и сохраняю его в контекст
    И Я устанавливаю временный каталог как рабочий каталог

    И Я создаю каталог "folder0/folder01" в рабочем каталоге
    И Я создаю каталог "folder011" в подкаталоге "folder0/folder01" рабочего каталога

    Дано Я создаю файл "folder0/file01.txt" в рабочем каталоге

    Дано Я создаю временный каталог и сохраняю его в переменной "СпециальныйКаталог"
    И Я установил подкаталог "folder0" рабочего каталога как текущий каталог
    # И Я восстановил предыдущий каталог
    # Дано я включаю отладку лога с именем "bdd.tests"

Сценарий: Копирование файлов
    Когда Я копирую файл "step_definitions/БезПараметров.os" из каталога "tests/fixtures" проекта в рабочий каталог
    И Я копирую файл "fixtures/test-report.xml" из каталога "tests" проекта в подкаталог "folder0/folder01" рабочего каталога

    Тогда В рабочем каталоге существует файл "БезПараметров.os"
    И В подкаталоге "folder0/folder01" рабочего каталога существует файл "test-report.xml"

Сценарий: Копирование каталогов
    Когда Я копирую каталог "fixtures/step_definitions" из каталога "tests/fixtures" проекта в рабочий каталог
    И Я копирую каталог "fixtures/step_definitions" из каталога "tests" проекта в подкаталог "folder0/folder01" рабочего каталога

    Тогда В рабочем каталоге существует каталог "step_definitions"
    И В подкаталоге "folder0/folder01" рабочего каталога существует каталог "step_definitions"

Сценарий: И Я копирую файл "ПутьФайла" из текущего каталога в подкаталог текущего каталога
    Дано файл "../file01.txt" не существует
    Когда Я копирую файл "file01.txt" в каталог ".."

    Тогда файл "../file01.txt" существует
    Тогда файл "РабочийКаталог/file01.txt" существует
    Тогда В рабочем каталоге существует файл "file01.txt"

Сценарий: И Я копирую файл "ПутьФайла" из текущего каталога в рабочий каталог через спец.переменную "РабочийКаталог"
    Когда Я копирую файл "file01.txt" в каталог "РабочийКаталог"
    Тогда В рабочем каталоге существует файл "file01.txt"

Сценарий: И Я копирую файл "ПутьФайла" в рабочий каталог через спец.переменную "РабочийКаталог"
    Когда Я копирую файл "РабочийКаталог/folder0/file01.txt" в каталог "РабочийКаталог"
    Тогда В рабочем каталоге существует файл "file01.txt"

Сценарий: И Я копирую файл "ПутьФайла" из проекта в рабочий каталог через спец.переменные "КаталогПроекта" и "РабочийКаталог"
    Когда Я копирую файл "КаталогПроекта/tests/fixtures/step_definitions/БезПараметров.os" в каталог "РабочийКаталог"
    Тогда В рабочем каталоге существует файл "БезПараметров.os"

Сценарий: И Я копирую файл "ПутьФайла" из проекта в рабочий каталог через спец.переменные "КаталогПроекта" и "СпециальныйКаталог"
    Когда Я копирую файл "КаталогПроекта/tests/fixtures/step_definitions/БезПараметров.os" в каталог "СпециальныйКаталог"
    Тогда файл "СпециальныйКаталог/БезПараметров.os" существует

Сценарий: И Я копирую файл проекта "ПутьФайла" в рабочий каталог через спец.переменные "КаталогПроекта" и "РабочийКаталог"
    И я показываю каталог проекта
    Когда Я копирую файл проекта "tests/fixtures/step_definitions/БезПараметров.os" в каталог "РабочийКаталог"
    Тогда В рабочем каталоге существует файл "БезПараметров.os"

Сценарий: И Я копирую файл проекта "ПутьФайла" в рабочий каталог через спец.переменные "КаталогПроекта" и "СпециальныйКаталог"
    Когда Я копирую файл проекта "tests/fixtures/step_definitions/БезПараметров.os" в каталог "СпециальныйКаталог"
    Тогда файл "СпециальныйКаталог/БезПараметров.os" существует

Сценарий: И Я копирую каталог "ПутьФайла" из текущего каталога в подкаталог текущего каталога
    Дано каталог "folder01" существует
    Дано Я создаю файл "folder01/new-file.txt"
    # Дано я включаю отладку лога с именем "bdd.tests"
    Когда Я копирую каталог "folder01" в каталог ".."

    Тогда каталог "../folder01" существует
    Тогда файл "../folder01/new-file.txt" существует
    Тогда файл "РабочийКаталог/folder01/new-file.txt" существует
    Тогда В рабочем каталоге существует файл "folder01/new-file.txt"

Сценарий: И Я копирую каталог "ПутьФайла" из текущего каталога в рабочий каталог через спец.переменную "РабочийКаталог"
    Дано каталог "РабочийКаталог/folder01" не существует
    Когда Я копирую каталог "folder01" в каталог "РабочийКаталог"
    Тогда В рабочем каталоге существует каталог "folder01"
    Тогда каталог "РабочийКаталог/folder01" существует

Сценарий: И Я копирую каталог "ПутьФайла" в рабочий каталог через спец.переменную "РабочийКаталог"
    Дано каталог "РабочийКаталог/folder01" не существует
    Когда Я копирую каталог "РабочийКаталог/folder0/folder01" в каталог "РабочийКаталог"
    Дано каталог "РабочийКаталог/folder01" существует

Сценарий: И Я копирую каталог "ПутьФайла" из проекта в рабочий каталог через спец.переменные "КаталогПроекта" и "РабочийКаталог"
    Дано каталог "РабочийКаталог/fixtures" не существует
    Когда Я копирую каталог "КаталогПроекта/tests/fixtures" в каталог "РабочийКаталог"
    Дано каталог "РабочийКаталог/fixtures" существует

Сценарий: И Я копирую каталог "ПутьФайла" из проекта в рабочий каталог через спец.переменные "КаталогПроекта" и "СпециальныйКаталог"
    Дано каталог "СпециальныйКаталог/fixtures" не существует
    Когда Я копирую каталог "КаталогПроекта/tests/fixtures" в каталог "СпециальныйКаталог"
    Дано каталог "СпециальныйКаталог/fixtures" существует
    Дано файл "СпециальныйКаталог/fixtures/step_definitions/БезПараметров.os" существует

Сценарий: И Я копирую каталог проекта "ПутьФайла" в рабочий каталог через спец.переменные "КаталогПроекта" и "РабочийКаталог"
    Дано каталог "РабочийКаталог/fixtures" не существует
    И я показываю каталог проекта
    Когда Я копирую каталог проекта "tests/fixtures" в каталог "РабочийКаталог"
    Дано каталог "РабочийКаталог/fixtures" существует

Сценарий: И Я копирую каталог проекта "ПутьФайла" в рабочий каталог через спец.переменные "КаталогПроекта" и "СпециальныйКаталог"
    Дано каталог "СпециальныйКаталог/fixtures" не существует
    Когда Я копирую каталог проекта "tests/fixtures" в каталог "СпециальныйКаталог"
    Дано каталог "СпециальныйКаталог/fixtures" существует
