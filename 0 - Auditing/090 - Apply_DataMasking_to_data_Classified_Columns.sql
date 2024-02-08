-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user

-- apply masking function to columns as needed
-- examples below used DEFAULT masking function only
--


ALTER TABLE Person.EmailAddress	
ALTER COLUMN EmailAddress [nvarchar](50)  MASKED WITH (FUNCTION='email()')

-- dbo.Contacts	
-- ContactEmail already has masked

-- dbo.Contacts2	
-- ContactEmail MASKED WITH (FUNCTION = 'partial(1, "xxx.xxx", 4)') NULL

ALTER TABLE Production.ProductReview	
ALTER COLUMN EmailAddress [nvarchar](50)  MASKED WITH (FUNCTION='email()')

ALTER TABLE Person.Address	
ALTER COLUMN AddressLine1 [nvarchar](60) MASKED WITH (FUNCTION = 'default()');

ALTER TABLE Person.Address	
ALTER COLUMN AddressLine2 [nvarchar](60) MASKED WITH (FUNCTION = 'default()');

ALTER TABLE Person.Address	
ALTER COLUMN City  [nvarchar](30) MASKED WITH (FUNCTION = 'default()');

ALTER TABLE Person.Address	
ALTER COLUMN PostalCode [nvarchar](15)  MASKED WITH (FUNCTION = 'default()');

-- ================================================================================= --
-- NOTICE: 
-- the following statements will generate ERROR as DTM cannot be applied to columns used as Primary Key
-- ================================================================================= --
ALTER TABLE Person.PersonPhone		ALTER COLUMN PhoneNumber		[dbo].[Phone]  MASKED WITH (FUNCTION = 'default()');
ALTER TABLE Person.PersonPhone		ALTER COLUMN PhoneNumberTypeID	[int]  MASKED WITH (FUNCTION = 'default()');

ALTER TABLE Person.PhoneNumberType	ALTER COLUMN PhoneNumberTypeID	[int]  MASKED WITH (FUNCTION = 'default()');

ALTER TABLE Sales.CreditCard ALTER COLUMN 	CreditCardID	[int]  MASKED WITH (FUNCTION = 'default()');
ALTER TABLE Sales.CreditCard ALTER COLUMN 	CardType	[nvarchar](50)  MASKED WITH (FUNCTION = 'default()');
ALTER TABLE Sales.CreditCard ALTER COLUMN 	CardNumber	[nvarchar](25) MASKED WITH (FUNCTION = 'default()');
ALTER TABLE Sales.CreditCard ALTER COLUMN 	ExpMonth	[tinyint]  MASKED WITH (FUNCTION = 'default()');
ALTER TABLE Sales.CreditCard ALTER COLUMN 	ExpYear	[smallint]  MASKED WITH (FUNCTION = 'default()');

-- ================================================================================= --
-- NOTICE: 
-- the following statement will generate ERROR as DTM cannot be applied to columns used as Primary Key
-- ================================================================================= --
ALTER TABLE Sales.PersonCreditCard ALTER COLUMN 	CreditCardID			[int] MASKED WITH (FUNCTION = 'default()');


ALTER TABLE Sales.SalesOrderHeader ALTER COLUMN 	CreditCardID			[int] MASKED WITH (FUNCTION = 'default()');

ALTER TABLE Sales.SalesOrderHeader ALTER COLUMN 	CreditCardApprovalCode	[varchar](15) MASKED WITH (FUNCTION = 'default()');

ALTER TABLE dbo.ErrorLog	ALTER COLUMN UserName	[sysname] MASKED WITH (FUNCTION = 'partial(2,"xxxx",0)');
ALTER TABLE Person.Password	ALTER COLUMN PasswordHash	[varchar](128) MASKED WITH (FUNCTION = 'default()');
ALTER TABLE Person.Password	ALTER COLUMN PasswordSalt	[varchar](10) MASKED WITH (FUNCTION = 'default()');


ALTER TABLE HumanResources.Employee	ALTER COLUMN BirthDate [date]   MASKED WITH (FUNCTION = 'default()');


ALTER TABLE Sales.SalesTaxRate				ALTER COLUMN TaxRate	[smallmoney] 	  MASKED WITH (FUNCTION = 'default()');
ALTER TABLE Purchasing.Vendor				ALTER COLUMN AccountNumber	[dbo].[AccountNumber] 	  MASKED WITH (FUNCTION = 'default()');


