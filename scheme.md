## Site Structure:

(Created Manually)

```json
[
  {
    "AppId": 1,
    "Name": "Roster",
    "Pages": [
      {
        "PageId": 1,
        "Name": "Home",
        "Path": "App1/",
      },
      {
        "PageId": 2,
        "Name": "Roster",
        "Path": "App1/rosters",
        "Pages": [
          {
            "PageId": 3,
            "Name": "Finance Rosters",
            "Path": "App1/rosters/finance",
            "Pages": [
              {
                "PageId": 4,
                "Name": "Finance Roster 1",
                "Path": "App1/rosters/finance/:id",
              },
              {
                "PageId": 5,
                "Name": "Finance Roster 2",
                "Path": "App1/rosters/finance/:id",
              },
            ]
          },
          {
            "PageId": 6,
            "Name": "HR Rosters",
            "Path": "App1/rosters/hr",
            "Pages": [
              {
                "PageId": 7,
                "Name": "HR Roster 1",
                "Path": "App1/rosters/hr/:id",
              },
              {
                "PageId": 8,
                "Name": "HR Roster 2",
                "Path": "App1/rosters/hr/:id",
              },
            ]
          },
        ]
      },
    ]
  },
  {
    "AppId": 2,
    "Name": "Leave",
    "Pages": [
      {
        "PageId": 9,
        "Name": "Home",
        "Path": "App2/",
      },
      {
        "PageId": 10,
        "Name": "Calendars",
        "Path": "App2/calendars",
        "Pages": [
          {
            "PageId": 11,
            "Name": "Finance Calendars",
            "Path": "App2/calendars/finance",
            "Pages": [
              {
                "PageId": 12,
                "Name": "Finance Project 1",
                "Path": "App2/calendars/finance/:id",
                "Pages": [
                  {
                    "PageId": 13,
                    "Name": "Finance Project 1 - Task 1",
                    "Path": "App2/calendars/finance/:id/:id",
                  },
                  {
                    "PageId": 14,
                    "Name": "Finance Project 1 - Task 2",
                    "Path": "App2/calendars/finance/:id/:id",
                  },
                ]
              },
              {
                "PageId": 15,
                "Name": "Finance Project 2",
                "Path": "App2/calendars/finance/:id",
              },
            ]
          },
        ]
      }
    ]
  }
]
```
## SQL Server Schema:

**Prompt:** Given the above data structure, generate the following:
SQL Server Schema that can be used to store Access Rules for each page
There should be 3 levels of access: Read, Write, and Admin
Access should be inherited from parent pages so that if a user has Admin access to a parent page,
they will also have Admin access to all child pages, but if a user
has Admin access to a child page, they will not have Admin access to the parent page.
Access Rules should be stored in a table called AccessRules.
Access Rules should define how a user can access a page. Access can be defined by a combination of
Access Schemas: UserGuid, DepartmentId, ManagerId, ADGroup, AllEmployees, and/or RoleId by default.
It should be possible to create custom Access Schemas.
When a user's access is checked against an Access Rule, the user should be
entered into a CachedUser table with the AccessRuleId and the date/time the user was entered.
Access Rules should have an expiration time in minutes. If a user's CachedUser record is older than
the expiration time, the user's entry in the CachedUser table should be set to Active = 0 and
the user's access should be checked against the Access Rule again.
If a user is in the CachedUser table and Active = 1, the user should be allowed access to the page
without checking the Access Rules.
AccessRules should have a ValidStart and ValidEnd date/time which indicate if the AccessRule is
active or not. If an AccessRule is modified, the row should be updated with a new ValidEnd date/time,
a new row should be inserted with the new ValidStart date/time, and the new row ModifiedBy
column should be set to the user who modified the AccessRule.
It should be possible to add multiple Applications to the schema.
Applications should be able to have different AccessRules and AccessSchemes.

**Result:**

