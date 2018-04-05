--DBDesign

/*
Normalisierung ..1. NF, 2 NF, 3NF

SHOP

Kunden
----------------------
PK KDNr     int      --FK(Bestellung.customerid)  1:N
FamName     char(n), varchar(n), nchar(n), nvarchar(n)
Vorname     varchar(50)
PLZ         in GER char(5)
Ort         varchar(50)
Strasse     vchar(50)
GebDatum    date (siche rkein datetime (ms))

char(n), varchar(n), nchar(n), nvarchar(n): OTTO

char(10) ... 'Otto.......' (10)
varchar(10)..'Otto'         (4)
nchar(10) .. 'Otto......|UNICODE...' (20.. 2*10)
nvarchar(10).'Otto|UNIC' (8)    ...(2*4)





Produkte
--------------------------
PNr int
Bez varchar(50)
Preis money (0,7n) decimal(10,2), float (27)


Bestellungen
--------------------------
BNr int
KDNr int
BestellDatum date


BestellPositionen
-----------------------
PosNr int
BNr   int 
Menge tinyint(255), smallint(32000), int(2,1Mrd), bigint
KaufPreis money
PNr int


uniqueidentifier - GUID
select newid() --4C4B8EE9-4252-432B-BFDD-6F85DD3C28DB


Maier 1.10.2016 17 Jeans 2 50
Maier 1.10.2016 12 Shirt 4 10

5 100 1.10.2016


1 5 17 2 50
2 5 12 4 10



1 A B C
2 A B C
3 A B C

delete from tab where sp1 = 2


PK - FK Beziehung
nebenbei PK=Garantie, dass der Wert wirklich eindeutig ist und bleibt!



*/



--Sichten Prozeduren 