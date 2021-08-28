-- 
-- Procedures Dinâmicas no SQL Server
-- @datatuning
-- https://datatuning.com.br/blog
-- @author: Marcel Inowe

--Imagine a situação onde você não pode alterar a query e precisa melhorar a performance.
--Como sair dessa?
	SET STATISTICS IO ON

	SELECT ProductKey,DateKey,MovementDate 
	FROM FactProductInventory 
	WHERE LEFT(CONVERT(CHAR(8),MovementDate,112),6) = '201101'