```sql
CREATE TABLE Application (
  AppId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  Name NVARCHAR(255) NOT NULL,
  CreatedByGuid UNIQUEIDENTIFIER NULL,
  CreatedByDisplayName NVARCHAR(255) NULL,
  CreatedOn DATETIME NOT NULL,
  ModifiedByGuid UNIQUEIDENTIFIER NULL,
  ModifiedByDisplayName NVARCHAR(255) NULL,
  ModifiedOn DATETIME NOT NULL,
  ValidStart DATETIME NOT NULL,
  ValidEnd DATETIME NULL,
  Active BIT NOT NULL DEFAULT 1
)

-- Enforce that top level resources (those with null parent resourceid) have a Non null ResourceKey
CREATE TABLE Resource (
  ResourceId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  AppId INT NOT NULL,
  ResourceKey VARCHAR(50) NULL,
  ResourceDisplayName NVARCHAR(255) NULL,
  ParentResourceId INT NULL,
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
  CONSTRAINT FK_Resource_ParentResource FOREIGN KEY (ParentResourceId) REFERENCES Resource(ResourceId),
  CONSTRAINT UQ_Resource_AppId_ResourceKey UNIQUE (AppId, ResourceKey),
  CONSTRAINT CK_Resource_ParentResourceKey CHECK (ParentResourceId IS NOT NULL OR ResourceKey IS NOT NULL)  
)

CREATE TABLE AccessScheme (
  AccessSchemeId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  AppId INT NULL,
  Name NVARCHAR(255) NOT NULL,
  Active BIT NOT NULL DEFAULT 1,
  CONSTRAINT FK_AccessScheme_Application FOREIGN KEY (AppId) REFERENCES Application(AppId)
)

CREATE TABLE AccessLevel (
  AccessLevelId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  AppId INT NULL,
  Name NVARCHAR(255) NOT NULL,
  Active BIT NOT NULL DEFAULT 1,
  CONSTRAINT FK_AccessLevel_Application FOREIGN KEY (AppId) REFERENCES Application(AppId)
)

CREATE TABLE AccessRule (
  AccessRuleId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  AppId INT NOT NULL,
  ResourcePath VARCHAR(MAX) NULL,
  ResourceId INT NULL,
  AccessLevelId INT NOT NULL,
  AccessSchemeId INT NOT NULL,
  AccessSchemeValue NVARCHAR(255) NULL,
  AccessSchemeSecondaryValue NVARCHAR(255) NULL,
  DurationValid INT NULL DEFAULT 1440,
  ValidStart DATETIME NOT NULL,
  ValidEnd DATETIME NULL,
  ModifiedByGuid UNIQUEIDENTIFIER NULL,
  ModifiedByDisplayName NVARCHAR(255) NULL,
  ModifiedOn DATETIME NOT NULL,
  CreatedByGuid UNIQUEIDENTIFIER NULL,
  CreatedByDisplayName NVARCHAR(255) NULL,
  CreatedOn DATETIME NOT NULL,
  Comment NVARCHAR(100) NULL,
  Active BIT NOT NULL DEFAULT 1,
  CONSTRAINT FK_AccessRule_AccessLevel FOREIGN KEY (AccessLevelId) REFERENCES AccessLevel(AccessLevelId),
  CONSTRAINT FK_AccessRule_AccessScheme FOREIGN KEY (AccessSchemeId) REFERENCES AccessScheme(AccessSchemeId),
  CONSTRAINT FK_AccessRule_Application FOREIGN KEY (AppId) REFERENCES Application(AppId)
)

-- Create a unique constraint for UserGuid and AccessRuleId
CREATE TABLE CachedUser (
  CachedUserId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  AccessRuleId INT NOT NULL,
  UserGuid UNIQUEIDENTIFIER NOT NULL,
  CreatedOn DATETIME NOT NULL,
  LastRefresh DATETIME NOT NULL,
  LastAccess DATETIME NOT NULL,
  LastAccessedResourcePath VARCHAR(255) NULL,
  LastAccessedResourceId INT NULL,
  Comment NVARCHAR(100) NULL,
  Active BIT NOT NULL DEFAULT 1,
  CONSTRAINT FK_CachedUser_AccessRule FOREIGN KEY (AccessRuleId) REFERENCES AccessRule(AccessRuleId),
)
GO

-- Update CachedUser table with unqiue contraint for UserGuid and AccessRuleId
ALTER TABLE CachedUser
  ADD CONSTRAINT UQ_CachedUser_UserGuid_AccessRuleId UNIQUE (UserGuid, AccessRuleId)

GO

-- Set up views to make it easier to query the data
CREATE VIEW [AccessRuleView]
AS
SELECT
  AR.AccessRuleId,
  AR.AppId,
  APP.Name AS ApplicationName,
  AR.AccessLevelId,
  AL.Name AS AccessLevelName,
  AR.AccessSchemeId,
  SCH.Name AS AccessSchemeName,
  AR.ResourcePath,
  AR.ResourceId,
  AR.AccessSchemeValue,
  AR.AccessSchemeSecondaryValue,
  AR.DurationValid,
  AR.ValidStart,
  AR.ValidEnd,
  AR.ModifiedByGuid,
  AR.ModifiedByDisplayName,
  AR.ModifiedOn,
  AR.CreatedByGuid,
  AR.CreatedByDisplayName,
  AR.CreatedOn,
  AR.Comment,
  AR.Active,
FROM AccessRule AR
INNER JOIN Application APP ON AR.AppId = APP.AppId
INNER JOIN AccessLevel AL ON AR.AccessLevelId = AL.AccessLevelId
INNER JOIN AccessScheme SCH ON AR.AccessSchemeId = SCH.AccessSchemeId

GO

-- Cached user view
CREATE VIEW [CachedUserView]
AS
SELECT
  CU.CachedUserId,
  AR.AccessRuleId,
  CASE WHEN CU.LastRefresh > DATEADD (MINUTE, -AR.DurationValid, GETUTCDATE())
    THEN 0
    ELSE 1
  END AS AccessExpired,
  APP.AppId,
  APP.Name AS ApplicationName,
  AR.AccessLevelId,
  AL.Name AS AccessLevelName,
  AR.AccessSchemeId,
  SCH.Name AS AccessSchemeName,
  CU.UserGuid,
  CU.CreatedOn,
  CU.LastRefresh,
  CU.LastAccess,
  CU.LastAccessedResourcePath,
  CU.LastAccessedResourceId,
  CU.Comment,
  CU.Active
FROM CachedUser CU
INNER JOIN AccessRule AR ON CU.AccessRuleId = AR.AccessRuleId
INNER JOIN [Application] APP ON AR.AppId = APP.AppId
INNER JOIN AccessLevel AL ON AR.AccessLevelId = AL.AccessLevelId
INNER JOIN AccessScheme SCH ON AR.AccessSchemeId = SCH.AccessSchemeId

GO

INSERT INTO [Application] (Name, CreatedOn, ModifiedOn, ValidStart, Active)
VALUES ('Roster', GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), 1)

INSERT INTO [AccessScheme] (Name, Active)
VALUES
  ('All Gilead', 1),
  ('Department', 1),
  ('Manager', 1),
  ('AD Group', 1),
  ('Individual', 1),
  ('Roster Grouping', 1),
  ('Roster Schema', 1)

INSERT INTO [AccessLevel] (Name, Active)
VALUES
  ('Read', 1),
  ('Write', 1),
  ('Admin', 1)

GO

-- Add the first AccessRule for the Roster application: All Gilead users have Read access to all pages.
INSERT INTO [AccessRule] (AppId, AccessLevelId, AccessSchemeId, AccessSchemeValue, ValidStart, ValidEnd, CreatedOn, ModifiedOn, Active)
VALUES (1, 1, 1, 'All Gilead', GETUTCDATE(), NULL, GETUTCDATE(), GETUTCDATE(), 1)

-- Add rule for testing: User 'jstroman' has admin access to the entire Roster application.
INSERT INTO [AccessRule] (AppId, AccessLevelId, AccessSchemeId, AccessSchemeValue, ValidStart, ValidEnd, CreatedOn, ModifiedOn, Active)
VALUES (1, 3, 5, 'jstroman', GETUTCDATE(), NULL, GETUTCDATE(), GETUTCDATE(), 1)

-- Add rule for testing: AD Group "#DevOps Systems & Process - CS" has admin access to the entire Roster application.
INSERT INTO [AccessRule] (AppId, AccessLevelId, AccessSchemeId, AccessSchemeValue, ValidStart, ValidEnd, CreatedOn, ModifiedOn, Active)
VALUES (1, 3, 4, '#DevOps Systems & Process - CS', GETUTCDATE(), NULL, GETUTCDATE(), GETUTCDATE(), 1)
```

