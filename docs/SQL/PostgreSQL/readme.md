- [Настройка postgresql.conf](#настройка-postgresqlconf)


### Ссылки

- [Настройка PostgreSQL 11.5 и 1C: Предприятие 8.3.16 на Windows Server 2008R2](https://infostart.ru/1c/articles/1180438/)
- [infostart. Немного о конфигурировании PostgreSQL](https://infostart.ru/1c/articles/325482/)
- [infostart. Держи данные в тепле, транзакции в холоде, а VACUUM в голоде](https://infostart.ru/1c/articles/1191667/)
- [ИТС. Особенности использования PostgreSQL](https://its.1c.ru/db/metod8dev#browse:13:-1:1981:1987)
- [ИТС. Настройки PostgreSQL для работы с 1С:Предприятием. Часть 2](https://its.1c.ru/db/metod8dev#content:5866:hdoc)
- [ИТС. Настройки PostgreSQL](https://its.1c.ru/db/metod8dev#browse:13:-1:1989:2599:2600:2604)
- [Держи данные в тепле, транзакции в холоде, а VACUUM в голоде](https://is1c.ru/career/blog/derzhi-dannye-v-teple-tranzaktsii-v-kholode-a-vacuum-v-golode/)
- [Работа с PostgreSQL настройка и масштабирование](https://postgresql.leopard.in.ua/) - 
Перед вами справочное пособие по настройке и масштабированию PostgreSQL. В книге исследуются вопросы по настройке производительности PostgreSQL, репликации и кластеризации. Изобилие реальных примеров позволит как начинающим, так и опытным разработчикам быстро разобраться с особенностями масштабирования PostgreSQL для своих приложений.

- [PGTune](https://pgtune.leopard.in.ua/) - PGTune calculate configuration for PostgreSQL based on the maximum performance for a given hardware configuration. It isn't a silver bullet for the optimization settings of PostgreSQL. Many settings depend not only on the hardware configuration, but also on the size of the database, the number of clients and the complexity of queries. An optimal configuration of the database can only be made given all these parameters are taken into account.
- [How to tune PostgreSQL for memory](https://www.enterprisedb.com/postgres-tutorials/how-tune-postgresql-memory)

#### Репозитории
 - [Скрипты бекапа, восстановления, удаления и обслуживания баз 1С PostgreSQL (Windows)](https://github.com/anklav24/PostgreSQL-Scripts)

## Настройка postgresql.conf

**shared_buffers** — Количество памяти, выделенной PgSQL для совместного кеша страниц. Эта память разделяется между всеми процессами PgSQL. Делим доступную ОЗУ на 4. В нашем случае это 4 Gb.


**effective_cache_size** — Оценка размера кэша файловой системы. Считается так: ОЗУ — shared_buffers. В нашем случае это 16Gb — 4Gb = 12Gb. Но рекомендуется указать этот параметр ниже, где-то 8-10Gb.


**max_connections** = 10 # максимальное число клиентских подключений, которые могут подсоединяться к базе данных одновременно.
random_page_cost = 1.5 — 2.0 для RAID, 1.1 — 1.3 для SSD. Стоимость чтения рандомной страницы. Чем меньше seek time дисковой системы тем меньше (но > 1.0) должен быть этот параметр. Излишне большое значение параметра увеличивает склонность PgSQL к выбору планов с сканированием всей таблицы.


**temp_buffers** = 512Mb. Максимальное количество страниц для временных таблиц. То есть это верхний лимит размера временных таблиц в каждой сессии (рекомендуемый размер 1/20 RAM).


**wal_sync_method** = open_datasync.  метод, который используется для принудительной записи данных на диск. open_datasync – запись данных методом open() с параметром O_DSYNC, fdatasync – вызов метода fdatasync() после каждого commit, fsync_writethrough – вызывать fsync() после каждого commit игнорирую паралельные процессы, fsync – вызов fsync() после каждого commit, open_sync – запись данных методом open() с параметром O_SYNC. Наилучший по тесту для Windows считается open_datasync(для Линукс = fdatasync)


**work_mem** — Считается так: ОЗУ / 32..64 — в нашем случае получается 512mb. Лимит памяти для обработки одного запроса. Эта память индивидуальна для каждой сессии. Теоретически, максимально потребная память равна max_connections * work_mem.


**bgwriter_delay** — 20ms. Время сна между циклами записи на диск фонового процесса записи. Данный процесс ответственен за синхронизацию страниц, расположенных в shared_buffers с диском. Слишком большое значение этого параметра приведет к возрастанию нагрузки на  checkpoint процесс и процессы, обслуживающие сессии (backend). Малое значение приведет к полной загрузке одного из ядер.


**synchronous_commit** — off. ОПАСНО! Выключение синхронизации с диском в момент коммита. Создает риск потери последних нескольких транзакций (в течении 0.5-1 секунды), но гарантирует целостность базы данных, в цепочке коммитов гарантированно отсутствуют пропуски. Но значительно увеличивает производительность.


``` 

autovacuum = on
autovacuum_max_workers = Количество равным половине всех ядер сервера СУБД.
autovacuum_vacuum_cost_limit = 1
autovacuum_vacuum_cost_delay = 20ms
autovacuum_vacuum_scale_factor = 0.1 -> 0.01
autovacuum_analyze_scale_factor = 0.2 -> 0.005

```

Пример конфиг с сайта [gilev.ru](http://www.gilev.ru/forum/viewtopic.php?f=18&t=979) 


```

listen_addresses = '*'         # what IP address(es) to listen on;
port = 5432            # (change requires restart)
max_connections = 100         # (change requires restart)
shared_buffers = 512MB         # min 128kB
#temp_buffers = 8MB         
work_mem = 28641kB            
maintenance_work_mem = 2048MB      # min 1MB
shared_preload_libraries = '$libdir/plugins/plugin_debugger.dll'      # (change requires restart)

fsync = on            # turns forced synchronization on or off
synchronous_commit = on      # immediate fsync at commit
wal_sync_method = fsync      # the default is the first option
               
wal_buffers = 16MB         # min 32kB
   
effective_cache_size = 7680MB
log_destination = 'stderr'      # Valid values are combinations of
logging_collector = on      # Enable capturing of stderr and csvlog
log_line_prefix = '%t '         # special values:
               
autovacuum = on         # Enable autovacuum subprocess?  'on'
log_autovacuum_min_duration = -1   # -1 disables, 0 logs all actions and
autovacuum_max_workers = 3      # max number of autovacuum subprocesses
autovacuum_naptime = 1min      # time between autovacuum runs
autovacuum_vacuum_threshold = 50   # min number of row updates before
#autovacuum_analyze_threshold = 50   # min number of row updates before
autovacuum_vacuum_scale_factor = 0.2   # fraction of table size before vacuum
autovacuum_analyze_scale_factor = 0.1   # fraction of table size before analyze
autovacuum_freeze_max_age = 200000000   # maximum XID age before forced vacuum
autovacuum_vacuum_cost_delay = 20ms   # default vacuum cost delay for
autovacuum_vacuum_cost_limit = -1   # default vacuum cost limit for
 datestyle = 'iso, dmy'

lc_messages = 'Russian_Russia'         # locale for system error message
lc_monetary = 'Russian_Russia'         # locale for monetary formatting
lc_numeric = 'Russian_Russia'         # locale for number formatting
lc_time = 'Russian_Russia'            # locale for time formatting


default_text_search_config = 'pg_catalog.russian'
max_locks_per_transaction = 150      # min 10
escape_string_warning = off

```

``` sql

select count(1) from pg_stat_progress_vacuum;

```