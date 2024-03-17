IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RuleType]') AND type in (N'U'))
DROP TABLE RuleType;
GO


CREATE TABLE RuleType (
  RuleTypeId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  RuleTypeName VARCHAR(50) NOT NULL,
  Active BIT NOT NULL DEFAULT 1
)
GO
