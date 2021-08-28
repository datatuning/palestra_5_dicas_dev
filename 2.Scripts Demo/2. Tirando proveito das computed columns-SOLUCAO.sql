-- 
-- Procedures Dinâmicas no SQL Server
-- @datatuning
-- https://datatuning.com.br/blog
-- @author: Marcel Inowe

--Imagine a situação onde você não pode alterar a query e precisa melhorar a performance.
--Saindo dessa condição terrível...
	DROP INDEX IDX_FactProductInventory_01 ON FactProductInventory
	SET STATISTICS IO ON

	SELECT ProductKey,DateKey,MovementDate 
	FROM FactProductInventory 
	WHERE LEFT(CONVERT(CHAR(8),MovementDate,112),6) = '201101'





	
	ALTER TABLE FactProductInventory 
		ADD COMPUTED_MovementDate AS LEFT(CONVERT(CHAR(8),MovementDate,112),6) 
	
	CREATE INDEX IDX_FactProductInventory_COMPUTED_MovementDate 
	ON FactProductInventory(COMPUTED_MovementDate) INCLUDE(MovementDate)

	
