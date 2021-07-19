@echo off
@chcp 65001

setlocal enabledelayedexpansion

SET V8VERSION=8.3.18.1334
SET IBCONNECTION="/S1c-test/TEST"

SET RACPATH="C:\Program Files\1cv8\%V8VERSION%\bin\rac.exe"
SET RASSERVER=""
SET RASPORT=1545

SET DBNAME=""
SET DBPWD=""
SET DBUSER=""

SET LOCKMESSAGE="Уважаемые пользователи. В данный момент проводится плановое обновление базы данных. Приносим свои извинения за оказанные неудобства."
SET UCCODE=UpdateDB
rem Значение паузы в секундах
SET LOCKSTARTAT=300

SET STORAGEPATH=tcp://127.0.0.1/Dev
SET STORAGEUSER=""
SET STORAGEPWD="20tk20"



rem Остановка регламентных заданий
@call vrunner scheduledjobs lock --ras %RASSERVER%:%RASPORT% --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --db-pwd %DBPWD%

rem Установка блокировки сеансов
@call vrunner session lock --ras %RASSERVER%:%RASPORT% --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --db-pwd %DBPWD% --lockstartat %LOCKSTARTAT% --lockendclear --lockmessage %LOCKMESSAGE% --uccode %UCCODE% --v8version %V8VERSION%

rem Завершаем сеанс только Кофигуратора, чтобы выполнить обновление --filter appid=Designer
@call vrunner session kill --filter appid=Designer --ras %RASSERVER%:%RASPORT%  --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --db-pwd %DBPWD% --lockstartat %LOCKSTARTAT% --lockendclear --lockmessage %LOCKMESSAGE% --uccode %UCCODE% --v8version %V8VERSION%

rem Получение обновлений из хранилища
@call vrunner loadrepo --storage-name %STORAGEPATH% --storage-user %STORAGEUSER% --storage-pwd %STORAGEPWD% --ibconnection %IBCONNECTION% --db-user %DBUSER% --db-pwd %DBPWD% --v8version %V8VERSION% --uccode %UCCODE%

timeout /t %LOCKSTARTAT%

rem Завершение активных сеансов
@call vrunner session kill  --ras %RASSERVER%:%RASPORT%  --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --db-pwd %DBPWD% --uccode %UCCODE% --v8version %V8VERSION%

rem Обновление базы данных
@call vrunner updatedb --ibconnection %IBCONNECTION% --db-user %DBUSER% --db-pwd %DBPWD% --v8version %V8VERSION% --uccode %UCCODE%

rem Запуск регламентных заданий
@call vrunner scheduledjobs unlock --ras %RASSERVER%:%RASPORT% --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --db-pwd %DBPWD%

rem Снятие блокировки сеансов
@call vrunner session unlock --ras %RASSERVER%:%RASPORT% --rac %RACPATH% --db %DBNAME% --db-user %DBUSER% --db-pwd %DBPWD% --uccode %UCCODE%

@rem обновление в режиме Предприятие
call vrunner run --command "ЗапуститьОбновлениеИнформационнойБазы;ЗавершитьРаботуСистемы;" --execute $runnerRoot\epf\ЗакрытьПредприятие.epf %*