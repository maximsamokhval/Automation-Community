use [Database Name];
set nocount on

DECLARE @FinalHour int --заканчиваем обработку в 9 утра
  

SET @finalHour = 21;

if OBJECT_ID('sfp_IndexesMainentance') is null 
 create table sfp_IndexesMainentance (
  tablename varchar(256)
  ,indexName varchar(512)
  ,Operation varchar(256)
  ,RunDate datetime
  ,StartDate datetime
  ,FinishDate datetime 
 )
   


DECLARE
       @TableName nvarchar(128)
       ,@IndexName nvarchar(256)
       ,@Operation nvarchar(128)
       ,@SizeMB decimal(10, 3)
       ,@RunDate datetime
       ,@StartDate datetime
       ,@FinishDate datetime
       ,@sql nvarchar(500)
       ,@FinalDate datetime;
    

SET @FinalDate = cast( convert(nvarchar, getdate(), 112) as datetime) -- получим начало дня
IF datepart( hour, GETDATE()) > @FinalHour -- перенесем на следующие сутки (например, отсечка на 5 часов, а сейчас 23. 23 > 5, при этом нам надо, чтобы перестроение завершилось не сейчас, а на следующий календарный день)
        SET @FinalDate =   DATEADD(day, 1, @FinalDate )       
        
SET @FinalDate =  DATEADD(hour, @FinalHour, @FinalDate ) --установим дату, когда нужно прекратить выполнение скрипта  

SET @RunDate = GetDate()

WHILE 1=1 
BEGIN
 
 with 
 locked (obj_id) as (
 select resource_associated_entity_id
    from sys.dm_tran_locks with (nolock)     
  where resource_type = 'OBJECT'
   and resource_subtype = 'UPDSTATS'   ),
  
 stat (obj, obj_id, ndx, [mod]) as (
   select top 1
    o.name as obj,
    o.object_id as obj_id,
    a.name ndx,
    a.rowmodctr as mod
   from sys.sysindexes a
    inner loop join sys.indexes b --явно loop, т.к. иногда сваливается в крайне медленный hash join
     on a.indid = b.index_id
      and a.id = b.object_id
      and b.name is not null
      and a.id > 1
                   
    inner loop join sys.objects o
    on a.id = o.object_id
    and o.type = 'U' 
    
   where o.object_id not in (
    select obj_id from locked 
  )  
 order by a.rowmodctr desc
    ) ,
 

  raw_data  (t_name, i_name, id )  as
   (select top 3
    o.name t_name,     
    s.name i_name,
    ROW_NUMBER() over (order by stat.mod desc)
   from sys.stats s
    inner loop join sys.objects o
    on s.object_id = o.object_id
     and o.type = 'U'
    left loop join stat
    on s.object_id = stat.obj_id
     and s.name = stat.ndx
   where 
    stat.mod > 100
   order by    
    stat.mod desc)

  select top 1 
    @sql = 'UPDATE STATISTICS ['+t_name+'] (['+ i_name+ ']) WITH FULLSCAN',
   @TableName = t_name, 
   @IndexName = i_name
  from raw_data 
  order by id desc
 
      IF @sql is null or @sql = ''
             BREAK;
  

       IF GETDATE() > @FinalDate 
             BREAK;


       SET @StartDate = GetDate()
       
    begin try
   EXEC sp_executesql @sql
   print @sql

   SET @Operation = 'UPDATE STATISTICS'

        SET @FinishDate = GetDate()

     
     INSERT INTO sfp_IndexesMainentance
      (TableName
      ,IndexName
      ,Operation
      ,RunDate
      ,StartDate
      ,FinishDate)
     VALUES
     (@TableName
      ,@IndexName
      ,@Operation
      ,@RunDate
      ,@StartDate
      ,@FinishDate)
     

  end try
  begin catch
   print Error_message()
  end catch
             
END
