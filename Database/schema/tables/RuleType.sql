IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AccessRule_RuleType]'))
BEGIN
  ALTER TABLE AccessRule
  DROP CONSTRAINT FK_AccessRule_RuleType;
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RuleType]') AND type in (N'U'))
DROP TABLE RuleType;
GO


CREATE TABLE RuleType (
  RuleTypeId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  RuleTypeName VARCHAR(50) NOT NULL,
  Active BIT NOT NULL DEFAULT 1
)
GO


-- recreate the foreign key
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccessRule]') AND type in (N'U'))
BEGIN
  ALTER TABLE AccessRule
  ADD CONSTRAINT FK_AccessRule_RuleType FOREIGN KEY (RuleTypeId) REFERENCES RuleType(RuleTypeId);
END