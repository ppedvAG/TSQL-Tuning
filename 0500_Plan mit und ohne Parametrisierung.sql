-- 1. Versuch. Ohne Parametrisierung
set nocount on
dbcc freeproccache
dbcc dropcleanbuffers
go
declare @i int
       ,@cmd nvarchar(200)
set @i = 0
while (@i <= 5000)
 begin
   set @cmd = 'declare @x int;
               select @x=checksum_agg(checksum(*))
                 from sys.all_columns
                where object_id=' + cast(@i as nvarchar(30))
   exec (@cmd) 
   set @i = @i + 1
 end
go

select pages_kb+pages_in_use_kb as AdHoc_Kb
      ,entries_count
  from sys.dm_os_memory_cache_counters
 where type = 'CACHESTORE_SQLCP'
go

--Immer ein neuer Plan...siehe Cachestore_SQLCP
--Siehe Arbeitsspeichernutzung Bericht


-- 2. Versuch. Mit Parametrisierung.
set nocount on
dbcc freeproccache
dbcc dropcleanbuffers
go
declare @i int
       ,@x int
       ,@cmd nvarchar(200)
set @i = 0
set @cmd = 'select @x=checksum_agg(checksum(*))
              from sys.all_columns
             where object_id=@i'
while (@i <= 5000)
 begin
   exec sp_executesql @cmd, N'@x int out, @i int', @x=@x, @i=@i
   set @i = @i + 1
 end
go

select pages_kb+pages_in_use_kb as AdHoc_Kb
      ,entries_count
  from sys.dm_os_memory_cache_counters
 where type = 'CACHESTORE_SQLCP'
go
--und Betrachtung des Arbeitsspeicherberichts