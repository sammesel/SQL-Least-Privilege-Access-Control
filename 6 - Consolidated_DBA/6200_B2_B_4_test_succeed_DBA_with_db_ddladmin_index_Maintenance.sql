-- ================================================================================= --
-- LOGIN as:		[Login_Test_DBA]
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO

	-- can the DBA create a table from an existing table?
	-- no if it needs to SELECT from existing table which he/she doesn't have SELECT permission
	DROP TABLE IF EXISTS test_table 
	GO
	SELECT * 
	INTO test_table 
	FROM sales.salesorderheader

		-- can the DBA create a new using script?
		-- YES
		CREATE TABLE sales.test_table (
			[SalesOrderID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
			[RevisionNumber] [tinyint] NOT NULL,
			[OrderDate] [datetime] NOT NULL,
			[DueDate] [datetime] NOT NULL,
			[ShipDate] [datetime] NULL,
			[Status] [tinyint] NOT NULL,
			[OnlineOrderFlag] [dbo].[Flag] NOT NULL,
			[SalesOrderNumber]  AS (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID]),N'*** ERROR ***')),
			[PurchaseOrderNumber] [dbo].[OrderNumber] NULL,
			[AccountNumber] [dbo].[AccountNumber] MASKED WITH (FUNCTION = 'default()') NULL,
			[CustomerID] [int] NOT NULL,
			[SalesPersonID] [int] NULL,
			[TerritoryID] [int] NULL,
			[BillToAddressID] [int] NOT NULL,
			[ShipToAddressID] [int] NOT NULL,
			[ShipMethodID] [int] NOT NULL,
			[CreditCardID] [int] MASKED WITH (FUNCTION = 'default()') NULL,
			[CreditCardApprovalCode] [varchar](15) MASKED WITH (FUNCTION = 'default()') NULL,
			[CurrencyRateID] [int] MASKED WITH (FUNCTION = 'default()') NULL,
			[SubTotal] [money] NOT NULL,
			[TaxAmt] [money] NOT NULL,
			[Freight] [money] NOT NULL,
			[TotalDue]  AS (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))),
			[Comment] [nvarchar](128) NULL,
			[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
			[ModifiedDate] [datetime] NOT NULL,
		 CONSTRAINT [PK_test_SalesOrderHeader_SalesOrderID] PRIMARY KEY CLUSTERED 
		(
			[SalesOrderID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]
		GO

		-- these will fail
		-- https://learn.microsoft.com/en-us/sql/t-sql/statements/add-sensitivity-classification-transact-sql?view=sql-server-ver16
		--
		ADD SENSITIVITY CLASSIFICATION TO sales.test_table.[AccountNumber] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
		GO
		ADD SENSITIVITY CLASSIFICATION TO sales.test_table.[CreditCardID] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credit Card', information_type_id = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646');
		GO
		ADD SENSITIVITY CLASSIFICATION TO sales.test_table.[CreditCardApprovalCode] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credit Card', information_type_id = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646');
		GO
		ADD SENSITIVITY CLASSIFICATION TO sales.test_table.[CurrencyRateID] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
		GO
		ADD SENSITIVITY CLASSIFICATION TO sales.test_table.[TaxAmt] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
		GO

		--
		-- execute script [6200_B1_B3_Grant_ALTER_ANY_SENSITIVITY_CLASSIFICATION_to_Test_DBA.sql] 
		-- GRANT ALTER ANY SENSITIVITY CLASSIFICATION to [role_DBA_With_DB_DDLAdmin]
		-- 
		-- retry previous commands, repeated here for convenience:
		--
		ADD SENSITIVITY CLASSIFICATION TO sales.test_table.[AccountNumber] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
		GO
		ADD SENSITIVITY CLASSIFICATION TO sales.test_table.[CreditCardID] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credit Card', information_type_id = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646');
		GO
		ADD SENSITIVITY CLASSIFICATION TO sales.test_table.[CreditCardApprovalCode] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credit Card', information_type_id = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646');
		GO
		ADD SENSITIVITY CLASSIFICATION TO sales.test_table.[CurrencyRateID] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
		GO
		ADD SENSITIVITY CLASSIFICATION TO sales.test_table.[TaxAmt] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
		GO

		
		-- these will work:
		--
		ALTER TABLE sales.test_table ADD  CONSTRAINT [DF_test_SalesOrderHeader_OrderDate]  DEFAULT (getdate()) FOR [OrderDate]
		GO
		ALTER TABLE sales.test_table ADD  CONSTRAINT [DF_test_SalesOrderHeader_Status]  DEFAULT ((1)) FOR [Status]
		GO
		ALTER TABLE sales.test_table  WITH CHECK ADD  CONSTRAINT [FK_test_SalesOrderHeader_Address_BillToAddressID] FOREIGN KEY([BillToAddressID])
		REFERENCES [Person].[Address] ([AddressID])
		GO
		ALTER TABLE sales.test_table CHECK CONSTRAINT [FK_test_SalesOrderHeader_Address_BillToAddressID]
		GO
		ALTER TABLE sales.test_table  WITH CHECK ADD  CONSTRAINT [FK_test_SalesOrderHeader_Address_ShipToAddressID] FOREIGN KEY([ShipToAddressID])
		REFERENCES [Person].[Address] ([AddressID])
		GO
		ALTER TABLE sales.test_table CHECK CONSTRAINT [FK_test_SalesOrderHeader_Address_ShipToAddressID]
		GO
		ALTER TABLE sales.test_table  WITH CHECK ADD  CONSTRAINT [FK_test_SalesOrderHeader_CreditCard_CreditCardID] FOREIGN KEY([CreditCardID])
		REFERENCES [Sales].[CreditCard] ([CreditCardID])
		GO
		ALTER TABLE sales.test_table CHECK CONSTRAINT [FK_test_SalesOrderHeader_CreditCard_CreditCardID]
		GO
		ALTER TABLE sales.test_table  WITH CHECK ADD  CONSTRAINT [FK_test_SalesOrderHeader_CurrencyRate_CurrencyRateID] FOREIGN KEY([CurrencyRateID])
		REFERENCES [Sales].[CurrencyRate] ([CurrencyRateID])
		GO
		ALTER TABLE sales.test_table CHECK CONSTRAINT [FK_test_SalesOrderHeader_CurrencyRate_CurrencyRateID]
		GO
		ALTER TABLE sales.test_table  WITH CHECK ADD  CONSTRAINT [FK_test_SalesOrderHeader_Customer_CustomerID] FOREIGN KEY([CustomerID])
		REFERENCES [Sales].[Customer] ([CustomerID])
		GO
		ALTER TABLE sales.test_table CHECK CONSTRAINT [FK_test_SalesOrderHeader_Customer_CustomerID]
		GO
		ALTER TABLE sales.test_table  WITH CHECK ADD  CONSTRAINT [FK_test_SalesOrderHeader_SalesPerson_SalesPersonID] FOREIGN KEY([SalesPersonID])
		REFERENCES [Sales].[SalesPerson] ([BusinessEntityID])
		GO
		ALTER TABLE sales.test_table CHECK CONSTRAINT [FK_test_SalesOrderHeader_SalesPerson_SalesPersonID]
		GO
		ALTER TABLE sales.test_table  WITH CHECK ADD  CONSTRAINT [FK_test_SalesOrderHeader_SalesTerritory_TerritoryID] FOREIGN KEY([TerritoryID])
		REFERENCES [Sales].[SalesTerritory] ([TerritoryID])
		GO
		ALTER TABLE sales.test_table CHECK CONSTRAINT [FK_test_SalesOrderHeader_SalesTerritory_TerritoryID]
		GO
		ALTER TABLE sales.test_table  WITH CHECK ADD  CONSTRAINT [FK_test_SalesOrderHeader_ShipMethod_ShipMethodID] FOREIGN KEY([ShipMethodID])
		REFERENCES [Purchasing].[ShipMethod] ([ShipMethodID])
		GO
		ALTER TABLE sales.test_table CHECK CONSTRAINT [FK_test_SalesOrderHeader_ShipMethod_ShipMethodID]
		GO
		ALTER TABLE sales.test_table  WITH CHECK ADD  CONSTRAINT [CK_test_SalesOrderHeader_DueDate] CHECK  (([DueDate]>=[OrderDate]))
		GO
		ALTER TABLE sales.test_table CHECK CONSTRAINT [CK_test_SalesOrderHeader_DueDate]
		GO
		ALTER TABLE sales.test_table  WITH CHECK ADD  CONSTRAINT [CK_test_SalesOrderHeader_Freight] CHECK  (([Freight]>=(0.00)))
		GO
		ALTER TABLE sales.test_table CHECK CONSTRAINT [CK_test_SalesOrderHeader_Freight]
		GO
		ALTER TABLE sales.test_table  WITH CHECK ADD  CONSTRAINT [CK_test_SalesOrderHeader_ShipDate] CHECK  (([ShipDate]>=[OrderDate] OR [ShipDate] IS NULL))
		GO
		ALTER TABLE sales.test_table CHECK CONSTRAINT [CK_test_SalesOrderHeader_ShipDate]
		GO
		ALTER TABLE sales.test_table  WITH CHECK ADD  CONSTRAINT [CK_test_SalesOrderHeader_Status] CHECK  (([Status]>=(0) AND [Status]<=(8)))
		GO
		ALTER TABLE sales.test_table CHECK CONSTRAINT [CK_test_SalesOrderHeader_Status]
		GO
		ALTER TABLE sales.test_table  WITH CHECK ADD  CONSTRAINT [CK_test_SalesOrderHeader_SubTotal] CHECK  (([SubTotal]>=(0.00)))
		GO
		ALTER TABLE sales.test_table CHECK CONSTRAINT [CK_test_SalesOrderHeader_SubTotal]
		GO
		ALTER TABLE sales.test_table  WITH CHECK ADD  CONSTRAINT [CK_test_SalesOrderHeader_TaxAmt] CHECK  (([TaxAmt]>=(0.00)))
		GO
		ALTER TABLE sales.test_table CHECK CONSTRAINT [CK_test_SalesOrderHeader_TaxAmt]
		GO
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key.' , @level0type=N'SCHEMA',@level0name=N'sales', @level1type=N'TABLE',@level1name=N'test_table', @level2type=N'COLUMN',@level2name=N'SalesOrderID'
		GO
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Incremental number to track changes to the sales order over time.' , @level0type=N'SCHEMA',@level0name=N'sales', @level1type=N'TABLE',@level1name=N'test_table', @level2type=N'COLUMN',@level2name=N'RevisionNumber'
		GO
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of GETDATE()' , @level0type=N'SCHEMA',@level0name=N'sales', @level1type=N'TABLE',@level1name=N'test_table', @level2type=N'CONSTRAINT',@level2name=N'DF_test_SalesOrderHeader_OrderDate'
		GO
		-- using script ]
		-----------------

	-- can this DBA select from table?
	-- yes
	SELECT * 
	FROM sales.test_table 


	-------------------------------------------------------------------
	-- Can this DBA revoke/grant UNMASK?
	-- NO
	-------------------------------------------------------------------
	REVOKE UNMASK TO role_DBA_master;
	REVOKE UNMASK TO [User_Test_DBA];