**Prompt:**
- AccessSchemes with `NULL` AppId are global and can be used by any application.
- AccessLevels with `NULL` AppId are global and can be used by any application.
- The API should have several endpoints for checking access:
  - Check if a user has access to a page given the AppId and a ResourcePath: `api/application/{appId}/user/{username}/access/{accessLevelId}/path/{resourcePath}`
  - Check if a user has access to a page given the AppId and a ResourceId: `api/application/{appId}/user/{username}/access/{accessLevelId}/resource/{resourceId}`
  - Check if a user has access to a page given the AppId, ResourcePath, and ResourceId: `api/application/{appId}/user/{username}/access/{accessLevelId}/resource/{resourceId}/path/{resourcePath}`

For example, to check if a user has ADMIN access to the Finance Rosters page in the Roster application, the following endpoint would be used: `api/application/1/user/{username}/access/3/path/App1/rosters/finance`

Given the above data struture and SQL server schema, come up with an example of how you would
check if a user has 'ADMIN' access to Finance Project 1 - Task 1 in the Leave application.
Include the API endpoint that would be used to check the user's access.
Include the controller and method that would be used to check the user's access in C#.
Include the SQL Query that would be used to check the user's access.

**Result:**

```csharp
// Controller
[HttpGet]
[Route("api/application/{appId}/user/{username}/access/{accessLevelId}/path/{resourcePath}")]
public async Task<IActionResult> CheckAccessByPath(int appId, string username, int accessLevelId, string resourcePath)
{
    var user = await _userService.GetUser(username);
    if (user == null)
    {
        return NotFound();
    }

    var access = await _accessService.CheckAccessByPath(appId, user.UserGuid, accessLevelId, resourcePath);
    return Ok(access);
}

// Service
public async Task<bool> CheckAccessByPath(int appId, Guid userGuid, int accessLevelId, string resourcePath)
{
    var access = await _accessRepository.CheckAccessByPath(appId, userGuid, accessLevelId, resourcePath);
    return access;
}

// Repository
// Use a call to a stored procedure to check the user's access
public async Task<bool> CheckAccessByPath(int appId, Guid userGuid, int accessLevelId, string resourcePath)
{
    var access = await _context.CheckAccessByPathAndResourceId(appId, userGuid, accessLevelId, resourcePath);

    return access;
}
```

