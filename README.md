# Реализация BDD для OneScript

[![Join the chat at https://gitter.im/artbear/1bdd](https://badges.gitter.im/artbear/1bdd.svg)](https://gitter.im/artbear/1bdd?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)  Здесь вы можете задавать любые вопросы разработчикам и активным участникам

1bdd - консольный фреймворк для реализации BDD для проекта [OneScript](https://github.com/EvilBeaver/OneScript)

Идеи черпаются из проекта [Cucumber](https://cucumber.io)

# Командная строка запуска

```
oscript bdd.os <features-path> [ключи]
oscript bdd.os <команда> <параметры команды> [ключи]

Возможные команды:
	exec
	generate
Возможные ключи:
	-out <путь лог-файла>
	-debug <on|off> - включает режим отладки (полный лог + остаются временные файлы)
	-verbose <on|off> - включается полный лог
```

Для подсказки по конкретной команде наберите
`bdd help <команда>`
