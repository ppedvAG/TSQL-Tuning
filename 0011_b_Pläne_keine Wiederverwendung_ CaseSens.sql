use northwind
select * from orders inner join customers ON orders.CustomerID=Customers.CustomerID where orderid = 10




dbcc freeproccache;
GO
select * from orders where customerID='HANAR'
go

select * from Orders where CustomerID='HANAR'
go
select * from Orders 
	where   CustomerID='HANAR'
go


select usecounts, cacheobjtype,[TEXT] from
	sys.dm_exec_cached_plans P
		CROSS APPLY sys.dm_exec_sql_text(plan_handle)
	where cacheobjtype ='Compiled PLan'
		AND [TEXT] not like '%dm_exec_cached_plans%'

dbcc freeproccache
select firstname, lastname, title from Employees
	where EmployeeID = 6
go
select firstname, lastname, title from Employees
	where EmployeeID = 300

select firstname, lastname, title from Employees
	where EmployeeID = 70000


select usecounts, cacheobjtype,[TEXT] from
	sys.dm_exec_cached_plans P
		CROSS APPLY sys.dm_exec_sql_text(plan_handle)
	where cacheobjtype ='Compiled PLan'
		AND [TEXT] not like '%dm_exec_cached_plans%'