## Stored proedures/Functions:

### Checking Access

**Prompt:** 
Stored procedure for checking access by path and resource id:

**Result:**

```sql
CREATE PROCEDURE [dbo].[CheckUserAccessByPathAndResource]
/**
Checks if the given user has access to the given resource path and resource ID.
First checks if there is an unexpired AccessRule for the user in the CachedUser table.
If there is an unexpired AccessRule for the user in the CachedUser table for the given 
resource path and resource ID, then return 1.
**/
  @UserGuid UNIQUEIDENTIFIER,
  @AccessLevelId INT,
  @AppId INT,
  @ResourcePath VARCHAR(MAX),
  @ResourceId INT
AS
BEGIN
  DECLARE @Access BIT = 0

  -- Check if the user has access to the specific Resource PATH and ID
  IF EXISTS (
    SELECT 1
    FROM CachedUser CU
    INNER JOIN AccessRule AR ON CU.AccessRuleId = AR.AccessRuleId
    WHERE CU.UserGuid = @UserGuid
      AND CU.AppId = @AppId
      AND AR.Active = 1
      AND AR.AccessLevelId = @AccessLevelId
      AND AR.ResourcePath = @ResourcePath
      AND AR.ResourceId = @ResourceId
      AND CU.LastRefresh > DATEADD(MINUTE, -AR.DurationValid, GETUTCDATE())
  )
  BEGIN
    SET @Access = 1
  END
  ELSE
  BEGIN
    -- Check if the user has inherited access from the given Resource PATH
    IF EXISTS (
      SELECT 1
      FROM CachedUser CU
      INNER JOIN AccessRule AR ON CU.AccessRuleId = AR.AccessRuleId
      WHERE CU.UserGuid = @UserGuid
        AND CU.AppId = @AppId
        AND AR.Active = 1
        AND AR.AccessLevelId = @AccessLevelId
        AND AR.ResourcePath = @ResourcePath
        AND AR.ResourceId IS NULL
        AND CU.LastRefresh > DATEADD(MINUTE, -AR.DurationValid, GETUTCDATE())
    )
    BEGIN
      SET @Access = 1
    END
    ELSE
    BEGIN
      -- Check if the user has inherited access from the application
      IF EXISTS (
        SELECT 1
        FROM CachedUser CU
        INNER JOIN AccessRule AR ON CU.AccessRuleId = AR.AccessRuleId
        WHERE CU.UserGuid = @UserGuid
          AND CU.AppId = @AppId
          AND AR.Active = 1
          AND AR.AccessLevelId = @AccessLevelId
          AND AR.ResourcePath IS NULL
          AND AR.ResourceId IS NULL
          AND CU.LastRefresh > DATEADD(MINUTE, -AR.DurationValid, GETUTCDATE())
      )
      BEGIN
        SET @Access = 1
      END
    END
  END

  SELECT @Access
END
```

