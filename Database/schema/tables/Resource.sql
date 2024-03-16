/*
Resource table is used to store the resources of the application.
Resource is a logical entity that can be used to represent any object in the application.

ResourceKey is a unique key that is used to identify the resource.
It can be used hierarchically with a parent resource.

For example:
- app_1/resource_1_key/resource_1_value/child_resource_1_key/child_resource_1_value
- app_1/resource_1_key/resource_1_value/child_resource_2_key/child_resource_2_value


Top level resources are the resources that have no parent resource. Top level
resources MUST have a unique ResourceKey within the application.

To get a resource and all of its parent resource recursively, use the following query:
WITH RecursiveResources AS (
    SELECT r.*
    FROM [Resource] r
    WHERE r.ResourceId = @ResourceId -- Replace @ResourceId with the specific ResourceId you want to query for
    UNION ALL
    SELECT r.*
    FROM [Resource] r
    INNER JOIN RecursiveResources rr ON rr.ParentResourceId = r.ResourceId
)
SELECT * FROM RecursiveResources;
*/

ALTER TABLE AccessRule
DROP CONSTRAINT FK_AccessRule_Resource;
GO

ALTER TABLE CachedUser
DROP CONSTRAINT FK_CachedUser_Resource;

DROP TABLE [Resource];
GO

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
GO

ALTER TABLE AccessRule
ADD CONSTRAINT FK_AccessRule_Resource FOREIGN KEY (ResourceId) REFERENCES [Resource](ResourceId);
GO

ALTER TABLE CachedUser
ADD CONSTRAINT FK_CachedUser_Resource FOREIGN KEY (LastAccessedResourceId) REFERENCES [Resource](ResourceId);
GO
