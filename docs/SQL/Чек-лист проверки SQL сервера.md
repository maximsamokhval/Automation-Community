## Анализ производительности SQL севера

> По материалам видео [Быстрый анализ производительности SQL Server за 1,5 часа](https://youtu.be/qkBSZkKeC1g)

- [Анализ производительности SQL севера](#анализ-производительности-sql-севера)
- [Проверка статистики ожиданий](#проверка-статистики-ожиданий)
  - [Рекомендации](#рекомендации)
    - [Несколько ситуаций, при которых не стоит отключать распараллеливание:](#несколько-ситуаций-при-которых-не-стоит-отключать-распараллеливание)
  - [Статьи по ожиданиям](#статьи-по-ожиданиям)
- [Проверка запросов с высокими издержками на ввод-вывод](#проверка-запросов-с-высокими-издержками-на-ввод-вывод)
    - [Рекомендации](#рекомендации-1)
  - [Статьи по компрессии](#статьи-по-компрессии)
  - [Запросы](#запросы)
    - [Percent of Scan Operations on the Object](#percent-of-scan-operations-on-the-object)
- [Использование Data Collection](#использование-data-collection)
  - [Включение Data Collection](#включение-data-collection)
    - [Рекомендации](#рекомендации-2)
- [SARG](#sarg)
  - [Оптимизация запросов в TOP CPU](#оптимизация-запросов-в-top-cpu)
    - [Рекомендации](#рекомендации-3)
  - [Статьи по оптимизации](#статьи-по-оптимизации)
- [Индексы](#индексы)
  - [Рекомендации. Кластеризованный индекс](#рекомендации-кластеризованный-индекс)
  - [Рекомендации. INCLUDE](#рекомендации-include)
- [Файловая система](#файловая-система)
  - [Ссылки](#ссылки)


## Проверка статистики ожиданий

 - [ ] Выполнить скрипт проверяющий ожидания, основанный на статистических данных

[Tell me where it hurts](https://www.sqlskills.com/blogs/paul/wait-statistics-or-please-tell-me-where-it-hurts/)

<details>
  <summary>Скрипт "Tell me where it hurts"</summary>

``` sql 
-- Last updated October 1, 2021
WITH [Waits] AS
    (SELECT
        [wait_type],
        [wait_time_ms] / 1000.0 AS [WaitS],
        ([wait_time_ms] - [signal_wait_time_ms]) / 1000.0 AS [ResourceS],
        [signal_wait_time_ms] / 1000.0 AS [SignalS],
        [waiting_tasks_count] AS [WaitCount],
        100.0 * [wait_time_ms] / SUM ([wait_time_ms]) OVER() AS [Percentage],
        ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [RowNum]
    FROM sys.dm_os_wait_stats
    WHERE [wait_type] NOT IN (
        -- These wait types are almost 100% never a problem and so they are
        -- filtered out to avoid them skewing the results. Click on the URL
        -- for more information.
        N'BROKER_EVENTHANDLER', -- https://www.sqlskills.com/help/waits/BROKER_EVENTHANDLER
        N'BROKER_RECEIVE_WAITFOR', -- https://www.sqlskills.com/help/waits/BROKER_RECEIVE_WAITFOR
        N'BROKER_TASK_STOP', -- https://www.sqlskills.com/help/waits/BROKER_TASK_STOP
        N'BROKER_TO_FLUSH', -- https://www.sqlskills.com/help/waits/BROKER_TO_FLUSH
        N'BROKER_TRANSMITTER', -- https://www.sqlskills.com/help/waits/BROKER_TRANSMITTER
        N'CHECKPOINT_QUEUE', -- https://www.sqlskills.com/help/waits/CHECKPOINT_QUEUE
        N'CHKPT', -- https://www.sqlskills.com/help/waits/CHKPT
        N'CLR_AUTO_EVENT', -- https://www.sqlskills.com/help/waits/CLR_AUTO_EVENT
        N'CLR_MANUAL_EVENT', -- https://www.sqlskills.com/help/waits/CLR_MANUAL_EVENT
        N'CLR_SEMAPHORE', -- https://www.sqlskills.com/help/waits/CLR_SEMAPHORE
 
        -- Maybe comment this out if you have parallelism issues
        N'CXCONSUMER', -- https://www.sqlskills.com/help/waits/CXCONSUMER
 
        -- Maybe comment these four out if you have mirroring issues
        N'DBMIRROR_DBM_EVENT', -- https://www.sqlskills.com/help/waits/DBMIRROR_DBM_EVENT
        N'DBMIRROR_EVENTS_QUEUE', -- https://www.sqlskills.com/help/waits/DBMIRROR_EVENTS_QUEUE
        N'DBMIRROR_WORKER_QUEUE', -- https://www.sqlskills.com/help/waits/DBMIRROR_WORKER_QUEUE
        N'DBMIRRORING_CMD', -- https://www.sqlskills.com/help/waits/DBMIRRORING_CMD
        N'DIRTY_PAGE_POLL', -- https://www.sqlskills.com/help/waits/DIRTY_PAGE_POLL
        N'DISPATCHER_QUEUE_SEMAPHORE', -- https://www.sqlskills.com/help/waits/DISPATCHER_QUEUE_SEMAPHORE
        N'EXECSYNC', -- https://www.sqlskills.com/help/waits/EXECSYNC
        N'FSAGENT', -- https://www.sqlskills.com/help/waits/FSAGENT
        N'FT_IFTS_SCHEDULER_IDLE_WAIT', -- https://www.sqlskills.com/help/waits/FT_IFTS_SCHEDULER_IDLE_WAIT
        N'FT_IFTSHC_MUTEX', -- https://www.sqlskills.com/help/waits/FT_IFTSHC_MUTEX
  
       -- Maybe comment these six out if you have AG issues
        N'HADR_CLUSAPI_CALL', -- https://www.sqlskills.com/help/waits/HADR_CLUSAPI_CALL
        N'HADR_FILESTREAM_IOMGR_IOCOMPLETION', -- https://www.sqlskills.com/help/waits/HADR_FILESTREAM_IOMGR_IOCOMPLETION
        N'HADR_LOGCAPTURE_WAIT', -- https://www.sqlskills.com/help/waits/HADR_LOGCAPTURE_WAIT
        N'HADR_NOTIFICATION_DEQUEUE', -- https://www.sqlskills.com/help/waits/HADR_NOTIFICATION_DEQUEUE
        N'HADR_TIMER_TASK', -- https://www.sqlskills.com/help/waits/HADR_TIMER_TASK
        N'HADR_WORK_QUEUE', -- https://www.sqlskills.com/help/waits/HADR_WORK_QUEUE
 
        N'KSOURCE_WAKEUP', -- https://www.sqlskills.com/help/waits/KSOURCE_WAKEUP
        N'LAZYWRITER_SLEEP', -- https://www.sqlskills.com/help/waits/LAZYWRITER_SLEEP
        N'LOGMGR_QUEUE', -- https://www.sqlskills.com/help/waits/LOGMGR_QUEUE
        N'MEMORY_ALLOCATION_EXT', -- https://www.sqlskills.com/help/waits/MEMORY_ALLOCATION_EXT
        N'ONDEMAND_TASK_QUEUE', -- https://www.sqlskills.com/help/waits/ONDEMAND_TASK_QUEUE
        N'PARALLEL_REDO_DRAIN_WORKER', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_DRAIN_WORKER
        N'PARALLEL_REDO_LOG_CACHE', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_LOG_CACHE
        N'PARALLEL_REDO_TRAN_LIST', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_TRAN_LIST
        N'PARALLEL_REDO_WORKER_SYNC', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_WORKER_SYNC
        N'PARALLEL_REDO_WORKER_WAIT_WORK', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_WORKER_WAIT_WORK
        N'PREEMPTIVE_OS_FLUSHFILEBUFFERS', -- https://www.sqlskills.com/help/waits/PREEMPTIVE_OS_FLUSHFILEBUFFERS
        N'PREEMPTIVE_XE_GETTARGETSTATE', -- https://www.sqlskills.com/help/waits/PREEMPTIVE_XE_GETTARGETSTATE
        N'PVS_PREALLOCATE', -- https://www.sqlskills.com/help/waits/PVS_PREALLOCATE
        N'PWAIT_ALL_COMPONENTS_INITIALIZED', -- https://www.sqlskills.com/help/waits/PWAIT_ALL_COMPONENTS_INITIALIZED
        N'PWAIT_DIRECTLOGCONSUMER_GETNEXT', -- https://www.sqlskills.com/help/waits/PWAIT_DIRECTLOGCONSUMER_GETNEXT
        N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP', -- https://www.sqlskills.com/help/waits/QDS_PERSIST_TASK_MAIN_LOOP_SLEEP
        N'QDS_ASYNC_QUEUE', -- https://www.sqlskills.com/help/waits/QDS_ASYNC_QUEUE
        N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP',
            -- https://www.sqlskills.com/help/waits/QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP
        N'QDS_SHUTDOWN_QUEUE', -- https://www.sqlskills.com/help/waits/QDS_SHUTDOWN_QUEUE
        N'REDO_THREAD_PENDING_WORK', -- https://www.sqlskills.com/help/waits/REDO_THREAD_PENDING_WORK
        N'REQUEST_FOR_DEADLOCK_SEARCH', -- https://www.sqlskills.com/help/waits/REQUEST_FOR_DEADLOCK_SEARCH
        N'RESOURCE_QUEUE', -- https://www.sqlskills.com/help/waits/RESOURCE_QUEUE
        N'SERVER_IDLE_CHECK', -- https://www.sqlskills.com/help/waits/SERVER_IDLE_CHECK
        N'SLEEP_BPOOL_FLUSH', -- https://www.sqlskills.com/help/waits/SLEEP_BPOOL_FLUSH
        N'SLEEP_DBSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_DBSTARTUP
        N'SLEEP_DCOMSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_DCOMSTARTUP
        N'SLEEP_MASTERDBREADY', -- https://www.sqlskills.com/help/waits/SLEEP_MASTERDBREADY
        N'SLEEP_MASTERMDREADY', -- https://www.sqlskills.com/help/waits/SLEEP_MASTERMDREADY
        N'SLEEP_MASTERUPGRADED', -- https://www.sqlskills.com/help/waits/SLEEP_MASTERUPGRADED
        N'SLEEP_MSDBSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_MSDBSTARTUP
        N'SLEEP_SYSTEMTASK', -- https://www.sqlskills.com/help/waits/SLEEP_SYSTEMTASK
        N'SLEEP_TASK', -- https://www.sqlskills.com/help/waits/SLEEP_TASK
        N'SLEEP_TEMPDBSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_TEMPDBSTARTUP
        N'SNI_HTTP_ACCEPT', -- https://www.sqlskills.com/help/waits/SNI_HTTP_ACCEPT
        N'SOS_WORK_DISPATCHER', -- https://www.sqlskills.com/help/waits/SOS_WORK_DISPATCHER
        N'SP_SERVER_DIAGNOSTICS_SLEEP', -- https://www.sqlskills.com/help/waits/SP_SERVER_DIAGNOSTICS_SLEEP
        N'SQLTRACE_BUFFER_FLUSH', -- https://www.sqlskills.com/help/waits/SQLTRACE_BUFFER_FLUSH
        N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP', -- https://www.sqlskills.com/help/waits/SQLTRACE_INCREMENTAL_FLUSH_SLEEP
        N'SQLTRACE_WAIT_ENTRIES', -- https://www.sqlskills.com/help/waits/SQLTRACE_WAIT_ENTRIES
        N'VDI_CLIENT_OTHER', -- https://www.sqlskills.com/help/waits/VDI_CLIENT_OTHER
        N'WAIT_FOR_RESULTS', -- https://www.sqlskills.com/help/waits/WAIT_FOR_RESULTS
        N'WAITFOR', -- https://www.sqlskills.com/help/waits/WAITFOR
        N'WAITFOR_TASKSHUTDOWN', -- https://www.sqlskills.com/help/waits/WAITFOR_TASKSHUTDOWN
        N'WAIT_XTP_RECOVERY', -- https://www.sqlskills.com/help/waits/WAIT_XTP_RECOVERY
        N'WAIT_XTP_HOST_WAIT', -- https://www.sqlskills.com/help/waits/WAIT_XTP_HOST_WAIT
        N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG', -- https://www.sqlskills.com/help/waits/WAIT_XTP_OFFLINE_CKPT_NEW_LOG
        N'WAIT_XTP_CKPT_CLOSE', -- https://www.sqlskills.com/help/waits/WAIT_XTP_CKPT_CLOSE
        N'XE_DISPATCHER_JOIN', -- https://www.sqlskills.com/help/waits/XE_DISPATCHER_JOIN
        N'XE_DISPATCHER_WAIT', -- https://www.sqlskills.com/help/waits/XE_DISPATCHER_WAIT
        N'XE_TIMER_EVENT' -- https://www.sqlskills.com/help/waits/XE_TIMER_EVENT
        )
    AND [waiting_tasks_count] > 0
    )
SELECT
    MAX ([W1].[wait_type]) AS [WaitType],
    CAST (MAX ([W1].[WaitS]) AS DECIMAL (16,2)) AS [Wait_S],
    CAST (MAX ([W1].[ResourceS]) AS DECIMAL (16,2)) AS [Resource_S],
    CAST (MAX ([W1].[SignalS]) AS DECIMAL (16,2)) AS [Signal_S],
    MAX ([W1].[WaitCount]) AS [WaitCount],
    CAST (MAX ([W1].[Percentage]) AS DECIMAL (5,2)) AS [Percentage],
    CAST ((MAX ([W1].[WaitS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgWait_S],
    CAST ((MAX ([W1].[ResourceS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgRes_S],
    CAST ((MAX ([W1].[SignalS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgSig_S],
    CAST ('https://www.sqlskills.com/help/waits/' + MAX ([W1].[wait_type]) as XML) AS [Help/Info URL]
FROM [Waits] AS [W1]
INNER JOIN [Waits] AS [W2] ON [W2].[RowNum] <= [W1].[RowNum]
GROUP BY [W1].[RowNum]
HAVING SUM ([W2].[Percentage]) - MAX( [W1].[Percentage] ) < 95; -- percentage threshold
GO

```
</details>

### Рекомендации

CXPACKET:

#### Несколько ситуаций, при которых не стоит отключать распараллеливание:

- Описанный в документации случай, когда один запрос при распараллеливании замедляет всех — не самый распространенный паттерн. Чаще неоптимальный запрос выполняется медленно в один поток, хотя мог бы выполняться гораздо быстрее в несколько потоков, при этом несильно загружая процессор.

- Если отключить распараллеливание на уровне сервера, тогда и регламентные операции по умолчанию тоже будут выполняться в один поток. Чтобы этого избежать, нужно указывать настройку распараллеливания (MAXDOP = 0) для регламентного задания дефрагментации/реиндексации, чего многие, к сожалению, не делают.
- Новый механизм реструктуризации работает гораздо быстрее, если включено распараллеливание. Об этом сказано и в документации. Там же предлагается каждый раз перед реструктуризацией включать параллельность, а после обновления — отключать. Но все мы люди, и часто разработчики просто забывают установить параметр в нужное значение. В итоге реструктуризация больших таблиц даже с новым механизмом идет медленно. [Источник на ИТС ](https://its.1c.ru/db/metod8dev/content/5945/hdoc)
- Ожидания CXPACKET зачастую интерпретируются неправильно. Их наличие далеко не всегда говорит о проблемах с распараллеливанием. Если хочется больше узнать об этом, подробности Вы найдете в статье [Troubleshooting the CXPACKET wait type in SQL Server](https://www.sqlshack.com/troubleshooting-the-cxpacket-wait-type-in-sql-server/).

<details>  
  <summary>Установка cost threshold for parallelism</summary>

``` SQL 
  EXEC sys.sp_configure N'show advanced options', N'1' RECONFIGURE WITH OVERRIDE
  GO
  EXEC sys.sp_configure N'cost threshold for parallelism', N'5000'
  GO
  RECONFIGURE WITH OVERRIDE
  GO
  EXEC sys.sp_configure N'show advanced options', N'0' RECONFIGURE WITH OVERRIDE
  GO

```
</details>



- [ ] Оставить настройку Max degree of parallelism = 0, но установить настройку Cost threshold for parallelism = 30.
Такая настройка означает, что MS SQL будет самостоятельно решать, сколько потоков использовать для выполнения одного запроса, но распараллеливание будет включаться, только если стоимость плана запроса будет выше 30.

[Источник gilev.ru "CXPACKET в топе по ожиданиям на MSSSQL"](http://www.gilev.ru/forum/viewtopic.php?f=18&t=1201&sid=a2f93a47336babab8f21cdf92d9c23fe)

- [ ] Сбросить статистику после изменения настроек


``` sql
DBCC SQLPERF (N'sys.dm_os_wait_stats', CLEAR);
GO
```

### Статьи по ожиданиям

 - [Анализируем ожидания с помощью динамического административного представления SQL](https://www.osp.ru/winitpro/2018/02/13054056)
 - [CXPACKET](https://www.sqlskills.com/help/waits/cxpacket/)
 - [DBCC SQLPERF](https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-sqlperf-transact-sql?view=sql-server-ver15)
 - [Troubleshooting the CXPACKET wait type in SQL Server](https://www.sqlshack.com/troubleshooting-the-cxpacket-wait-type-in-sql-server/)
  
## Проверка запросов с высокими издержками на ввод-вывод

``` sql
SELECT TOP 100
    [Average IO] = (total_logical_reads + total_logical_writes) / qs.execution_count
, [Total IO] = (total_logical_reads + total_logical_writes)
, [Execution count] = qs.execution_count
, [Inpidual Query] = SUBSTRING (qt.text,qs.statement_start_offset/2, 
(CASE WHEN qs.statement_end_offset = -1 
THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2 
ELSE qs.statement_end_offset END - qs.statement_start_offset)/2) 
, [Parent Query] = qt.text
, DatabaseName = DB_NAME(qt.dbid)
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
ORDER BY [Average IO] DESC;
```

#### Рекомендации

- [ ] Компрессия 

### Статьи по компрессии 

[Data Compression: Strategy, Capacity Planning and Best Practices](https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008/dd894051(v=sql.100))


### Запросы

#### Percent of Scan Operations on the Object

Поиск запросов, выполняющих сканирование таблиц

``` sql 
SELECT o.name AS [Table_Name], x.name AS [Index_Name],
       i.partition_number AS [Partition],
       i.index_id AS [Index_ID], x.type_desc AS [Index_Type],
       i.range_scan_count * 100.0 /
           (i.range_scan_count + i.leaf_insert_count
            + i.leaf_delete_count + i.leaf_update_count
            + i.leaf_page_merge_count + i.singleton_lookup_count
           ) AS [Percent_Scan]
FROM sys.dm_db_index_operational_stats (db_id(), NULL, NULL, NULL) i
JOIN sys.objects o ON o.object_id = i.object_id
JOIN sys.indexes x ON x.object_id = i.object_id AND x.index_id = i.index_id
WHERE (i.range_scan_count + i.leaf_insert_count
       + i.leaf_delete_count + leaf_update_count
       + i.leaf_page_merge_count + i.singleton_lookup_count) != 0
AND objectproperty(i.object_id,'IsUserTable') = 1
ORDER BY [Percent_Scan] ESC
```

## Использование Data Collection

Анализ на основе DMV

 - Выдают "среднюю температуру по больнице"
 - Включить Data Collection ( проверить в нужные интервалы времени )

``` sql
sys.dm_os_wait_stats, sys.dm_exec_query_stats
```

### Включение Data Collection

[Enable or Disable Data Collection](https://docs.microsoft.com/en-us/sql/relational-databases/data-collection/enable-or-disable-data-collection?view=sql-server-ver15)

[Enabling Data Collector](https://youtu.be/x9citabVt2c)

#### Рекомендации

- [ ] Создать отдельную базу данных
- [ ] Использовать Мастер настройки Data Collection

**Важный отчет** : Server Activity History за 14 дней

## SARG

> SARG = Seekable ARGument, такой аргумент, при подстановке которого в условие WHERE позволяет использовать индекс. Например:

``` sql
WHERE name = 'Joe'
Where 10 < price
Where Total between 10 and 20
```

``` sql
--не работает
where ABS(col) = 1
--работает
where col in (-1, 1)

--не работает
where DATEPART(YEAR, col) =2017
--работает
where col >='20170101' and col <'20180101'

--не работает
where DATEADD(DAY, 7, col) > GETDATE()
--работает
where col > DATEADD(DAY, -7, GETDATE())

--не работает
where ISNULL(col, 1) = 1
--работает
where ((col = 1) OR (col IS NULL))

--не работает
where SUBSTRING(col, 4) = 'ABCD'
--работает
where col Like 'ABCD%'

--не работает
where SUBSTRING(col, 4) = 'ABCD'
--работает
where col Like 'ABCD%'
```

### Оптимизация запросов в TOP CPU

#### Рекомендации

- [ ] Используйте SARG

### Статьи по оптимизации 

> Не серебрянная пуля, но может помочь
  

- [ ] [When To Break Down Complex Queries](https://techcommunity.microsoft.com/t5/datacat/when-to-break-down-complex-queries/ba-p/305154)
- [ ] [SQL Server 2014: TEMPDB Hidden Performance Gem](https://techcommunity.microsoft.com/t5/sql-server-support/sql-server-2014-tempdb-hidden-performance-gem/ba-p/318255)

## Индексы

### Рекомендации. Кластеризованный индекс
- [ ] Все некластеризованные индексы основываются на кластеризованном, неудачный выбор кластеризованного индекса может привести к деградации
- [ ] Ключ на маленьком поле
- [ ] Уникальный
- [ ] Редко модифицируемый
- [ ] Возрастающий
- [ ] Максимум 16 колонок, 900 байт

Эффективен если:

- [ ] Поиск по диапазону ключа
- [ ] <
- [ ] > 
- [ ] BETWEEN
- [ ] ORDER BY по ключу

### Рекомендации. INCLUDE

* [Create indexes with included columns](https://docs.microsoft.com/en-us/sql/relational-databases/indexes/create-indexes-with-included-columns?view=sql-server-ver15)


Указывая опцию INCLUDE мы указываем не ключевые столбцы, они хранятся на конечном уровне сбалансированного дерева индекса.

Цель - избавиться от затратной операции перехода к таблице (Lookup)

- [ ] RID Lookup для таблицы - кучи
- [ ] Key Lookup для таблицы - кластеризованного индекса


## Файловая система

- [ ] Размер кластера NTFS для файлов данных и журналов - 64 Kb (1 Extent)
- [ ] fsutil fsinfo ntfsinfo C:

### Ссылки

  * [improve-sql-server-io-performance](https://blog.waynesheffield.com/wayne/archive/2016/08/improve-sql-server-io-performance/)
  * [KB2949751 - FIX: Access violation occurs when you run CHECKTABLE against the tables with clustered column store index in SQL Server 2014](https://support.microsoft.com/en-us/topic/kb2949751-fix-access-violation-occurs-when-you-run-checktable-against-the-tables-with-clustered-column-store-index-in-sql-server-2014-825d3ade-505c-57b6-2924-0f520686aadc)
  * [Recommendations and Guidelines on configuring disk partitions for SQL Server](https://support.microsoft.com/en-us/topic/recommendations-and-guidelines-on-configuring-disk-partitions-for-sql-server-a25faa94-509f-370b-0975-ee0b26541aa9)
  * [Диспетчер Хранилища Запросов в SQL Server 2016+ (он же Query Store) infostart.ru](https://infostart.ru/1c/articles/1054413/)
  * [MSDN. Рекомендации по хранилищу запросов](https://docs.microsoft.com/ru-ru/sql/relational-databases/performance/best-practice-with-the-query-store?view=sql-server-ver15)





