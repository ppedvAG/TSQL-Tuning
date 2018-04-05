use demoDb
select * from tblA left outer join tblb on tbla.pk = tblb.pk and tblb.pk=1

--besser
select * from tbla left outer join tblb on tbla.pk = tblb.pk where tblb.pk = 1

--Design

--Wie geht das besser
select CompanyName, City from northwind..Customers
	group by CompanyName, City
	having City = 'Berlin'

--Warum geht ein orderby nach Produktid,
--aber nicht Stadt	

select orderid as Produktid, shipcity as Stadt from northwind..orders
where shipcountry = 'Germany'
--group by stadt
--order by produktid
