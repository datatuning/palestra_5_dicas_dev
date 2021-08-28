-- 
-- Procedures Dinâmicas no SQL Server
-- @datatuning
-- https://datatuning.com.br/blog
-- @author: Marcel Inowe

USE AdventureWorksDW2017
GO
SET STATISTICS IO ON

exec sp_spaceused FactProductInventoryHistory

SELECT COUNT(0) FROM FactProductInventoryHistory WHERE DateKey < '20200901' 

DELETE FROM FactProductInventoryHistory WHERE DateKey < '20200901' 






















--BACKUP DATABASE AdventureWorksDW2017 TO DISK='C:\TEMP\AdventureWorksDW2017.BAK' WITH COMPRESSION,STATS=10