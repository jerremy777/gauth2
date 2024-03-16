IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CachedUser]') AND type in (N'U'))
DROP TABLE CachedUser;
GO

CREATE TABLE CachedUser (
  CachedUserId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  AccessRuleId INT NOT NULL,
  DisplayName NVARCHAR(255) NULL,
  UserGuid UNIQUEIDENTIFIER NOT NULL,
  CreatedOn DATETIME NOT NULL,
  LastRefresh DATETIME NOT NULL,
  LastAccess DATETIME NOT NULL,
  LastAccessedResourceId INT NULL,
  Comment NVARCHAR(100) NULL,
  Active BIT NOT NULL DEFAULT 1,
  CONSTRAINT FK_CachedUser_AccessRule FOREIGN KEY (AccessRuleId) REFERENCES AccessRule(AccessRuleId),
  CONSTRAINT FK_CachedUser_Resource FOREIGN KEY (LastAccessedResourceId) REFERENCES [Resource](ResourceId)
)
GO