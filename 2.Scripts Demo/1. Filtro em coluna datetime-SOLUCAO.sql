-- 
-- Procedures Dinâmicas no SQL Server
-- @datatuning
-- https://datatuning.com.br/blog
-- @author: Marcel Inowe

--Como os filtros em coluna datetime DEVERIAM SER REALIZADOS pelos desenvolvedores?
--1. Filtrando os registros de um determinado dia:
	SET STATISTICS IO, TIME ON
	SELECT ProductKey,DateKey,MovementDate 
	FROM FactProductInventory 
	WHERE MovementDate BETWEEN '20110112 00:00:00' AND '20110112 23:59:59.987'
	--OR
	SELECT ProductKey,DateKey,MovementDate 
	FROM FactProductInventory 
	WHERE CAST(MovementDate AS DATE) = '20110112'

	SELECT ProductKey,DateKey,MovementDate 
	FROM FactProductInventory 
	WHERE MovementDate = '20110112'


--2. Filtrando os registros de um determinado mês:

	SELECT ProductKey,DateKey,MovementDate 
	FROM FactProductInventory 
	WHERE MovementDate BETWEEN '20110101 00:00:00' AND '20110131 23:59:59'
	
	SELECT ProductKey,DateKey,MovementDate 
	FROM FactProductInventory 
	WHERE CAST(MovementDate AS DATE) BETWEEN '20110101' AND '20110131'

--3. Filtrando os registros de um determinado ano:

	SELECT ProductKey,DateKey,MovementDate 
	FROM FactProductInventory 
	WHERE MovementDate BETWEEN '20110101 00:00:00' AND '20111231 23:59:59'
