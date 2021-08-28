-- 
-- Procedures Dinâmicas no SQL Server
-- @datatuning
-- https://datatuning.com.br/blog
-- @author: Marcel Inowe

USE AdventureWorksDW2017
GO
SET STATISTICS IO, TIME ON
EXEC sp_executesql 
 N'SELECT Nome,Nascimento FROM Clientes WHERE Nome = @Nome'
,N'@Nome VARCHAR(100)'
,@Nome = 'Bailey'

