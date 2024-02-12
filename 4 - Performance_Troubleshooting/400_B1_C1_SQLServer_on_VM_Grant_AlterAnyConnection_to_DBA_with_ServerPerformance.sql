-- https://learn.microsoft.com/en-us/sql/t-sql/language-elements/kill-transact-sql?view=sql-server-ver16#permissions
-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, @@servername, db_name()
GO
USE [master]
GO
GRANT ALTER ANY CONNECTION TO Role_TuningTeam_DMVs
GO