-------------------------------------------------------------------
-- Can this DBA access objects in the HumanResources SCHEMA?
-- YES: we've granted db_datareader
-------------------------------------------------------------------
		-- tables with NO masked columns
		SELECT '[Production].[Location]'			as TableName, 'N' as Masked_Columns, * FROM [Production].[Location]
		SELECT '[Production].[Product]'				as TableName, 'N' as Masked_Columns, * FROM [Production].[Product]
		SELECT '[Production].[ProductCategory]'		as TableName, 'N' as Masked_Columns, * FROM [Production].[ProductCategory]
		SELECT '[Production].[ProductDescription]'	as TableName, 'N' as Masked_Columns, * FROM [Production].[ProductDescription]
		SELECT '[Production].[ProductReview]'		as TableName, 'N' as Masked_Columns, * FROM [Production].[ProductReview]
		SELECT '[Production].[ScrapReason]'			as TableName, 'N' as Masked_Columns, * FROM [Production].[ScrapReason]
		SELECT '[Production].[UnitMeasure]'			as TableName, 'N' as Masked_Columns, * FROM [Production].[UnitMeasure]
		SELECT '[HumanResources].[Department]'		as TableName, 'N' as Masked_Columns, * FROM HumanResources.Department
		SELECT '[HumanResources].[JobCandidate]'	as TableName, 'N' as Masked_Columns, * FROM HumanResources.JobCandidate

		-- QUERY Tables with MASKED DATA:
		SELECT TOP (50) '[Person].[Address]'			as TableName, 'Y' as Masked_Columns, AddressID,[AddressLine1],[City],[PostalCode],* FROM [Person].[Address]
		SELECT TOP (50) '[HumanResources].[Employee]'	as TableName, 'Y' as Masked_Columns, BusinessEntityID,BirthDate,NationalIDNumber,* FROM HumanResources.Employee
		SELECT TOP (50) '[Sales].[CreditCard]'			as TableName, 'Y' as Masked_Columns, [CreditCardID],[CardType],[CardNumber],[ExpMonth],[ExpYear] FROM [Sales].[CreditCard]
		SELECT TOP (10) '[Person].[PersonPhone]'		as TableName, 'Y' as Masked_Columns, [BusinessEntityID],[PhoneNumber],[PhoneNumberTypeID] FROM [Person].[PersonPhone]
		SELECT TOP (50) '[Person].[Address]'			as TableName, 'Y' as Masked_Columns, AddressID,[AddressLine2],[City],[PostalCode] FROM [Person].[Address]
		SELECT TOP (50) '[Person].[Password]'			as TableName, 'Y' as Masked_Columns, BusinessEntityID,PasswordHash,PasswordSalt FROM Person.Password
		SELECT TOP (50) '[Person].[Person]'				as TableName, 'Y' as Masked_Columns, BusinessEntityID,LastName,FirstName FROM Person.Person
		SELECT TOP (50) '[Sales].[SalesOrderHeader]'	as TableName, 'Y' as Masked_Columns, SalesOrderId,AccountNumber FROM Sales.SalesOrderHeader
		SELECT TOP (50) '[Sales].[SalesOrderHeader]'	as TableName, 'Y' as Masked_Columns, SalesOrderId,CreditCardApprovalCode,CreditCardID,CurrencyRateID FROM Sales.SalesOrderHeader
		SELECT TOP (50) '[Purchasing].[Vendor]'			as TableName, 'Y' as Masked_Columns, BusinessEntityID,AccountNumber FROM Purchasing.Vendor
		SELECT          '[Purchasing].[Vendor]'			as TableName, 'Y' as Masked_Columns, * FROM Purchasing.Vendor WHERE BusinessEntityID=1596

