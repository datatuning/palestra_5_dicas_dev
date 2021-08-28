-- 
-- Procedures Dinâmicas no SQL Server
-- @datatuning
-- https://datatuning.com.br/blog
-- @author: Marcel Inowe

USE AdventureWorksDW2017
GO
sp_spaceused Clientes
SET STATISTICS IO, TIME ON
EXEC sp_executesql 
 N'SELECT Nome,Nascimento FROM Clientes WHERE Nome = @Nome'
,N'@Nome NVARCHAR(100)'
,@Nome='Bailey'

DECLARE @VAR NVARCHAR(1000) = N'Event Tracing for Windows (ETW) はイ'
SELECT @VAR, CAST(@VAR AS VARCHAR(1000))


Event Tracing for Windows (ETW) はイベントを送信できませんでした。リソースが不足している可能性があります。同じ送信失敗は今後報告されない可能性があります。
select * from sys.messages
select * from sys.language