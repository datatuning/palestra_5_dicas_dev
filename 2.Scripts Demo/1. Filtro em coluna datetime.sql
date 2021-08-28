-- 
-- Procedures Dinâmicas no SQL Server
-- @datatuning
-- https://datatuning.com.br/blog
-- @author: Marcel Inowe

--Como são realizados os filtros em coluna datetime pelos desenvolvedores?
--1. Filtrando os registros de um determinado dia:
	select CONVERT(CHAR(8),getdate(),112)
	SET STATISTICS IO, TIME ON
	SELECT ProductKey,DateKey,MovementDate 
	FROM FactProductInventory 
	WHERE CONVERT(CHAR(8),MovementDate,112) = '20110112'

--2. Filtrando os registros de um determinado mês:

	SELECT ProductKey,DateKey,MovementDate 
	FROM FactProductInventory 
	WHERE LEFT(CONVERT(CHAR(8),MovementDate,112),6) = '201101'

--OR

	SELECT ProductKey,DateKey,MovementDate 
	FROM FactProductInventory 
	WHERE YEAR(MovementDate) = 2011 AND MONTH(MovementDate) = 01

--3. Filtrando os registros de um determinado ano:

	SELECT ProductKey,DateKey,MovementDate 
	FROM FactProductInventory 
	WHERE LEFT(CONVERT(CHAR(8),MovementDate,112),4) = '2011'

--OR

	SELECT ProductKey,DateKey,MovementDate 
	FROM FactProductInventory 
	WHERE YEAR(MovementDate) = 2011


