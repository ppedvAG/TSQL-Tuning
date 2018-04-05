
--Nun T1 komprimiert...von ca 160MB auf ca 300kb

--IO    CPU   Dauer   Anwendung    RAM

SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT * FROM t2
/*

t2-Tabelle. Scananzahl 1, logische Lesevorgänge 20001, physische Lesevorgänge 0, Read-Ahead-Lesevorgänge 7, logische LOB-Lesevorgänge 0, physische LOB-Lesevorgänge 0, Read-Ahead-LOB-Lesevorgänge 0.

 SQL Server-Ausführungszeiten: 
, CPU-Zeit = 125 ms, verstrichene Zeit = 851 ms.

214 MB RAM --380

--nach kompression

Seiten: weniger CPU: ca gleich eher höher  Dauer: kürzer
RAM: weniger oder doch gleich





*/

SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT * FROM t1


 SQL Server-Ausführungszeiten: 
, CPU-Zeit = 125 ms, verstrichene Zeit = 851 ms.

--214 MB RAM ..kleiner Schluckauf
--Seiten: 30 .. Dauer: 828   CPU: 46
--in realität: höhere CPU
--Profit liegt eher darin, dass mehr Daten auch aus anderen Tabellen im RAM sind
--du zahlst mit CPU