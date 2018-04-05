--Pläne im Speicher
select left(p.cacheobjtype + '(' + p.objtype + ')', 35) as cacheobjtype
      ,p.usecounts
      ,cast(p.size_in_bytes/1024.0 as decimal(12,2)) as size_in_kb
      ,cast(qs.total_worker_time*0.001 as decimal(12,2)) as tot_cpu_ms
      ,cast(qs.total_elapsed_time*0.001 as decimal(12,2)) as tot_duration_ms
      ,qs.total_physical_reads
      ,qs.total_logical_writes
      ,qs.total_logical_reads
      ,left(case
              when pa.value=32767 then 'ResourceDb'
              else db_name(cast(pa.value as int))
            end, 40) as db_name
      ,qt.objectid
      ,case
         when qt.objectid is null then null
         else replace(replace(qt.text, char(13), ' '), char(10), ' ')
       end as proc_name
      ,pln.query_plan as query_plan
      ,replace(replace(substring(qt.text, qs.statement_start_offset/2+1,
                case
                  when qs.statement_end_offset = -1 then
                       len(convert(nvarchar(max), qt.text))
                  else qs.statement_end_offset/2
                      - qs.statement_start_offset/2+1
                end), char(13), ' '), char(10), ' ') as stmt_text
  from sys.dm_exec_cached_plans as p
       outer apply sys.dm_exec_plan_attributes(p.plan_handle) as pa
       outer apply sys.dm_exec_query_plan(p.plan_handle) as pln
       inner join sys.dm_exec_query_stats as qs
               on qs.plan_handle = p.plan_handle
       outer apply sys.dm_exec_sql_text(qs.sql_handle) as qt
 where pa.attribute = 'dbid'
 order by tot_cpu_ms desc;

