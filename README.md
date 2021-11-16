- [Репозиторий telegram канала (Сообщество автоматизаторов)](#репозиторий-telegram-канала-сообщество-автоматизаторов)
  - [Библиотеки и утилиты для работы с управляемыми формами](#библиотеки-и-утилиты-для-работы-с-управляемыми-формами)
  - [Демо](#демо)
  - [Полезные репозитории](#полезные-репозитории)
  - [Дизайн](#дизайн)
    - [Настройка конфигуратора](#настройка-конфигуратора)
    - [Шрифты](#шрифты)
    - [Иконки](#иконки)
  - [Интеграции](#интеграции)
  - [Тестирование](#тестирование)
  - [.Net и 1С](#net-и-1с)
  - [SQL](#sql)
    - [SQL links (videos & articles). Блокировки](#sql-links-videos--articles-блокировки)
    - [CXPACKET](#cxpacket)
    - [Флаги трассировки](#флаги-трассировки)
  - [Технологический журнал](#технологический-журнал)
  - [Статьи (оптимизация)](#статьи-оптимизация)
  - [Статьи ( доработки типовых на базе БСП )](#статьи--доработки-типовых-на-базе-бсп-)
  - [Статьи (интеграции)](#статьи-интеграции)
  - [Статьи (настройки)](#статьи-настройки)
    - [Sonar Qube](#sonar-qube)
  - [Статьи (общее)](#статьи-общее)
  - [Паттерны](#паттерны)
  - [FAQ](#faq)

# Репозиторий telegram канала (Сообщество автоматизаторов)
[![Telegram](https://img.shields.io/badge/chat-Telegram-blue.svg?style=plastic)](https://t.me/joinchat/Rz30Yy9vXMYzNDkyy)
![forks](https://img.shields.io/github/forks/maximsamokhval/Automation-Community?style=plastic)
![stars](https://img.shields.io/github/stars/maximsamokhval/Automation-Community?style=plastic)
![last commit](https://img.shields.io/github/last-commit/maximsamokhval/Automation-Community?style=plastic)
## Библиотеки и утилиты для работы с управляемыми формами

* [Консоль запросов 9000](https://github.com/hal9000cc/RequestConsole9000)
* [Консоль заданий УФ](https://github.com/kuzyara/JobsConsole2019.epf)
* [Phoenix BSL для 1С](https://github.com/otymko/phoenixbsl/releases) 
* [Консоль кода для 1С 8.3]( https://github.com/salexdv/bsl_console/releases )
* [Редактор  форм]( https://github.com/huxuxuya/1cFormEditor)
* [Обработка генерации кода для программной доработки форм](https://github.com/huxuxuya/FormCodeGenerator )
* [HTTP Connector]( https://github.com/vbondarevsky/Connector)
* [HTTP Status Codes](https://github.com/astrizhachuk/HTTPStatusCodes)
* [Структура хранения таблиц базы данных (УФ)]( https://github.com/alexkmbk/1CDBStorageStructureInfo/releases)
* [HTTP сервисы по OpenAPI спецификациям](http://tf21.ru/public/1257654/)

## Демо
* [Управляемое приложение (Демо)](https://its.1c.ru/db/metod8dev/content/5028/hdoc)


## Полезные репозитории

* [TaskManagerFor1C](https://github.com/wizi4d/TaskManagerFor1C) - Библиотека TaskManagerFor1C предназначена для создания асинхронных и параллельных алгоритмов с гарантированным выполнением в среде 1С Предприятия на базе фоновых заданий.
* [Универсальные инструменты 1С для управляемых форм](https://github.com/cpr1c/tools_ui_1c) - Универсальные инструменты 1С для управляемых форм
* [LogBookReaderWPF](https://github.com/djserega/LogBookReaderWPF) - Приложение "читает" файл журнала регистрации 1С формата SQLite.
* [commitlint](https://commitlint.io/) - Commitlint.io поможет проекту обеспечить красивые и аккуратные сообщения о фиксации без необходимости загрузки или установки. Он разработан с учетом вашего рабочего процесса и не требует никаких изменений в вашей системе.
* [Правила доработки типовых конфигураций 1С для облегчения их дальнейшего обновления](https://tavalik.ru/pravila-razrabotki-chast-1/) - Правила доработки типовых конфигураций 1С для облегчения их дальнейшего обновления 

## Дизайн

### Настройка конфигуратора

- [Приятная глазу цветовая схема 1С 8.х]( https://infostart.ru/1c/articles/122391/ )

```
**Brightness contrast colorschemes**:
Ключевые слова: D24C15
Константы типа "Число": B68900
Константы типа "Строка": 4CA49C
Константы типа "Дата": 859900
Идентификаторы: 258BD3
Операторы: D42F33
Комментарии: 93A1A1
Препроцессор: D53584
Прочее: 899A33  
Фон: FFFBF0
``` 


### Шрифты

- [Шрифт для 1С от devtool1c]( http://devtool1c.ucoz.ru/load/prochie/shrift_hack_1c/2-1-0-23 )
- [Шрифт Jet Brains Mono]( https://www.jetbrains.com/lp/mono/)

### Иконки
 ![icon](/assets/images/link.svg)[Tabler Icons]( https://github.com/tabler/tabler-icons )

## Интеграции 
 - [Внешняя компонента Telegram](https://github.com/Infactum/telegram-native)
 - [Внешняя компонента RabbitMQ Soft Balance]( https://sbpg.atlassian.net/wiki/spaces/1C2RMQ/overview?homepageId=175800496 )
 - [Внешняя компонента PinkRabbitMQ]( https://github.com/BITERP/PinkRabbitMQ#pinkrabbitmq-library )
 - [Внешняя компонента RegEx]( https://github.com/alexkmbk/RegEx1CAddin)

## Тестирование
 
 - [add-tests-for-1C-ERP](https://github.com/Dach-Coin/add-tests-for-1C-ERP) - Примеры сценарных и дымовых тестов на фреймворках V-ADD и xDD для 1C:ERP
 
 
## .Net и 1С

- [YellowYard_NET](https://github.com/YPermitin/YellowYard.NET)

## SQL
- [sql-server-maintenance-solution](https://github.com/olahallengren/sql-server-maintenance-solution)
- [SQL Server First Responder Kit](https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit)
- [SQL Server Tools](https://github.com/YPermitin/SQLServerTools)
- [sp_whoisactive](https://github.com/amachanic/sp_whoisactive/releases)
- [Expensive Key Lookups](https://www.brentozar.com/blitzcache/expensive-key-lookups/)
- [Автоматизация обслуживания SQL Server](http://sqlcom.ru/scripts/meintenance-from-ola-hallengren/)
- [aboutsqlserver](https://aboutsqlserver.com/presentations/)

### SQL links (videos & articles). Блокировки 

- [Что делать, если не хватает штатных индексов 1С (Фрагмент курса 1С Эксперт)](https://youtu.be/DynhFzN9irc)
- [Execution Plan Basics](https://www.red-gate.com/simple-talk/sql/performance/execution-plan-basics/) - What is an execution plan?

- [Ошибки блокировок 1С. Как исправить конфликт блокировок в 1С 8.3. Как определить уровень изоляции блокировок 1С-запросов?](https://www.koderline.ru/expert/sovety-ekspertov-raznoe/article-oshibki-blokirovok-1s-kak-ispravit-konflikt-blokirovok-v-1s-8-3-kak-opredelit-uroven-izolyatsii-blok/)

- [Возможности оптимизации блокировок 1С](http://cascade-group.com.ua/vozmozhnosti-optimizacii-blokirovok-v-1s/)

- [Как посмотреть, какие данные заблокированы в СУБД MS SQL Server](https://infostart.ru/1c/articles/707333/)

### CXPACKET
- [CXPACKET в топе по ожиданиям на MSSSQL](http://www.gilev.ru/forum/viewtopic.php?f=18&t=1201&sid=a2f93a47336babab8f21cdf92d9c23fe)
### Флаги трассировки
 [Описание флагов трассировки](https://github.com/ktaranov/sqlserver-kit/blob/master/SQL%20Server%20Trace%20Flag.md)

## Технологический журнал

* [Про настройку технологического журнала в 1С](/docs/Технологический%20журнал/readme.md)
* [Расследование ошибки в конфигураторе](https://kostyanetsky.ru/notes/designer-error-investigation/)
## Статьи (оптимизация) 
- [Ускоряем полнотекстовый поиск в динамических списках](https://infostart.ru/1c/articles/1267438/)



## Статьи ( доработки типовых на базе БСП )
- [Добавление отчетов в типовые конфигурации 1С](https://infostart.ru/1c/articles/1016791/)
- [Подсистема "Варианты отчетов". Используете ли Вы ее правильно?](https://infostart.ru/1c/articles/1056845/)
- [Типовые методы конфигурации "Зарплата и управление персоналом", которые пригодятся каждому ЗУП программисту и не только](https://infostart.ru/1c/articles/1266796/)
- [Параметры выбора и связи параметров выбора в панели быстрых настроек отчета СКД](https://expert.chistov.pro/public/1185743/)

## Статьи (интеграции)
![icon](/assets/images/link.svg)[Использование AMQP на примере RabbitMQ]( https://kt.team/hr/blog/rabbitmq#rabbit )

## Статьи (настройки)
### Sonar Qube
  - [SonarQube Memory Tuning Guidelines](https://community.sonarsource.com/t/sonarqube-memory-tuning-guidelines/31361) 
  - [SonarQube Requirments](https://docs.sonarqube.org/latest/requirements/requirements/) 
 
## Статьи (общее)
- [Описание почти всех событий технологического журнала](https://infostart.ru/1c/articles/1195695/) 
- [Прокси-сервер для проверки формата комментариев в хранилище конфигураций 1С](https://github.com/EvilBeaver/crserver-filter)

## Паттерны 
- [DesignPatterns](https://github.com/maximsamokhval/DesignPatterns) 

## FAQ

- [Markdown Syntax](https://www.markdownguide.org/basic-syntax/)
- [Стандарты разработки 1С](https://its.1c.ru/db/v8std)


