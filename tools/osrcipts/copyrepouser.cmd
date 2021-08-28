@chcp 65001
@echo off
rem  Строка подключения к хранилищу, куда копируем (возможно указание как файлового пути, так и пути через http или tcp)
SET DESTINATION_DEPOT="C:/depot/subscriber"

rem  Строка подключения к хранилищу, из которого копируются пользователи (возможно указание как файлового пути, так и пути через http или tcp)
SET SOURCE_DEPOT="C:/depot/source"

rem  Пользователь хранилища, куда копируем.
SET DESTINATION_STORAGE_USER=Администратор
SET DESTINATION_STORAGE_PASSWORD=321

rem  Пользователь хранилища, из которого идет копирование.
SET STORAGE_USER_COPY=Администратор
SET STORAGE_PASSWORD_COPY=123

vrunner copyrepouser %DESTINATION_DEPOT% %SOURCE_DEPOT% --storage-user %DESTINATION_STORAGE_USER% --storage-pwd %DESTINATION_STORAGE_PASSWORD% --storage-user-copy %STORAGE_USER_COPY% --storage-pwd-copy %STORAGE_PASSWORD_COPY% 