-------------------------------------------------------------------

-------------------------------------------------------------------
-- DDL Operations:
-------------------------------------------------------------------
DROP INDEX IF EXISTS IX_VendorID1 ON Purchasing.ProductVendor
DROP INDEX IF EXISTS IX_VendorID2 ON Purchasing.ProductVendor
DROP INDEX IF EXISTS IX_VendorID3 ON Purchasing.ProductVendor
DROP INDEX IF EXISTS IX_VendorID4 ON Purchasing.ProductVendor

SELECT * FROM Purchasing.ProductVendor

CREATE NONCLUSTERED INDEX IX_VendorID1 ON Purchasing.ProductVendor (ProductID);
CREATE NONCLUSTERED INDEX IX_VendorID2 ON Purchasing.ProductVendor (ProductID , BusinessEntityID);
CREATE NONCLUSTERED INDEX IX_VendorID3 ON Purchasing.ProductVendor (BusinessEntityID);

-- create an index, then re-create it with more columns
CREATE INDEX IX_VendorID4 ON Purchasing.ProductVendor (ProductID);
-- Rebuild and add another column
CREATE INDEX IX_VendorID4 ON Purchasing.ProductVendor (ProductID , BusinessEntityID)
  WITH (DROP_EXISTING = ON);

DROP INDEX IX_VendorID1 ON Purchasing.ProductVendor
DROP INDEX IX_VendorID2 ON Purchasing.ProductVendor
DROP INDEX IX_VendorID3 ON Purchasing.ProductVendor
DROP INDEX IX_VendorID4 ON Purchasing.ProductVendor



