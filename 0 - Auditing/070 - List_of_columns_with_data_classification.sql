-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user


-- to get a list of columns with DATA CLASSIFICATION
 SELECT 
    SCHEMA_NAME(sys.all_objects.schema_id) as SchemaName,
    sys.all_objects.name AS [TableName], sys.all_columns.name As [ColumnName],
    [Label], [Label_ID], [Information_Type], [Information_Type_ID], [Rank], [Rank_Desc]

FROM
	sys.sensitivity_classifications
	left join sys.all_objects 
		on sys.sensitivity_classifications.major_id = sys.all_objects.object_id
	left join sys.all_columns 
		on sys.sensitivity_classifications.major_id = sys.all_columns.object_id
		and sys.sensitivity_classifications.minor_id = sys.all_columns.column_id

-- list all schemas that contain columns with SENSITIVE CLASSIFICATION data
SELECT 
    DISTINCT SCHEMA_NAME(sys.all_objects.schema_id) as SchemaName
FROM
	sys.sensitivity_classifications
	left join sys.all_objects 
		on sys.sensitivity_classifications.major_id = sys.all_objects.object_id
	left join sys.all_columns 
		on sys.sensitivity_classifications.major_id = sys.all_columns.object_id
		and sys.sensitivity_classifications.minor_id = sys.all_columns.column_id
