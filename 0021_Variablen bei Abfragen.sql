use Nwindbig


--Personentabelle anlegen
set statistics io on
set statistics time on
--Gesch�tzte Zeilenzahl
select * from Orders where Employeeid < 10
go


--Gesch�tzte Zeilenzahl
declare @id int
set @id = 10
select * from Orders where Employeeid< @id

--Sofern < oder > verwendet wird und Optimierer kann die 
--Anzahl nur sch�tzen, dann wird 30% angenommen