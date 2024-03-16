IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccessRule]') AND type in (N'U'))
DROP TABLE AccessRule;
GO

CREATE TABLE AccessRule (
  AccessRuleId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  AppId INT NOT NULL,
  ResourceId INT NULL,
  AccessLevelId INT NOT NULL,
  RuleTypeId INT NOT NULL,
  AccessRuleValue NVARCHAR(255) NULL,
  AccessRuleSecondaryValue NVARCHAR(255) NULL,
  DurationValid INT NULL DEFAULT 1440,
  Comment NVARCHAR(100) NULL,
  ModifiedByGuid UNIQUEIDENTIFIER NULL,
  ModifiedByDisplayName NVARCHAR(255) NULL,
  ModifiedOn DATETIME NOT NULL,
  CreatedByGuid UNIQUEIDENTIFIER NULL,
  CreatedByDisplayName NVARCHAR(255) NULL,
  CreatedOn DATETIME NOT NULL,
  ValidStart DATETIME NOT NULL,
  ValidEnd DATETIME NULL,
  Active BIT NOT NULL DEFAULT 1,
  CONSTRAINT FK_AccessRule_AccessLevel FOREIGN KEY (AccessLevelId) REFERENCES AccessLevel(AccessLevelId),
  CONSTRAINT FK_AccessRule_Application FOREIGN KEY (AppId) REFERENCES Application(AppId),
  CONSTRAINT FK_AccessRule_Resource FOREIGN KEY (ResourceId) REFERENCES Resource(ResourceId),
  CONSTRAINT FK_AccessRule_AccessRuleType FOREIGN KEY (RuleTypeId) REFERENCES AccessRuleType(RuleTypeId)
)
GO
