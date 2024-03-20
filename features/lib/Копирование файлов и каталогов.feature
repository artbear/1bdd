# language: ru

Функционал: Копирование файлов и каталогов
    Как Пользователь
    Я хочу иметь возможность быстро и просто копировать файлы в разные каталоги, в т.ч. и предопределенные
    например, РабочийКаталог, ТекущийКаталог или "." или любой ранее заданный СпециальныйКаталог
    Чтобы я мог проще протестировать и автоматизировать больше действий на OneScript

# Инициализация рабочего каталога и создание каталогов
Контекст:
    # Дано я включаю отладку лога с именем "bdd.tests"
    Допустим Я создаю временный каталог и сохраняю его в контекст
    И Я устанавливаю временный каталог как рабочий каталог

    И Я создаю каталог "folder0/folder01" в рабочем каталоге
    И Я создаю каталог "folder011" в подкаталоге "folder0/folder01" рабочего каталога

    Допустим Я создаю файл "folder0/file01.txt" в рабочем каталоге

    Дано Я создаю временный каталог и сохраняю его в переменной "СпециальныйКаталог"

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
