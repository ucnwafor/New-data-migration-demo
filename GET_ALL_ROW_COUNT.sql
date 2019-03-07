-- To get the row counts for all the tables in the database--
---Make sure this code works
SET NOCOUNT ON 

DECLARE @SourceDB VARCHAR(100) 
DECLARE @SourceSchema VARCHAR(100) 
DECLARE @SourceTableName VARCHAR(100)

DECLARE @TargetDB VARCHAR(100) -----name of Oracle Linked Server
DECLARE @TargetSchema VARCHAR(100) ---Owner name
DECLARE @TargetTableName VARCHAR(100)
 
DECLARE @SqlCommand VARCHAR(8000) 

SET @TargetDB = 'ADVENTUREWORKS2014' 

                        
DECLARE TABLE_CURSOR CURSOR  FOR 
SELECT [Database Name]
      ,[Source Schema]
      ,[Source Table Name]
      ,[Target Schema/Owner]
      ,[Target Table Name]
FROM [MIGRATION_TESTING].[dbo].[RowCounts_Comparison] 
          
OPEN TABLE_CURSOR 

FETCH NEXT FROM TABLE_CURSOR 
INTO @SourceDB
    ,@SourceSchema
	,@SourceTableName
	,@TargetSchema
	,@TargetTableName 

WHILE @@FETCH_STATUS = 0 
      BEGIN 
        SET @SqlCommand = 'UPDATE [MIGRATION_TESTING].[dbo].[RowCounts_Comparison]
       SET [Source Row Count]=(SELECT COUNT(*) FROM '+@SourceDB+'.'+@SourceSchema+'.'+@SourceTableName+')
      ,[Target Row Count]=(SELECT COUNT(*) FROM '+@TargetDB+'..'+UPPER(@TargetSchema)+'.'+UPPER(@TargetTableName)+')
	   WHERE [Database Name]='''+@SourceDB+''' AND [Source Schema]='''+@SourceSchema+''' AND [Source Table Name]='''+@SourceTableName+''''
		
		
    ---PRINT @sqlCommand
   EXEC (@sqlCommand) 
    
FETCH NEXT FROM TABLE_CURSOR 
INTO @SourceDB
    ,@SourceSchema
	,@SourceTableName
	,@TargetSchema
	,@TargetTableName 
 
  END 
   
CLOSE TABLE_CURSOR 
DEALLOCATE TABLE_CURSOR 