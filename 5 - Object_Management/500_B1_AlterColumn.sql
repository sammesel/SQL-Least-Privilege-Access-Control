----------------------------------------------------------
-- LOGIN as		DBA_With_DB_DDLAdmin
-- use password: '<P@ssw0rd-Pl@c3-H0ld3r>'
----------------------------------------------------------

-- NOTE:
-- this login is created on script [200_B1_A_Create_DBA_with_db_ddlAdmin.sql]


use SQLSecurityDemoDB
go
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO


-- alter table: add column
ALTER TABLE Sales.SalesOrderHeader ADD column_a VARCHAR(20) NULL ;
GO
EXEC sp_help 'Sales.SalesOrderHeader';
GO
-- alter table: add column with constraint UNCHECKED
ALTER TABLE Person.Person WITH NOCHECK 
ADD CONSTRAINT verify_firstname CHECK ( LEN(FirstName) > 2) 
EXEC sp_help 'Person.Person';

-- Remove a single column.
ALTER TABLE Sales.SalesOrderHeader DROP COLUMN column_a ;
GO

-- 
-- alter table: add column with constraint
ALTER TABLE Sales.SalesOrderHeader DROP COLUMN column_C ;
GO
ALTER TABLE Sales.SalesOrderHeader ADD column_c INT NULL
GO
-- changing datatype fails as this DBA doesn't have UPDATE on the table!
update Sales.SalesOrderHeader SET column_c = 11
ALTER TABLE Sales.SalesOrderHeader ALTER COLUMN column_c DECIMAL (5, 2) ;
GO
EXEC sp_help 'Sales.SalesOrderHeader';

-- works!
ALTER TABLE Sales.SalesOrderHeader ADD column_C2 VARCHAR(50) NULL
ALTER TABLE Sales.SalesOrderHeader ALTER COLUMN column_C2 varchar(50) COLLATE Latin1_General_BIN ;

-- CREATE TABLE?
-- YES
CREATE TABLE Sales.SalesOrderHeader2 (
    MemberID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    FirstName VARCHAR(100) MASKED WITH (FUNCTION = 'partial(1, "xxxxx", 1)') NULL,
    LastName VARCHAR(100) NOT NULL,
    Phone VARCHAR(12) MASKED WITH (FUNCTION = 'default()') NULL,
    Email VARCHAR(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
    DiscountCode SMALLINT MASKED WITH (FUNCTION = 'random(1, 100)') NULL
);

-- how about select-into?
-- NO: DBA does not have READ (select) on table Sales.SalesOrderHeader
SELECT 
	*
INTO
	Sales.SalesOrderHeader3
FROM 
	Sales.SalesOrderHeader

-- ALTER TABLE:
ALTER TABLE Sales.SalesOrderHeader
REBUILD WITH (DATA_COMPRESSION = PAGE) ;

ALTER TABLE Sales.SalesOrderHeader
REBUILD WITH (DATA_COMPRESSION = NONE) ;

-- LOCK ESCALATION:
ALTER TABLE Sales.SalesOrderHeader SET (LOCK_ESCALATION = AUTO) ;
GO
ALTER TABLE Sales.SalesOrderHeader SET (LOCK_ESCALATION = TABLE) ;
GO

-- INDEX maintenance:
sp_helpindex 'Sales.SalesOrderHeader'
CREATE NONCLUSTERED INDEX NC_SalesOrderHeader_TerritoryID on Sales.SalesOrderHeader (TerritoryID) INCLUDE (SalesPersonID, TotalDue)
CREATE NONCLUSTERED INDEX NC_SalesOrderHeader_ShipDate on Sales.SalesOrderHeader (ShipDate) INCLUDE (Status, ShipMethodID, TerritoryID)
-- rebuilding index
ALTER TABLE Sales.SalesOrderHeader
REBUILD WITH
(
    ONLINE = ON )

-- doesn't work: 
-- this DBA cannot kill other sessions
ALTER TABLE Sales.SalesOrderHeader
REBUILD WITH
(
    ONLINE = ON ( WAIT_AT_LOW_PRIORITY ( MAX_DURATION = 4 MINUTES,
                                         ABORT_AFTER_WAIT = BLOCKERS ) )
) ;