-- create an index on a view:
DROP VIEW IF EXISTS Sales.vOrders
GO
CREATE VIEW Sales.vOrders
  WITH SCHEMABINDING
AS
  SELECT SUM(UnitPrice * OrderQty * (1.00 - UnitPriceDiscount)) AS Revenue,
    OrderDate, ProductID, COUNT_BIG(*) AS COUNT
  FROM Sales.SalesOrderDetail AS od, Sales.SalesOrderHeader AS o
  WHERE od.SalesOrderID = o.SalesOrderID
  GROUP BY OrderDate, ProductID;
GO

-- SET NUMERIC_ROUNDABORT OFF

-- Create an index on the view
CREATE UNIQUE CLUSTERED INDEX IDX_V1
  ON Sales.vOrders (OrderDate, ProductID);
GO


-- CREATE FILTERED INDEX:
DROP INDEX IF EXISTS FIBillOfMaterialsWithEndDate ON Production.BillOfMaterials
GO
CREATE NONCLUSTERED INDEX "FIBillOfMaterialsWithEndDate"
  ON Production.BillOfMaterials (ComponentID, StartDate)
  WHERE EndDate IS NOT NULL;


-- Create, resume, pause, and abort resumable index operations
-- Execute a resumable online index create statement with MAXDOP=1
-- create table statement is located on script 030CB...sql around line 60
/*
SELECT * 
INTO test_table 
FROM sales.salesorderheader
*/

