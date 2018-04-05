--Functions können im Plan oft nicht geschätzt werden und daher
--auch nicht optimiert werden

--Funktionen werden nie paralellisiert!

use AdventureWorks2014

drop function dbo.fnGetCustAccountNr




create function dbo.fnGetCustAccountNr(@custid int)
returns varchar(50)
as
begin
return isnull(
	(
	select AccountNumber from [Sales].[Customer]
		where CustomerID=@custid
	),'not found');
end


--messen und vergleichen
set statistics io on
set statistics time on

select top 10 * from [Sales].[SalesOrderHeader]

--Eigtl hat jede Customerid einen passenden Referenzwert
select soh.SalesOrderID, soh.OrderDate,
		dbo.fnGetCustAccountNr(soh.CustomerID) 
from  [Sales].[SalesOrderHeader] soh

--dennoch Seek

select soh.SalesOrderID, soh.OrderDate,
	isnull(
	(
	select AccountNumber from [Sales].[Customer]
		where CustomerID=soh.CustomerID	
	),'not found')
	from Sales.SalesOrderHeader soh


--Beispiel 2: Fn in where

use AdventureWorks2012
go

if object_id('dbo.x') is not null 
    drop function dbo.x
go

create function dbo.x() returns int
as
begin return 776 end
go 

select * from Sales.SalesOrderDetail
where ProductID=776
go

select
   *
from
   Sales.SalesOrderDetail
where
   ProductID=dbo.x()
go




--Beispiel 3

drop function dbo.Adressen
go






--Planwiederverwendung

use northwind

drop function dbo.fn_maskTel

create function dbo.fn_maskTel (@tel char(15))
Returns char(15)
as
Begin
select @tel = left (@tel, 10) + 'xxx-xx'
return @tel
end

dbcc freeproccache;
set statistics io on

declare @mask char(15)
exec @mask = dbo.fn_masktel '1234567890123'
select @mask
go


declare @mask char(15)
exec @mask = dbo.fn_masktel '1234567890123' with recompile
select @mask
go

select companyname, Phone, dbo.fn_masktel(Phone)
	 from customers where country = 'UK'

select companyname, Phone, dbo.fn_masktel(Phone)
	 from customers where country = 'UK'

select companyname, Phone, dbo.fn_masktel(Phone)
	 from customers where country = 'USA'


select usecounts, cacheobjtype,objtype, [TEXT] from
	sys.dm_exec_cached_plans P
		CROSS APPLY sys.dm_exec_sql_text(plan_handle)
	where cacheobjtype ='Compiled PLan'
		AND [TEXT] not like '%dm_exec_cached_plans%'




