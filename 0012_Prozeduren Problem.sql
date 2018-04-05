create procedure spbestsuche @id as int
as
select * from orders where orderid = @id


exec spbestsuche 10250


--Plan wird kompiliert und ist nach Neustart auch noch vorhanden
--Plan ändert sich nicht..

--Plan wird beim ersten Aufruf erstellt..!




use AdventureWorks2014;
if (object_id('SuchePersonen', 'P') is not null)
  drop procedure SuchePersonen
go  

--Prozedur zur Suche nach Personen mit Wildcard
create procedure SuchePersonen(@n nvarchar(80))
 as 
 begin
   set @n = replace(@n, '*', '%') + '%'
   select LastName,FirstName,ModifiedDate
     from Person.Person
     where LastName like @n
 end
go





exec SuchePersonen '*'
--Seek!!

dbcc freeproccache
exec SuchePersonen '%'
--;-)..SCAN

------------------------------------------------------------------
--Bedingte Prozedur..

use AdventureWorks2012;
if (object_id('SucheAdressen', 'P') is not null)
  drop procedure SucheAdressen
go  
create procedure SucheAdressen(@city nvarchar(30), @postalCode nvarchar(15)) as
 begin
   if (@city is not null)
     select PostalCode, City, AddressLine1, AddressLine2, ModifiedDate
       from Person.Address 
      where City like @city
   else if (@postalCode is not null)   
     select PostalCode, City, AddressLine1, AddressLine2, ModifiedDate
       from Person.Address 
      where PostalCode like @postalCode 
   else 
     select PostalCode, City, AddressLine1, AddressLine2, ModifiedDate
       from Person.Address 
 end
go


exec SucheAdressen '%Dulu%', null
--SCAN auf Addressline korrekt.. da CIty keine führende Spalte


exec SucheAdressen null, '558%'
--Clustered Index Scan.. schlecht, da INdex Scan besser wäre
--geschätzte Anzahl von Zeilen: > 600 (Statistik)
--Plan musste beim ersten Start der Prozedur überlegt werden


----EINE BEDINGUNG IM PLAN führt zur Schätzung aller Alternativen
----nur der erste Aufruf ist wirklich optimiert

--Das Problem tritt auch ohne IF auf...

if (object_id('SucheAdressen', 'P') is not null)
  drop procedure SucheAdressen
go  
create procedure SucheAdressen(@city nvarchar(30), @postalCode nvarchar(15)) as
 begin
   select PostalCode, City, AddressLine1, AddressLine2, ModifiedDate
     from Person.Address 
    where ((@city is null) or (City like @city))
      and ((@postalCode is null) or (PostalCode like @postalCode))
 end
go

--oder auch so........
if (object_id('SucheAdressen', 'P') is not null)
  drop procedure SucheAdressen
go  
create procedure SucheAdressen(@city nvarchar(30), @postalCode nvarchar(15)) as
 begin
   select PostalCode, City, AddressLine1, AddressLine2, ModifiedDate
     from Person.Address 
    where City like isnull(@city, '##')
       or PostalCode like isnull(@postalCode,'##')
 end
go


--oder eben so..
if (object_id('SucheAdressen', 'P') is not null)
  drop procedure SucheAdressen
go  
create procedure SucheAdressen(@city nvarchar(30)) as
 begin
   declare @citySearch nvarchar(80)
   --iable wird erst in Prozedur  festgelegt
   set @citySearch = replace(@city, '*', '%') + '%'
   select PostalCode, City, AddressLine1, AddressLine2, ModifiedDate
     from Person.Address 
    where City like @citySearch
 end
go



exec SucheAdressen 'Kingsport'




