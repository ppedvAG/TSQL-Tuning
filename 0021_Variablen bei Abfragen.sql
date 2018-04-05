use Nwindbig


--Personentabelle anlegen
set statistics io on
set statistics time on
--Geschätzte Zeilenzahl
select * from Orders where Employeeid < 10
go


--Geschätzte Zeilenzahl
declare @id int
set @id = 10
select * from Orders where Employeeid< @id

--Sofern < oder > verwendet wird und Optimierer kann die 
--Anzahl nur schätzen, dann wird 30% angenommen