**Prompt**: 
Stored Procedure for getting the AccessRules for a given user who is not in the CachedUser table yet
for the given application, resource path, and resource id. 
This procedure should be called when a user attempts to access a page that they have not passed the AccessRules for yet, or when a user's CachedUser record has expired.
It should return all of the AccessRules that would need to be passed in order for the user to have access to the page and resource. For example, if there is a rule that says all users can access the application, but there is also a rule that says only users in the Finance department can access the Finance Rosters page, the procedure should return rules with NULL ResourcePath and NULL ResourceId and rules with ResourcePath = 'App1/rosters/finance' and ResourceId = NULL.

```sql
CREATE PROCEDURE [dbo].[AccessRule_GetByLevelAppPathResource]
/**
Gets the AccessRules for the given AccessLevel, Application, ResourcePath, and ResourceId.
Theses rules are used to determine if a user has the given access level to a page/resource
A user is granted access to the page/resource is they pass any of the AccessRules.
Once a user passes an AccessRule, they are entered into the CachedUser table with the 
AccessRuleId and the date/time they were entered.
**/
  @AccessLevelId INT,
  @AppId INT,
  @ResourcePath VARCHAR(MAX),
  @ResourceId INT
AS
BEGIN
  SELECT [AccessRuleId]
    ,[ApplicationName]
    ,[AccessLevelName]
    ,[AccessSchemeName]
    ,[AppId]
    ,[ResourcePath]
    ,[ResourceId]
    ,[AccessLevelId]
    ,[AccessSchemeId]
    ,[AccessSchemeValue]
    ,[AccessSchemeSecondaryValue]
    ,[DurationValid]
    ,[ValidStart]
    ,[ValidEnd]
    ,[ModifiedByGuid]
    ,[ModifiedByDisplayName]
    ,[ModifiedOn]
    ,[CreatedByGuid]
    ,[CreatedByDisplayName]
    ,[CreatedOn]
    ,[Comment]
    ,[Active]
  FROM AccessRuleView
  WHERE (AppId = @AppId
    AND ResourcePath = @ResourcePath
    AND ResourceId = @ResourceId)
  OR (AppId = @AppId
    AND ResourcePath = @ResourcePath
    AND ResourceId IS NULL)
  OR (AppId = @AppId
    AND ResourcePath IS NULL
    AND ResourceId IS NULL)
  AND AccessLevelId = @AccessLevelId
  AND Active = 1
  ORDER BY DurationValid DESC -- Check the longest enduring rule first
END
```

**Prompt**:
Stored procedure that takes a UserGuid, AccessLevel, AppId, ResourcePath, 
and ResourceId and returns any non-expired AccessRules that the user has passed. 
If the user has not passed any AccessRules, then return all of the AccessRules 
that the user has not passed yet ordered by DurationValid descending.

