SELECT 
	req.session_id,
	DB_NAME(req.database_id) as db,
	USER_NAME(req.user_id) as usr,
	ses.program_name as prog, 
	SUBSTRING(qt.TEXT, (req.statement_start_offset/2)+1,
	((CASE req.statement_end_offset
	WHEN -1THEN DATALENGTH(qt.TEXT)
	ELSE req.statement_end_offset
	END - req.statement_start_offset)/2)+1) as text,
	req.total_elapsed_time,
	req.wait_type, req.wait_time, req.wait_resource
	,qp.query_plan 
from sys.dm_exec_requests as req  with(nolock)
CROSS APPLY sys.dm_exec_sql_text(req.sql_handle) qt
OUTER APPLY sys.dm_exec_query_plan (req.plan_handle) qp
INNER JOIN sys.dm_exec_sessions as ses with(nolock)
ON req.session_id = ses.session_id
where req.session_id <> @@SPID

--kill 89 WITH STATUSONLY
--sp_who2
--select * from sys.sysprocesses where spid=110
--select * from sys.dm_os_schedulers where scheduler_id < 255
--select * from sys.dm_exec_sessions

--ѕрогресс выполнени€ некоторых команды, но только если SET STATISTICS PROFILE ON 
--https://dba.stackexchange.com/questions/139191/sql-server-how-to-track-progress-of-create-index-command
--SELECT percent_complete, estimated_completion_time, reads, writes, logical_reads, * FROM sys.dm_exec_requests AS r WHERE r.session_id = 150

-- онтроль размера хранилища версий:
--SELECT * FROM sys.dm_os_performance_counters dopc WHERE dopc.counter_name = 'Version Store Size (KB)';