CREATE INDEX test_idx1 ON sales.test_table (SalesOrderID) WITH (ONLINE = ON, MAXDOP = 1, RESUMABLE = ON);
GO

-- Executing the same command again (see above) after an index operation was paused, resumes automatically the index create operation.

-- Execute a resumable online index creates operation with MAX_DURATION set to 240 minutes. After the time expires, the resumable index create operation is paused.
CREATE INDEX test_idx2 ON sales.test_table (OrderDate) WITH (ONLINE = ON, RESUMABLE = ON, MAX_DURATION = 240);
GO

-- Pause a running resumable online index creation
ALTER INDEX test_idx1 ON sales.test_table PAUSE;
GO
ALTER INDEX test_idx2 ON sales.test_table PAUSE;
GO

-- Resume a paused online index creation
ALTER INDEX test_idx1 ON sales.test_table RESUME;
GO
ALTER INDEX test_idx2 ON sales.test_table RESUME;
GO

-- Abort resumable index create operation which is running or paused
ALTER INDEX test_idx1 ON sales.test_table ABORT;
GO
ALTER INDEX test_idx2 ON sales.test_table ABORT;
GO
-- after the above test, drop table/indexes using script 030CB...sql around line 66-70

-------------------------------------------------------------------
-- Can this DBA create / drop tables?
-- ??
-------------------------------------------------------------------
DROP TABLE sales.test_table 
GO


