- [ПОЛУЧЕНИЕ КЭШИРОВАННОГО ПЛАНА ЗАПРОСА С ПОМОЩЬЮ ДИНАМИЧЕСКОЙ ФУНКЦИИ](#получение-кэшированного-плана-запроса-с-помощью-динамической-функции)

# ПОЛУЧЕНИЕ КЭШИРОВАННОГО ПЛАНА ЗАПРОСА С ПОМОЩЬЮ ДИНАМИЧЕСКОЙ ФУНКЦИИ

Перед выполнением запроса СУБД проверяет наличие актуального кэшированного плана запроса. Если такой план запроса существует, тогда СУБД использует его, а не компилирует план запроса заново. Это позволяет сократить время выполнения запроса и именно поэтому, после выполнения очистки процедурного кэша, запросы выполняются дольше (происходит компиляция плана запроса). Таким образом, если мы знаем текст искомого запроса, мы можем получить его план из кэша (если он есть в кэше). Для этого необходимо обратиться к следующим динамическим функциям:

``` sql
SELECT TOP 20
	qs.last_execution_time AS Last_execution_time,
	SUBSTRING(qt.text, 
				(qs.statement_start_offset/2) + 1, 
				((CASE qs.statement_end_offset 
						WHEN -1 THEN DATALENGTH(qt.text) 
						ELSE qs.statement_end_offset 
					END - qs.statement_start_offset)/2) + 1) AS Query_text, 
	qp.query_plan AS Query_plan,
	qs.execution_count AS Execution_count
FROM sys.dm_exec_query_stats AS qs
	CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
	CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE qs.last_execution_time > '2016-08-01 11:30:00.000' /* 1. Date & Time filter */
	and qt.text like '%FROM dbo._AccumRg17539 T1%'	/* 2. SQL query text filter */
	and qt.text not like '%Query Finder%' /* 3. Special condition */
```
В запросе добавлены условия по:

Времени последнего выполнения
Тексту искомого запроса (таких фильтров можно добавить несколько, уточняя результат поиска)
Специальное условие для того чтобы сам запрос поиска не попадал в результат поиска (менять не надо)
Результатом запроса будет таблица с колонками:
  * Last_execution_time (последнее время выполнения), 
  * Query_text (текст SQL-запроса), 
  * Query_plan (План SQL-запроса) 
  * Execution_count (количество выполнений).