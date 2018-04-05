--Gute Sicht schlechte Sicht
use SQLDAYS_DBDESIGN
/*
drop table orders
select orderid, freight, customerid, orderdate into orders from northwind..orders

*/


--BEISPIEL 1:
Drop  view v1

create view v1
as
select * from orders;
GO

select * from v1;-- Spalten ..
GO

alter table orders add  SPX int;
go

select * from v1 

alter table orders drop column orderdate;

select * from v1;

--BEISPIEL 2:

/*
select * into bestellung from northwind..orders
select * into kunde from northwind..customers
select * into bestdetail from northwind..[order details]

*/

create view vUmsatz
as
	select k.Customerid, b.orderid, k.country,
		   b.freight, b.shipcity, bd.unitprice, bd.quantity	
	 from 
			kunde k inner join bestellung b
						ON k.customerid = b.customerid
					inner join bestdetail bd
						ON b.orderid = bd.orderid;
GO



select country from vUmsatz where customerid like 'A%'

--toller Plan!







