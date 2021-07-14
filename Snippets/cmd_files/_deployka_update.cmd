chcp 1251
set STORAGEPATH=tcp://88.198.45.131:1942/DCLink/ERP_Dev
set DATABASENAME=ERP
set DATABASE=/S"onec.service.consul\%DATABASENAME%"
set VERSION=8.3.9.1818
set BUILDPATH=d:\Soft\Enterprise

deployka session lock -ras dev-td:2845 -rac "C:\Program Files\1cv8\8.3.10.2466\bin\rac.exe" -db "zup cb fin test" -db-user "Admin" -lockmessage "Плановое обновление" -lockuccode update

deployka session kill -ras dev-td:2845 -rac "C:\Program Files\1cv8\8.3.10.2466\bin\rac.exe" -db "zup cb fin test" -db-user "Admin" -lockmessage "Плановое обновление, 5 мин" -lockuccode update

deployka loadrepo "/IBConnectionString""Srvr=dev-td:2841;Ref='zup cb fin test'""" \\dit-dev1\1C-Storage\8.3\hrm_test_fin -db-user "Admin" -storage-user admin -storage-pwd 777 -uccode update

deployka dbupdate "/IBConnectionString""Srvr=dev-td:2841;Ref='zup cb fin test'""" -db-user "Admin" -allow-warnings -uccode update

deployka session unlock -ras dev-td:2845 -rac "C:\Program Files\1cv8\8.3.10.2466\bin\rac.exe" -db "zup cb fin test" -db-user "Admin"