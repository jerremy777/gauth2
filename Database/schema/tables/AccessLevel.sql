CREATE TABLE AccessLevel (
  AccessLevelId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  AppId INT NULL,
  Name NVARCHAR(255) NOT NULL,
  Active BIT NOT NULL DEFAULT 1,
  CONSTRAINT FK_AccessLevel_Application FOREIGN KEY (AppId) REFERENCES Application(AppId)
)