-- ================================================================================= --
-- NOTICE: 
-- the following statement will generate ERROR as DTM cannot be applied to columns with dependencies
-- ================================================================================= --
ALTER TABLE Purchasing.PurchaseOrderHeader	ALTER COLUMN TaxAmt			[money] 	  MASKED WITH (FUNCTION = 'default()');

ALTER TABLE Sales.CurrencyRate				ALTER COLUMN CurrencyRateID		  [INT] MASKED WITH (FUNCTION = 'default()');
ALTER TABLE Sales.CurrencyRate				ALTER COLUMN CurrencyRateDate  [Datetime] MASKED WITH (FUNCTION = 'default()');
ALTER TABLE Sales.SalesOrderHeader			ALTER COLUMN AccountNumber	 [dbo].[AccountNumber]  MASKED WITH (FUNCTION = 'default()');
ALTER TABLE Sales.SalesOrderHeader			ALTER COLUMN CurrencyRateID	  [int] MASKED WITH (FUNCTION = 'default()');


-- ================================================================================= --
-- NOTICE: 
-- the following statement will generate ERROR as DTM cannot be applied to columns with dependencies
-- ================================================================================= --
ALTER TABLE Sales.SalesOrderHeader			ALTER COLUMN TaxAmt			  [money] MASKED WITH (FUNCTION = 'default()');

	

ALTER TABLE Person.Person ALTER COLUMN FirstName	[dbo].[Name] 	MASKED WITH (FUNCTION = 'partial(2,"xxxx",0)');
ALTER TABLE Person.Person ALTER COLUMN LastName		[dbo].[Name] 	MASKED WITH (FUNCTION = 'partial(2,"xxxx",0)');


ALTER TABLE Sales.SalesTaxRate ALTER COLUMN SalesTaxRateID  		[int] MASKED WITH (FUNCTION = 'default()');
ALTER TABLE HumanResources.Employee ALTER COLUMN NationalIDNumber  	[nvarchar](15)  MASKED WITH (FUNCTION = 'default()');

-- list of all masked columns and their properties
-- https://sqlkitty.com/masking-columns-sensitive-data/
WITH maskedcols (DatabaseName, SchemaName, TableName, ColumnName, DATA_TYPE, ColumnLength, isMasked, MaskingFunction)
AS (
	SELECT  /* this works for string types */ 
		DB_NAME() as DatabaseName, 
		s.name 'SchemaName',
		tbl.name 'TableName', 
		c.name 'ColumnName', 
		DATA_TYPE,
		CASE
			WHEN DATA_TYPE = 'varchar' THEN col.max_length
			WHEN DATA_TYPE = 'nvarchar' THEN col.max_length/2
			ELSE 0
		END AS ColumnLength, 
		c.is_masked 'IsMasked', 
		c.masking_function 'MaskingFunction'
	FROM 
		sys.masked_columns AS c
		JOIN sys.tables AS tbl 
			ON c.[object_id] = tbl.[object_id]
		JOIN INFORMATION_SCHEMA.COLUMNS AS i
			ON i.TABLE_NAME = tbl.name and i.COLUMN_NAME = c.name
		JOIN sys.columns col 
			on tbl.object_id = col.object_id and i.COLUMN_NAME = col.name
		JOIN sys.schemas as s 
			ON tbl.schema_id = s.schema_id
	WHERE c.is_masked = 1
)
SELECT 
--	DISTINCT 'SELECT * FROM ' + schemaname+'.'+tablename
	schemaname, tablename, columnname, maskingfunction, data_type, columnlength,
	'ALTER TABLE ' + schemaname + '.' + TableName as tblAlterScript,
	'ALTER COLUMN ' + ColumnName + ' ADD MASKED WITH (FUNCTION = '  + '''' + MaskingFunction COLLATE SQL_Latin1_General_CP1_CI_AS + ''');'  as colAlterScript					
FROM 
	maskedcols
ORDER BY 
	TableName, ColumnName;  

-- list of tables containing masked columns
SELECT 
	DISTINCT tbl.name 'TableName'
FROM 
	sys.masked_columns AS c
	JOIN sys.tables AS tbl 
		ON c.[object_id] = tbl.[object_id]
WHERE 
	is_masked = 1;


