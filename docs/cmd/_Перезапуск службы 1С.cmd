rem https://sysadmin-note.ru/article/avtomaticheskij-perezapusk-sluzhby-agenta-servera-1s-skript-raspisanie/

@echo off

set logfile="C:\!Distr\script\stopstartlog.txt"
echo %date% %time% >>%logfile%

net stop "1C:Enterprise 8.3 Server Agent (1640)" >>%logfile%

timeout /t 15 /nobreak
echo %date% %time% >>%logfile%

net start "1C:Enterprise 8.3 Server Agent (1640)" >>%logfile%

ping -n 301 localhost>Nul
SetLocal EnableExtensions

Set ProcessName=1C:Enterprise 8.3 Server Agent (1640)

TaskList /FI "ImageName EQ %ProcessName%" | Find /I "%ProcessName%"
If %ErrorLevel% NEQ 0 net start "1C:Enterprise 8.3 Server Agent (1640)"

exit