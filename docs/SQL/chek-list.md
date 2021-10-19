## Настройки MS SQL

[Источник](https://t.me/OneC_Expert/25885)

Настоятельная рекомендация обновить MS SQL Server c 2014 на 2016

https://its.1c.ru/db/metod8dev/content/5946/hdoc
https://its.1c.ru/db/metod8dev/content/5904/hdoc


В вашем случае проблема с флагами трассировки которые влияют на производительность, но у вас они не работают:

4199
Кумулятивный флаг, включающий применение исправлений ошибок и изменений в поведении оптмизитора запросов, включенных в состав пакетов обновлений. По умолчанию эти изменения включены в следующие версии СУБД, а после установки обновлений для  выпущенных ранее - выключены, если флаг 4199 не используется. 

Флаг может быть применен к версиям Microsoft SQL Server 2005 Service Pack 3 и выше. В версии 2016 изменения могут быть применены автоматически без необходимости включения флага в зависимости от режима совместимости базы данных (COMPATIBILITY_LEVEL), более подробно о назначении и применении флага можно прочитать в статье службы поддержки https://support.microsoft.com/en-us/help/974006/sql-server-query-optimizer-hotfix-trace-flag-4199-servicing-model.

Описание на официальной странице: https://docs.microsoft.com/ru-ru/sql/t-sql/database-console-commands/dbcc-traceon-trace-flags-transact-sql

8048
Флаг преобразует глобальные объекты памяти, где хранится в том числе информация о статистике, в секционированные и тем самым позволяет избежать ожиданий на их блокировках (вид ожиданий CMEMTHREAD) при частых компиляциях и перекомпиляциях планов запросов в многопроцессорных системах. Подробнее о флаге можно прочитать в статье службы поддержки https://support.microsoft.com/en-us/help/3074425/fix-cmemthread-waits-occur-when-you-execute-many-ad-hoc-queries-in-sql.

Флаг применим к версиям Microsoft SQL Server 2008 и выше. Начиная с версии Microsoft SQL Server 2014 Service Pack 2 и Microsoft SQL Server 2016, поведение является стандартными.

Описание на официальной странице: https://docs.microsoft.com/ru-ru/sql/t-sql/database-console-commands/dbcc-traceon-trace-flags-transact-sql


* Настройки SQL сервера: Разное -> Оптимизировать для нерегламентированной рабочей нагрузки (Optimize for Ad hoc Workloads) установить в истину. ( dbcc freeproccache - очистка кеша плана запросов )
* Просмотр ошибок 

``` sql 

use master

sp_configure 'show advanced options' , 1
GO
RECONFIGURE
GO
sp_configure 'blocked process threshold' , 5 
GO
RECONFIGURE
GO

```