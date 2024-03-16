namespace GAuth2.Model;
/*
CREATE TABLE [Resource] (
  ResourceId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  AppId INT NOT NULL,
  ResourceKey VARCHAR(50) NOT NULL,
  ResourceValue INT NULL,
  ParentResourceId INT NULL,
  ResourceDisplayName NVARCHAR(255) NULL,
  CreatedByGuid UNIQUEIDENTIFIER NULL,
  CreatedByDisplayName NVARCHAR(255) NULL,
  CreatedOn DATETIME NOT NULL,
  ModifiedByGuid UNIQUEIDENTIFIER NULL,
  ModifiedByDisplayName NVARCHAR(255) NULL,
  ModifiedOn DATETIME NOT NULL,
  ValidStart DATETIME NOT NULL,
  ValidEnd DATETIME NULL,
  Active BIT NOT NULL DEFAULT 1,
  CONSTRAINT FK_Resource_Application FOREIGN KEY (AppId) REFERENCES Application(AppId),
  CONSTRAINT FK_Resource_ParentResource FOREIGN KEY (ParentResourceId) REFERENCES [Resource](ResourceId),
  CONSTRAINT UQ_Resource_AppId_ResourceKey_ParentResourceId UNIQUE (AppId, ResourceKey, ParentResourceId),
  CONSTRAINT CK_Resource_ParentResourceKey CHECK (ParentResourceId IS NOT NULL OR ResourceKey IS NOT NULL)
)
*/
public class Resource : GenericRecord
{
  public int ResourceId { get; set; }
  public int AppId { get; set; }
  public string ResourceKey { get; set; } = "";
  public int? ResourceValue { get; set; }
  public int? ParentResourceId { get; set; }
  public string ResourceDisplayName { get; set; } = "";
}
