-- 
-- Procedures Dinâmicas no SQL Server
-- @datatuning
-- https://datatuning.com.br/blog
-- @author: Marcel Inowe

USE AdventureWorksDW2017
GO
CREATE OR ALTER PROCEDURE spCustomerReport
  @BirthDate DATE = NULL
AS
BEGIN
	SELECT LastName, FirstName, MaritalStatus, Gender, BirthDate, EmailAddress, EnglishEducation, DateFirstPurchase
	FROM DimCustomer
	WHERE 
	BirthDate = @BirthDate
END
GO

exec spCustomerReport @BirthDate = '1961-10-06'

USE AdventureWorksDW2017
GO
CREATE OR ALTER PROCEDURE spCustomerReport
  @BirthDate DATE = NULL
 ,@Gender NVARCHAR(2) = NULL
 ,@LastName NVARCHAR(100) = NULL
 ,@FirstName NVARCHAR(100) = NULL
 ,@MaritalStatus NVARCHAR(2) = NULL
 ,@EnglishEducation NVARCHAR(80) = NULL
AS
BEGIN
	SELECT LastName, FirstName, MaritalStatus, Gender, BirthDate, EmailAddress, EnglishEducation, DateFirstPurchase
	FROM DimCustomer
	WHERE 
	    (@BirthDate IS NULL OR BirthDate = @BirthDate)
	AND (@Gender    IS NULL OR Gender = @Gender)
	AND (@LastName  IS NULL OR LastName = @LastName)
	AND (@FirstName IS NULL OR FirstName = @FirstName)
	AND (@MaritalStatus    IS NULL OR MaritalStatus = @MaritalStatus)
	AND (@EnglishEducation IS NULL OR EnglishEducation = @EnglishEducation)
END
GO

/*Exemplos de chamada da procedure e criação de índices para comparar a performance*/
SET STATISTICS IO, TIME ON
exec spCustomerReport @BirthDate = '1961-10-06', @Gender = 'M'
exec spCustomerReport @LastName = 'Gonzales'
exec spCustomerReport @Gender = 'F'
exec spCustomerReport
exec spCustomerReport @BirthDate = '1935-03-21', @Gender = 'F'
                    , @LastName='Gonzales', @FirstName = 'Madison'
					, @EnglishEducation = 'Graduate Degree'
					, @MaritalStatus = 'M'

exec spCustomerReport @FirstName = 'William'

CREATE NONCLUSTERED INDEX IDX_DimCustomer_01 ON DimCustomer(BirthDate,Gender) INCLUDE(LastName, FirstName, MaritalStatus, EmailAddress, EnglishEducation, DateFirstPurchase)

SELECT LastName, FirstName, MaritalStatus, Gender, BirthDate, EmailAddress, EnglishEducation, DateFirstPurchase
FROM DimCustomer
where 
BirthDate = '1961-10-06'
and Gender = 'M'

exec spCustomerReport @BirthDate = '1961-10-06', @Gender = 'M'

CREATE NONCLUSTERED INDEX IDX_DimCustomer_02 ON DimCustomer(LastName) INCLUDE(BirthDate,Gender, FirstName, MaritalStatus, EmailAddress, EnglishEducation, DateFirstPurchase)

SELECT LastName, FirstName, MaritalStatus, Gender, BirthDate, EmailAddress, EnglishEducation, DateFirstPurchase
FROM DimCustomer
where 
LastName = 'Gonzales'

exec spCustomerReport @LastName = 'Gonzales'



