
- [Размещение и включение ТЖ](#размещение-и-включение-тж)
  - [Полезные источники](#полезные-источники)
  - [Структура файла:](#структура-файла)
  - [Фильтрация по определенной ИБ](#фильтрация-по-определенной-иб)
  - [Рекомендованный дежурный пример ТЖ](#рекомендованный-дежурный-пример-тж)
    - [Длительные события](#длительные-события)
    - [Расследование ошибок на управляемых блокировках](#расследование-ошибок-на-управляемых-блокировках)
  - [Поиск контекста запроса](#поиск-контекста-запроса)
  - [Инструменты работы с технологическим журналом](#инструменты-работы-с-технологическим-журналом)

# Размещение и включение ТЖ

Для включения и настройки технологического журнала в среде Windows необходимо в папке C:\Program Files (x86)\1cv8\conf создать специальный файл настроек logcfg.xml. 

## Полезные источники

- [logcfg.xml ИТС ](https://its.1c.eu/db/v839doc#bookmark:adm:TI000000393)
- [Технологический журнал 1С:Предприятие. Гилев.РУ](http://www.gilev.ru/techlog/)
- [Описание почти всех событий технологического журнала](https://infostart.ru/1c/articles/1195695/)
- [Анализ логов технологического журнала](https://homyaks1c.blogspot.com/2015/11/blog-post_3.html)
- [Рецепты приготовления технологического журнала](https://infostart.ru/1c/articles/1407627/)
- [Мониторинг проблем производительности серверов под работой предприятия 1С](https://github.com/Polyplastic/1c-parsing-tech-log)
- [Методика выявления длительной транзакции, которая привела к значительному расходу tempdb](https://its.1c.ru/db/metod8dev/content/5900/hdoc)
- Конфигурация для сбора данных из технологического журнала [1c-parsing-tech-log](https://github.com/Polyplastic/1c-parsing-tech-log)
- [YellowViewer](https://github.com/sdf1979/YellowViewer) -  Viewing files of technological logs 1C (WinAPI) 1C technological log files viewer (WinAPI). Works with large files. Minimal memory consumption when indexing data, viewing. Analysis of managed deadlocks, timeouts, waits. Filters by events, period, users, connections, sessions.

Works with large files.
Minimal memory consumption when indexing data, viewing.
Analysis of managed deadlocks, timeouts, waits.
Filters by events, period, users, connections, sessions.
Sorting events by time from different working servers of the 1C cluster.
Displaying the working server in the status bar for the tech. log event.
Visual highlighting of the current event.

## Структура файла:

**log location** - расположение файлов лога, указанная директория должна существовать, и пользователь от имени которого запускается 1С должен иметь право записи в нее.

**history** - время хранения логов в часах, в нашем примере 168 часов равно 7 суткам или неделе.

**event** - таких секций может быть много, соответствуют фиксируемым событиям. В данном случае фиксируются все события.

**property** - определяет попадание в журнал свойств событий. Конструкция property name="all" включает записи в журнал всех свойств событий.

## Фильтрация по определенной ИБ

Настроить logcfg.xml для фильтрации событий по определённой ИБ нужно использовать  «p:processName=»

## Рекомендованный дежурный пример ТЖ
``` xml 
<?xml version="1.0" encoding="UTF-8"?>
<config xmlns="http://v8.1c.ru/v8/tech-log">
  <log location="C:\Program Files (x86)\1cv8\logs" history="168">
    <event>
      <eq property="Name" value="PROC"/>
    </event>
    <event>
      <eq property="Name" value="SCOM"/>
    </event>
    <event>
      <eq property="Name" value="CONN"/>
    </event>
    <event>
      <eq property="Name" value="EXCP"/>
    </event>
    <event>
      <eq property="Name" value="ADMIN"/>
    </event>
    <event>
      <eq property="Name" value="QERR"/>
    </event>
    <property name="all">
    </property>
  </log>
</config>
```


В данном примере фиксируются следующие события:

**PROC** - события, относящиеся к процессу целиком и влияющие на дальнейшую работоспособность процесса. Например, старт, завершение, аварийное завершение и т.п.

**SCOM** - события создания или удаления серверного контекста, обычно связанного с информационной базой.

**CONN** - установка или разрыв клиентского соединения с сервером.

**EXCP** - исключительные ситуации приложений системы 1С:Предприятие, которые штатно не обрабатываются и могут послужить причиной аварийного завершения серверного процесса или подсоединенного к нему клиентского процесса.

**ADMIN** - управляющие воздействия администратора кластера серверов системы 1С:Предприятие.

**QERR** - события, связанные с обнаружением ошибок компиляции запроса или ограничения на уровне записей и полей базы данных.

### Длительные события

Полезным может оказаться технологический журнал, в который будут попадать все длительные события. Настройка такого технологического журнала может выглядеть так.

``` xml 
<?xml version="1.0" encoding="UTF-8"?>
<config xmlns="http://v8.1c.ru/v8/tech-log">
<log location="C:\LOGS\LongEvents" history="28">
  <event>
      <ne property="Name" value=""/>
      <ge property="Durationus" value="20000000"/>
  </event>
   <property name="all"/>
</log>
</config>
```

### Расследование ошибок на управляемых блокировках

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<config xmlns="http://v8.1c.ru/v8/tech-log">
<log location="C:\LOGS\TLOCKS" history="4">
  <event>
      <eq property="Name" value="TLOCK"/>
  </event>
  <event>
      <eq property="Name" value="TTIMEOUT"/>
  </event>
  <event>
      <eq property="Name" value="TDEADLOCK"/>
  </event>
   <property name="all"/>
</log>
</config>
```

## Поиск контекста запроса

Допустим, что с помощью скрипта или SQL Profiler были пролучены тексты SQL запросов, которые выполняются медленно, либо сильно нагружают базу. Сами по себе эти тексты запросов бесполезны, необходимо найти место в конфигурации, откуда они вызываются, и это можно сделать только с помощью ТЖ.

``` xml 
<?xml version="1.0" encoding="UTF-8"?>
<config xmlns="http://v8.1c.ru/v8/tech-log">
  <log location="С:\Query" history="2">
      <event>
        <eq property="Name" value="DBMSSQL"/>
        <like property="Sql" value="%AccumRg105%"/>
      </event>
    <property name="all"/>
  </log>
</config>
```

Здесь очень важно указать как можно более точные фильтры, для того чтобы не собирать лишней информации.

## Инструменты работы с технологическим журналом

- [Технологический журнал и EBK](https://github.com/maxstarkov/techlog-es) - В репозитории собраны различные настройки для работы с технологическим журналом на стеке EBK.
- Конфигурация для сбора данных из технологического журнала [1c-parsing-tech-log](https://github.com/Polyplastic/1c-parsing-tech-log)
- [Помощник чтения технологического журнала 1С:Предприятие 8.x](https://github.com/YPermitin/YY.TechJournalReaderAssistant)
- [Помощник экспорта технологического журнала](https://github.com/YPermitin/YY.TechJournalExportAssistant)
- [Сверхбыстрый журнал регистрации 1C с помощью Yandex Clickhouse](https://github.com/EvilBeaver/CllickHousePlayground) - пример выгрузки журнала регистрации в clikhouse, но по аналогии можно попробовать рассмотреть и выгрузку технологического журнала