**Result:**
```sql
CREATE PROCEDURE [dbo].[GetUserAccessRulesForLevelAppPathResource]
/**
Gets the AccessRules that the given user has passed.
If the user has not passed any AccessRules, then return
all of the AccessRules that the user would need to pass
in order to have the given access level to the given resource.
**/
  @UserGuid UNIQUEIDENTIFIER,
  @AccessLevelId INT,
  @AppId INT,
  @ResourcePath VARCHAR(MAX),
  @ResourceId INT
AS
BEGIN
  SELECT ARV.[AccessRuleId]
    ,CUV.[Expired]
    ,ARV.[ApplicationName]
    ,ARV.[AccessLevelName]
    ,ARV.[AccessSchemeName]
    ,ARV.[AppId]
    ,ARV.[ResourcePath]
    ,ARV.[ResourceId]
    ,ARV.[AccessLevelId]
    ,ARV.[AccessSchemeId]
    ,ARV.[AccessSchemeValue]
    ,ARV.[AccessSchemeSecondaryValue]
    ,ARV.[DurationValid]
    ,ARV.[ValidStart]
    ,ARV.[ValidEnd]
    ,ARV.[ModifiedByGuid]
    ,ARV.[ModifiedByDisplayName]
    ,ARV.[ModifiedOn]
    ,ARV.[CreatedByGuid]
    ,ARV.[CreatedByDisplayName]
    ,ARV.[CreatedOn]
    ,ARV.[Comment]
    ,ARV.[Active]
  FROM AccessRuleView ARV
  INNER JOIN CachedUserView CUV ON ARV.AccessRuleId = CUV.AccessRuleId
  WHERE CUV.UserGuid = @UserGuid
    AND CUV.AccessLevelId = @AccessLevelId
    AND ARV.AppId = @AppId
    AND (
      (ARV.ResourcePath = @ResourcePath AND ARV.ResourceId = @ResourceId)
      OR (ARV.ResourcePath = @ResourcePath AND ARV.ResourceId IS NULL)
      OR (ARV.ResourcePath IS NULL AND ARV.ResourceId IS NULL)
    )
  UNION
  SELECT ARV.[AccessRuleId]
    ,1 AS Expired
    ,ARV.[ApplicationName]
    ,ARV.[AccessLevelName]
    ,ARV.[AccessSchemeName]
    ,ARV.[AppId]
    ,ARV.[ResourcePath]
    ,ARV.[ResourceId]
    ,ARV.[AccessLevelId]
    ,ARV.[AccessSchemeId]
    ,ARV.[AccessSchemeValue]
    ,ARV.[AccessSchemeSecondaryValue]
    ,ARV.[DurationValid]
    ,ARV.[ValidStart]
    ,ARV.[ValidEnd]
    ,ARV.[ModifiedByGuid]
    ,ARV.[ModifiedByDisplayName]
    ,ARV.[ModifiedOn]
    ,ARV.[CreatedByGuid]
    ,ARV.[CreatedByDisplayName]
    ,ARV.[CreatedOn]
    ,ARV.[Comment]
    ,ARV.[Active]
  FROM AccessRuleView ARV
  WHERE ARV.AccessLevelId = @AccessLevelId
    AND ARV.AppId = @AppId
    AND (
      (ARV.ResourcePath = @ResourcePath AND ARV.ResourceId = @ResourceId)
      OR (ARV.ResourcePath = @ResourcePath AND ARV.ResourceId IS NULL)
      OR (ARV.ResourcePath IS NULL AND ARV.ResourceId IS NULL)
    )
    AND ARV.AccessRuleId NOT IN (
      SELECT AccessRuleId
      FROM CachedUserView
      WHERE UserGuid = @UserGuid
        AND AppId = @AppId
        AND AccessLevelId = @AccessLevelId
    )
  ORDER BY Expired ASC, DurationValid DESC
END
```

**Prompt**: When an AccessRule that has not yet been satisfied by the user is sent
to the server, the server will apply logic determined by the AccessScheme
to determine if the user has satisfied the AccessRule. If the user has
satisfied the AccessRule, the user will be entered into the CachedUser
table with the AccessRuleId and the date/time the user was entered.

The following stored procedure should be used to enter the user into the
CachedUser table.

