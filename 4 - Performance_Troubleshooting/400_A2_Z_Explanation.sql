-- To execute a SQL Server system procedure, you need to have the EXECUTE permission 
--		on the system object that represents the procedure1. Some system procedures 
--		may also require additional permissions, such as CONTROL SERVER or ALTER on the schema2. 
--		You can use the sys.fn_my_permissions function to list all the permissions of 
--		a user or login on a specific object3.

-- For example, to check the permissions of the current user on the sp_who system procedure, 
--		you can run this query:
-- 

SELECT * FROM sys.fn_my_permissions('sp_who', 'OBJECT');
SELECT * FROM sys.fn_my_permissions('sys.sp_readerrorlog', 'OBJECT');
SELECT * FROM sys.fn_my_permissions('sys.sp_readerrorlog', 'OBJECT');

SELECT * FROM fn_my_permissions(NULL, 'SERVER');  
SELECT * FROM fn_my_permissions('sys.sp_readerrorlog', 'SERVER');  
