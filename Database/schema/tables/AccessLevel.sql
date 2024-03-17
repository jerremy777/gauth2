IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccessLevel]') AND type in (N'U'))
DROP TABLE AccessLevel;
GO


CREATE TABLE AccessLevel (
  AccessLevelId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  AppId INT NULL,
  AccessLevelName NVARCHAR(255) NOT NULL,
  Active BIT NOT NULL DEFAULT 1
)
GO


ALTER TABLE AccessLevel
ADD CONSTRAINT FK_AccessLevel_Application FOREIGN KEY (AppId) REFERENCES Application(AppId)
GO