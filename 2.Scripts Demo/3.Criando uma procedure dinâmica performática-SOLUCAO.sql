-- 
-- Procedures Dinâmicas no SQL Server
-- @datatuning
-- https://datatuning.com.br/blog
-- @author: Marcel Inowe

USE AdventureWorksDW2017
GO
CREATE OR ALTER PROCEDURE spCustomerReport_Dyn
  @BirthDate DATE = NULL
 ,@Gender NVARCHAR(2) = NULL
 ,@LastName NVARCHAR(100) = NULL
 ,@FirstName NVARCHAR(100) = NULL
 ,@MaritalStatus NVARCHAR(2) = NULL
 ,@EnglishEducation NVARCHAR(80) = NULL
AS
BEGIN
	DECLARE @SQL NVARCHAR(4000) = '
	SELECT LastName, FirstName, MaritalStatus, Gender, BirthDate, EmailAddress, EnglishEducation, DateFirstPurchase
	FROM DimCustomer
	WHERE 1=1 '
	+ CASE WHEN @BirthDate IS NOT NULL THEN 'AND BirthDate = @pBirthDate ' ELSE '' END
	+ CASE WHEN @Gender IS NOT NULL THEN 'AND Gender = @pGender ' ELSE '' END
	+ CASE WHEN @LastName IS NOT NULL THEN 'AND LastName = @pLastName ' ELSE '' END
	+ CASE WHEN @FirstName IS NOT NULL THEN 'AND FirstName = @pFirstName ' ELSE '' END
	+ CASE WHEN @MaritalStatus IS NOT NULL THEN 'AND MaritalStatus = @pMaritalStatus' ELSE '' END
	+ CASE WHEN @EnglishEducation IS NOT NULL THEN 'AND EnglishEducation = @pEnglishEducation ' ELSE '' END

	PRINT @SQL
	
	EXEC sp_executesql @SQL
	,N'@pBirthDate DATE, @pGender NVARCHAR(2), @pLastName NVARCHAR(100), @pFirstName NVARCHAR(100),@pMaritalStatus NVARCHAR(2),@pEnglishEducation NVARCHAR(80)'
	,@pBirthDate = @BirthDate, @pGender = @Gender, @pLastName = @LastName, @pFirstName = @FirstName, @pMaritalStatus = @MaritalStatus, @pEnglishEducation = @EnglishEducation
END
GO
/*Exemplos de chamada da procedure*/

SET STATISTICS IO ON
exec spCustomerReport_Dyn @BirthDate = '1961-10-06', @Gender = 'M'
exec spCustomerReport     @BirthDate = '1961-10-06', @Gender = 'M'

exec spCustomerReport_Dyn @LastName = 'Gonzales'
exec spCustomerReport     @LastName = 'Gonzales'

exec DBA..sp_GetProcStats 
@DbName = 'AdventureWorksDW2017'
,@ProcName = 'spCustomerReport_Dyn'

exec DBA..sp_GetQueryStats @SqlText = 'SELECT LastName, FirstName, MaritalStatus'