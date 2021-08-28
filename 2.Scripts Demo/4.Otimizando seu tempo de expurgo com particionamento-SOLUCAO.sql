-- 
-- Procedures Dinâmicas no SQL Server
-- @datatuning
-- https://datatuning.com.br/blog
-- @author: Marcel Inowe

--REALIZAR RESTORE DA BASE DE DADOS NOVAMENTE...
USE AdventureWorksDW2017
GO
CREATE PARTITION FUNCTION PF_FactProductInventoryHistory (DATE)
AS RANGE RIGHT FOR VALUES 
('20200901','20201001','20201101','20201201'
,'20210101','20210201','20210301','20210401'
,'20210501','20210601','20210701','20210801');
GO
CREATE PARTITION SCHEME PS_FactProductInventoryHistory AS PARTITION PF_FactProductInventoryHistory 
ALL TO ([PRIMARY])
GO
USE [AdventureWorksDW2017]
GO

DROP INDEX [IDX_FactProductInventoryHistory] ON [dbo].[FactProductInventoryHistory] WITH ( ONLINE = OFF )
GO
CREATE CLUSTERED INDEX [IDX_FactProductInventoryHistory] ON [dbo].[FactProductInventoryHistory]
(
	[ProductKey] ASC,
	[DateKey] ASC
)
WITH (DATA_COMPRESSION =PAGE) 
ON PS_FactProductInventoryHistory(DateKey)
GO
--VALIDAÇÃO DO PARTICIONAMENTO
SELECT
o.name  as table_name, 
ps.name as partition_scheme_name, 
f.name  as partition_function_name, 
partition_function_range_type = case f.boundary_value_on_right when 1 then 'Right' else 'Left' end, 
rv.value as partition_range, 
fg.name as [filegroup_name], 
p.partition_number, 
p.rows as partition_rows,
sum(pst.used_page_count * 8) as partition_space_used_kb,
sum(pst.used_page_count / 128) as partition_space_used_Mb
FROM sys.partitions p
INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
INNER JOIN sys.objects o ON p.object_id = o.object_id
INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id 
LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = (case f.boundary_value_on_right when 0 then boundary_id else boundary_id+1 end)--c
INNER JOIN sys.dm_db_partition_stats pst on pst.partition_id = p.partition_id
WHERE
i.index_id < 2
and o.object_id = OBJECT_ID('FactProductInventoryHistory')
GROUP BY o.name,ps.name,f.name ,f.boundary_value_on_right,rv.value,fg.name,p.partition_number,p.rows
order by p.partition_number
GO

--------------------------SQL SERVER >= 2016--------------------------------

SET STATISTICS IO ON
GO
TRUNCATE TABLE FactProductInventoryHistory WITH (PARTITIONS(1))

------------------------METODO ALTERNATIVO PARA SQL < 2016-----------------------------
--REALIZAR RESTORE DA BASE DE DADOS NOVAMENTE...
CREATE TABLE [dbo].[FactProductInventoryHistory_TEMP](
	[ProductKey] [int] NOT NULL,
	[DateKey] [date] NOT NULL,
	[MovementDate] [datetime] NULL,
	[UnitCost] [money] NOT NULL,
	[UnitsIn] [int] NOT NULL,
	[UnitsOut] [int] NOT NULL,
	[UnitsBalance] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IDX_FactProductInventoryHistory_TEMP] ON [dbo].[FactProductInventoryHistory_TEMP]
(
	[ProductKey] ASC,
	[DateKey] ASC
)
WITH(DATA_COMPRESSION=PAGE) 
ON [PRIMARY]
GO

SET STATISTICS IO ON
ALTER TABLE [FactProductInventoryHistory] SWITCH PARTITION 1 TO [FactProductInventoryHistory_TEMP]

EXEC sp_spaceused [FactProductInventoryHistory_TEMP]
TRUNCATE TABLE [FactProductInventoryHistory_TEMP]