--Statistiken..?? Wofür
--create database querytest
--drop view v1
If (object_id('T1', 'U') is not null)
  drop table T1
go
create table T1
 (
   x int not null
  ,a varchar(20) not null
  ,b int not null
  ,y char(20) null
 )
go
insert T1(x,a,b)
   select number % 1000,number % 3000,number % 5000
     from tuning..Numbers
    where number <= 100000
go
create nonclustered index IxT1_x on T1(x)
go

-- woher weiss er im tats. Ausführungsplan die Anzahl der Ergebniszeilen????
select * from T1 where a='234'
go

select * from T1 where b = '234'

select * from T1 where b = '234' and a='234'




--Anzeige der Statistiken im SSMS



--Anzeige der Statistiken über TSQL
dbcc show_statistics(Tabelle, Statistik)


--Wann werden statistiken aktualisiert?
--100000 Zeilen

-- Änderung von 20.000 Zeilen
update top(20000) T1 set a='###'
-- Keine Aktualisierung
select y from T1 where a='234'

-- Änderung weiterer 499 Zeilen
update top(499) T1 set a='###'
-- Keine Aktualisierung
select y from T1 where a='234'

-- Änderung einer Zeile
update top(1) T1 set a='###'
-- Hier erfolgt die Aktualisierung
select y from T1 where a='234'
go

sp_updatestats
--20% + 500 + Abfrage auf Spalte

100.000 ---20.000---499--1 --Abfrage
20% + 500 + Abfrage



select * from sys.dm_db_index_physical_stats




--Leider kein Hinweis, wann..

select object_name(object_id) as ObjName
      ,name as statistik
      ,stats_date(object_id, stats_id) as AktualisiertAm
  from sys.stats 
 where objectproperty(object_id, 'IsUserTable') = 1
 order by AktualisiertAm
go


--Probleme von Statistiken
--was wärehier die bessere Statistik
select * from T1 where a = '234' and b=123


create statistics s1 on T1(b,a)

--Nicht aktuelle Stats
if (object_id('Produkt', 'U') is not null)
  drop table Produkt
go  
create table Produkt
 (
   Id int identity(1,1) not null
  ,Preis decimal(8,2) not null
  ,LetzteAktualisierung date not null default current_timestamp
  ,Spalten nchar(500) not null default '#'
 ) 
go
alter table Produkt add constraint PK_Produkt
 primary key clustered (Id)
go


insert Produkt(LetzteAktualisierung, Preis)
  select dateadd(day, abs(checksum(newid())) % 3250,'20000101')
        ,0.01*(abs(checksum(newid())) % 20000)
    from tuning..Numbers
   where number <= 500000
go



create nonclustered index ix_Prod on Produkt(LetzteAktualisierung)
go

select * from produkt

insert Produkt(LetzteAktualisierung,Preis) 
  select '20081201', 100 from tuning..Numbers where number <= 100000
go

alter index PK_Produkt on Produkt rebuild
go

dbcc showcontig('produkt')

set statistics io on
set statistics time on

select *
  from Produkt
 where LetzteAktualisierung = '20081201'
go

select * from produkt with (index=0)
where LetzteAktualisierung= '20081201'

sp_updatestats

select * from tabe where sp1 = 1 and sp2 = 2




select * from tabelle where spalte1=10 and spalte2=20

select * from sys.dm_db_index_usage_Stats
dbcc showcontig('Produkt')
select *
  from Produkt with (index=0)
 where LetzteAktualisierung = '20081201'
go


sp_updatestats
A B C

A
1000





sp_updatestats
go


dbcc show_statistics(Produkt,ix_Prod) with histogram
go

----Ende nicht aktueller Statistiken