--- ALTER INDEX Statements
ALTER INDEX PK_Employee_BusinessEntityID ON HumanResources.Employee REBUILD;

-- rebuild 
ALTER INDEX ALL ON Production.Product
REBUILD WITH (FILLFACTOR = 80, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

-- succeeds, as it was granted ALTER ANY CONNECTION to the login 
-- see: https://cloudblogs.microsoft.com/sqlserver/2013/08/16/improved-application-availability-during-online-operations-in-sql-server-2014/
ALTER INDEX ALL ON Production.Product
REBUILD WITH
(
    FILLFACTOR = 80,
    SORT_IN_TEMPDB = ON,
    STATISTICS_NORECOMPUTE = ON,
    ONLINE = ON ( WAIT_AT_LOW_PRIORITY ( MAX_DURATION = 4 MINUTES, ABORT_AFTER_WAIT = BLOCKERS ) ),
    DATA_COMPRESSION = ROW
);
GO

-- succeed: review clause ABORT_AFTER_WAIT = BLOCKERS
ALTER INDEX ALL ON Production.Product
REBUILD WITH
(
    FILLFACTOR = 80,
    SORT_IN_TEMPDB = ON,
    STATISTICS_NORECOMPUTE = ON,
    ONLINE = ON ,
    DATA_COMPRESSION = ROW
);
GO

-- reorg
ALTER INDEX PK_ProductPhoto_ProductPhotoID ON Production.ProductPhoto REORGANIZE WITH (LOB_COMPACTION = ON);
GO
-- disable index
ALTER INDEX AK_Employee_NationalIDNumber ON HumanResources.Employee DISABLE;
GO
-- enable index
ALTER INDEX AK_Employee_NationalIDNumber ON HumanResources.Employee REBUILD;
GO

-- change compression
ALTER INDEX AK_Employee_NationalIDNumber
ON HumanResources.Employee 
REBUILD
WITH (DATA_COMPRESSION = PAGE);
GO



-- DROP INDEXES
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ProductVendor', @level2type=N'INDEX',@level2name=N'IX_ProductVendor_BusinessEntityID'
GO
/****** Object:  Index [IX_ProductVendor_BusinessEntityID]    Script Date: 1/5/2024 1:23:49 PM ******/
DROP INDEX [IX_ProductVendor_BusinessEntityID] ON [Purchasing].[ProductVendor]
GO
/****** Object:  Index [IX_ProductVendor_BusinessEntityID]    Script Date: 1/5/2024 1:23:49 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProductVendor_BusinessEntityID] ON [Purchasing].[ProductVendor]
(
	[BusinessEntityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nonclustered index.' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ProductVendor', @level2type=N'INDEX',@level2name=N'IX_ProductVendor_BusinessEntityID'
GO

-- DROP Primary Key:
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Production', @level1type=N'TABLE',@level1name=N'TransactionHistoryArchive', @level2type=N'CONSTRAINT',@level2name=N'PK_TransactionHistoryArchive_TransactionID'
GO
/****** Object:  Index [PK_TransactionHistoryArchive_TransactionID]    Script Date: 1/5/2024 1:25:25 PM ******/
ALTER TABLE [Production].[TransactionHistoryArchive] DROP CONSTRAINT [PK_TransactionHistoryArchive_TransactionID] WITH ( ONLINE = OFF )
GO
/****** Object:  Index [PK_TransactionHistoryArchive_TransactionID]    Script Date: 1/5/2024 1:25:25 PM ******/
ALTER TABLE [Production].[TransactionHistoryArchive] ADD  CONSTRAINT [PK_TransactionHistoryArchive_TransactionID] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key (clustered) constraint' , @level0type=N'SCHEMA',@level0name=N'Production', @level1type=N'TABLE',@level1name=N'TransactionHistoryArchive', @level2type=N'CONSTRAINT',@level2name=N'PK_TransactionHistoryArchive_TransactionID'
GO


