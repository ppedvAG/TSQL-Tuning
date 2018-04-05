--Funktionen sind böse!
--Nur Inline Tabellenwertfunktionen sind die Ausnahme

use AdventureWorks2012

--TabWertFkt.
create function dbo.Adressen(@city nvarchar(100))
  returns table as
  return
   select AddressLine1 from Person.Address where City like @city
go

--INLINE TabWertFkt
create function dbo.Adressen1(@city nvarchar(100))
  returns @adr table (AddressLine1 nvarchar(300)) as
begin
   insert @adr(AddressLine1) 
      select AddressLine1 from Person.Address where City like @city
  return
end
go


select * from dbo.Adressen('%')
select * from dbo.Adressen1('%')



---Aufruf --Messen Soll - ISt vergleich
set statistics io on
set statistics time on


select * from dbo.Adressen('%')
select * from dbo.Adressen1('%')

--Planwiederverwendung
dbcc freeproccache
select * from dbo.Adressen('Berlin')
select * from dbo.Adressen1('Berlin')


select * from dbo.Adressen('London')
select * from dbo.Adressen1('London')




select usecounts, cacheobjtype,objtype, [TEXT] from
	sys.dm_exec_cached_plans P
		CROSS APPLY sys.dm_exec_sql_text(plan_handle)
	where cacheobjtype ='Compiled PLan'
		AND [TEXT] not like '%dm_exec_cached_plans%'

		


