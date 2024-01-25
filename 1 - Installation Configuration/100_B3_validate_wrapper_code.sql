----------------------------------------------------------
-- LOGIN as LOGIN_internal_principal_spconfigure
-- use password: '<password-place-holder>'
----------------------------------------------------------

SELECT USER_NAME(), SUSER_NAME() , session_user , system_user

-- tests
EXEC tools.up_sp_configure_show_advanced_options


-- tests
EXEC tools.up_sp_configure

-- tests
EXEC tools.up_sp_configure_option_value -- FAILS: missing parameter
EXEC tools.up_sp_configure_option_value 'tempdb metadata memory-optimized' -- FAILS: this is an ADVANCED sp_configure which is not part of the above code
EXEC tools.up_sp_configure_option_value 'remote admin connections'
EXEC tools.up_sp_configure_option_value 'polybase enabled'
-- tests to change current value
EXEC tools.up_sp_configure_option_value 'remote admin connections' , 1
EXEC tools.up_sp_configure_option_value 'polybase enabled',1


-- tests: tools.up_sp_configure_advanced_option_value
EXEC tools.up_sp_configure_advanced_option_value -- FAILS: missing parameter
EXEC tools.up_sp_configure_advanced_option_value 'tempdb metadata memory-optimized' 
EXEC tools.up_sp_configure_advanced_option_value 'remote admin connections'			-- FAILS: this is an ADVANCED sp_configure which is not part of the above code
EXEC tools.up_sp_configure_advanced_option_value 'polybase enabled'					-- FAILS: this is an ADVANCED sp_configure which is not part of the above code
-- tests to change current value
EXEC tools.up_sp_configure_advanced_option_value 'remote admin connections' , 1
EXEC tools.up_sp_configure_advanced_option_value 'tempdb metadata memory-optimized' ,1


































-- TEST 1B
-- INSTALLATION/CONFIGURATION: sp_configure

/*
sp_configure REQUIRES: ALTER SETTINGS 
-- held by:
--		sysadmin
--		serveradmin

*/


EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'max server memory (MB)', N'20480'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'cross db ownership chaining', N'1'
GO
EXEC sys.sp_configure N'c2 audit mode', N'1'
GO
EXEC sys.sp_configure N'max server memory (MB)', N'20480'
GO
EXEC sys.sp_configure N'common criteria compliance enabled', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'cross db ownership chaining', N'1'
GO
EXEC sys.sp_configure N'c2 audit mode', N'1'
GO
EXEC sys.sp_configure N'max server memory (MB)', N'20480'
GO
EXEC sys.sp_configure N'common criteria compliance enabled', N'1'
GO
RECONFIGURE
GO
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
GO
USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'AuditLevel', REG_DWORD, 3
GO
EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'cross db ownership chaining', N'1'
GO
EXEC sys.sp_configure N'c2 audit mode', N'1'
GO
EXEC sys.sp_configure N'user options', N'30654'
GO
EXEC sys.sp_configure N'max server memory (MB)', N'20480'
GO
EXEC sys.sp_configure N'common criteria compliance enabled', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'fill factor (%)', N'80'
GO
EXEC sys.sp_configure N'cross db ownership chaining', N'1'
GO
EXEC sys.sp_configure N'c2 audit mode', N'1'
GO
EXEC sys.sp_configure N'user options', N'30654'
GO
EXEC sys.sp_configure N'max server memory (MB)', N'20480'
GO
EXEC sys.sp_configure N'common criteria compliance enabled', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'fill factor (%)', N'80'
GO
EXEC sys.sp_configure N'cross db ownership chaining', N'1'
GO
EXEC sys.sp_configure N'c2 audit mode', N'1'
GO
EXEC sys.sp_configure N'user options', N'30654'
GO
EXEC sys.sp_configure N'cost threshold for parallelism', N'50'
GO
EXEC sys.sp_configure N'max degree of parallelism', N'2'
GO
EXEC sys.sp_configure N'max server memory (MB)', N'20480'
GO
EXEC sys.sp_configure N'common criteria compliance enabled', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
GO
