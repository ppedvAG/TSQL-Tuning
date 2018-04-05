

--Tabelle erstellen
use demodb
go
drop table t1

create table T1(
		id int identity not null primary key,
		x decimal(8,2) not null default 0,
		spalten char(100) not null default '#'
		)
go
--select * from t1
--select abs(checksum(NEWID()))*0.01%20000
insert T1(x)
	select 	0.01 *ABS(checksum(newid()) %20000) from tuning..Numbers
		where number<= 20000
		
select NEWID()


-- select CHECKSUM(200.09)
	-- select checksum(*) from Northwind..Customers


--select * from t1
--Errechnen der laufenden Summe





select   T1.id, SUM(t2.x) as rt from T1 
	inner join T1 as t2 on T2.id <= t1.id
	group by T1.id
	
-- Alternative
select T1.id, (select SUM (t2.x) from T1 as t2 where t2.id <= T1.id) as rt
from t1

--Cursor
-- errechnete Werte in eine temp Tabelle wegschreiben
-- fast forward zum schnellen durchlauf

--Temp Tabelle #t
create table #t(id int not null primary key, s decimal (16,2) not null)

--Variablen mit Spalten der T1 und Spalte @s für Summen
declare @id int, @x decimal(8,2), @s decimal (16,2)
set @s= 0

--Cursor deklarieren
declare #c cursor fast_forward for
	select id, x from t1 order by id
	
--Cursor öffnen
open #c
	-- solange durchlaufen und füllen  bis Ende
	while (1=1)
		begin
		fetch next from #c into @id, @x
		if (@@FETCH_STATUS != 0) break 
		set @s=@s+@x
		
		if @@TRANCOUNT = 0		
			begin tran
			insert #t values (@id,@s)
		
		if (@id %1000) = 0
			commit
	end	
if @@trancount >0
	commit
	close #c
	deallocate #c
	
select * from #t order by id

drop table #t


-- Cursor dann ok, wenn keine mengenbasierende Lösung 


