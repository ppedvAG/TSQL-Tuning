/*
Der Grad der Paral...

Std = 5 (SQL Dollar) und 0 = alle Prozessoren
5?? ..50 zu Beginn
Anzahl der CPU auf 50% (4)..
während der Laufzeit änderbar

CXPACKET .. Häufigkeit des Paral.. in sys.dm_os_Wait_Stats


USE nwindbig
SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT * FROM customers c INNER JOIN orders o
    ON c.CustomerID=o.CustomerID
 --   WHERE c.CustomerID < 'AD'
-- CPU-Zeit = 14032 ms, verstrichene Zeit = 29194 ms. --4
--mit einem:, CPU-Zeit = 18594 ms, verstrichene Zeit = 34387 ms. --1
-- CPU-Zeit = 14312 ms, verstrichene Zeit = 30697 ms. --2
--, CPU-Zeit = 15079 ms, verstrichene Zeit = 30762 m --3

EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'cost threshold for parallelism', N'50'
GO
EXEC sys.sp_configure N'max degree of parallelism', N'3'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
GO


--CXPACKET!
SELECT * FROM sys.dm_os_wait_Stats ORDER BY 2 desc
*/