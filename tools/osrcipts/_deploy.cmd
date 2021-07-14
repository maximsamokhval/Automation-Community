@chcp 65001

SET V8VERSION=8.3.18.1334

SET RACPATH="C:\Program Files\1cv8\%V8VERSION%\bin\rac.exe"
SET DBNAME=<DBNAME>
SET DBPWD=<DBPWD>
SET DBUSER=<DBUSER>
SET LOCKMESSAGE="Уважаемые пользователи. В данный момент проводится плановое обновление базы данных. Приносим свои извинения за оказанные неудобства."
SET UCCODE=<UCCODE>
SET LOCKSTART="2021-07-14T09:50:00"

SET STORAGEPATH=<STORAGEPATH>
SET STORAGEUSER=<STORAGEUSER>
SET STORAGEPWD=<STORAGEPWD>
SET IBCONNECTION="/Slocalhost/DBASE"


rem Установка блокировки сеансов
@call vrunner session lock --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --db-pwd %DBPWD% --nocacheuse --lockstart %LOCKSTART% --lockmessage %LOCKMESSAGE% --uccode %UCCODE%

rem Остановка регламентных заданий
@call vrunner scheduledjobs lock --rac %RACPATH% --db %DBNAME% --db-user %DBUSER%

rem Завершение активных сеансов
@call vrunner session kill --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --nocacheuse --lockstart %LOCKSTART% --lockmessage %LOCKMESSAGE% --uccode %UCCODE%

rem Получение обновлений из хранилища
@call vrunner loadrepo --storage-name %STORAGEPATH% --storage-user %STORAGEUSER% --storage-pwd %STORAGEPWD% --ibconnection %IBCONNECTION% --nocacheuse --db-user %DBUSER% --v8version %V8VERSION%  --uccode %UCCODE%
 
rem Обновление базы данных
@call vrunner updatedb --ibconnection %IBCONNECTION% --db-user %DBUSER% --v8version %V8VERSION% --uccode %UCCODE%

rem Запуск регламентных заданий
@call vrunner scheduledjobs unlock --rac %RACPATH% --db %DBNAME% --db-user %DBUSER%

rem Снятие блокировки сеансов
@call vrunner session unlock --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --nocacheuse --uccode %UCCODE%