**Result:**
```sql
CREATE PROCEDURE [dbo].[CachedUser_Upsert]
/**
Upserts the given user into the CachedUser table for the given AccessRuleId.
Update the LastAccessed columns if the user is already in the CachedUser table.
Update the LastRefresh if the CachedUser is expired.
Insert the user if the user is not already in the CachedUser table.
**/
  @UserGuid UNIQUEIDENTIFIER,
  @AccessRuleId INT,
  @ResourcePath VARCHAR(MAX),
  @ResourceId INT
AS
BEGIN
  -- Check for expired CachedUser records
  IF EXISTS (
    SELECT 1
    FROM CachedUserView
    WHERE UserGuid = @UserGuid
      AND AccessRuleId = @AccessRuleId
      AND Expired = 1
  )
  BEGIN
    UPDATE CachedUser
    SET LastAccess = GETUTCDATE(),
      LastRefresh = GETUTCDATE(),
      LastAccessedResourcePath = @ResourcePath,
      LastAccessedResourceId = @ResourceId
    WHERE UserGuid = @UserGuid
      AND AccessRuleId = @AccessRuleId
  END
  ELSE
  BEGIN
    -- Check for unexpired CachedUser records
    IF EXISTS (
      SELECT 1
      FROM CachedUserView
      WHERE UserGuid = @UserGuid
        AND AccessRuleId = @AccessRuleId
        AND Expired = 0
    )
    BEGIN
      UPDATE CachedUser
      SET LastAccess = GETUTCDATE(),
        LastAccessedResourcePath = @ResourcePath,
        LastAccessedResourceId = @ResourceId
      WHERE UserGuid = @UserGuid
        AND AccessRuleId = @AccessRuleId
    END
    ELSE
    BEGIN
      -- Insert new CachedUser record
      INSERT INTO CachedUser (UserGuid, AccessRuleId, CreatedOn, LastRefresh, LastAccess, LastAccessedResourcePath, LastAccessedResourceId)
      VALUES (@UserGuid, @AccessRuleId, GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), @ResourcePath, @ResourceId)
    END
  END

  SELECT * FROM CachedUserView 
  WHERE UserGuid = @UserGuid 
  AND AccessRuleId = @AccessRuleId 
END
```
**Prompt**:
Stored procedures should be created for the following actions:
- Add, update, and delete AccessRules and Applications while keeping track of
who made the change and when the change was made.
Insertion of new AccessRules should have the same value for CreatedByGuid and ModifiedByGuid.

**Result:**
```sql
CREATE PROCEDURE [dbo].[AccessRule_Insert]
/**
Inserts a new AccessRule into the AccessRule table.
**/
  @AppId INT,
  @ResourcePath VARCHAR(MAX),
  @ResourceId INT,
  @AccessLevelId INT,
  @AccessSchemeId INT,
  @AccessSchemeValue NVARCHAR(255),
  @AccessSchemeSecondaryValue NVARCHAR(255),
  @DurationValid INT,
  @CreatedByGuid UNIQUEIDENTIFIER,
  @CreatedByDisplayName NVARCHAR(255),
  @Comment NVARCHAR(100)
AS
BEGIN
  INSERT INTO AccessRule (AppId, ResourcePath, ResourceId, AccessLevelId, AccessSchemeId, AccessSchemeValue, AccessSchemeSecondaryValue, DurationValid, CreatedByGuid, CreatedByDisplayName, CreatedOn, ModifiedByGuid, ModifiedByDisplayName, ModifiedOn, Comment, ValidStart, Active)
  VALUES (@AppId, @ResourcePath, @ResourceId, @AccessLevelId, @AccessSchemeId, @AccessSchemeValue, @AccessSchemeSecondaryValue, @DurationValid, @CreatedByGuid, @CreatedByDisplayName, GETUTCDATE(), @CreatedByGuid, @CreatedByDisplayName, GETUTCDATE(), @Comment, GETUTCDATE(), 1)
END
```

Write a function that takes a username and returns the user's Guid from
the Gum.AppUser table in the ClinicalDashboard database.
  
```sql
CREATE FUNCTION [dbo].[GetUserGuidByUsername]
/**
Gets the UserGuid for the given username.
**/
@Username NVARCHAR(255)
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
  DECLARE @UserGuid UNIQUEIDENTIFIER

  SELECT @UserGuid = [Guid]
  FROM ClinicalDashboard.Gum.AppUser
  WHERE [Uid] = @Username

  RETURN @UserGuid
END
```

## Classes:

### Entities

### View Models/DTOs

### Repositories/Services


## Methods:

### Utility

A method for comparing resource paths. This method should be used to compare the resource path sent to the server with the resource path in the AccessRule. The method should trim any trailing slashes and convert the string to lowercase before comparing the strings.

```csharp
// Simple method for comparing resource paths
public bool CompareUrls(string url1, string url2)
{
    url1 = url1.TrimEnd('/').ToLowerInvariant();
    url2 = url2.TrimEnd('/').ToLowerInvariant();

    return url1 == url2;
}
```

## Utilities

Scaffold COntrollers:
```powershell
dotnet aspnet-codegenerator controller --noViews -name AccessController -api -actions -outDir Controllers
```
