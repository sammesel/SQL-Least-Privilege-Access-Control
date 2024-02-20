-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()

---------------------- ADD [Login_Test_DBA]  to SQLSecurityDemoDB ---------------------- 
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO

--ALTER ROLE [db_datareader] ADD MEMBER server_role_DBA_master
--GO

--ALTER ROLE [db_datareader] ADD MEMBER role_DBA_master
--GO

--use master

--USE SQLSecurityDemoDB

--GRANT SELECT ON DATABASE::SQLSecurityDemoDB TO server_role_DBA_master
-- GRANT SELECT ON DATABASE::SQLSecurityDemoDB TO [user_Test_DBA]
-- GO
ALTER ROLE [db_datareader] ADD MEMBER Role_DBA_Master
GO


-- REVOKE SELECT ON DATABASE::SQLSecurityDemoDB TO [user_Test_DBA]
-- GO
-- ALTER ROLE [db_datareader] DROP MEMBER [user_Test_DBA]
-- GO



SELECT    
	 roles.principal_id                            AS RolePrincipalID
    ,roles.name                                    AS RolePrincipalName
    ,database_role_members.member_principal_id    AS MemberPrincipalID
    ,members.name                                AS MemberPrincipalName
FROM sys.database_role_members AS database_role_members  
	JOIN sys.database_principals AS roles  
		ON database_role_members.role_principal_id = roles.principal_id  
	JOIN sys.database_principals AS members  
		ON database_role_members.member_principal_id = members.principal_id  
WHERE
	members.name = 'role_DBA_master'
	AND
	roles.name = 'db_datareader'

GO
