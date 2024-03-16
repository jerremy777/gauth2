DROP VIEW [CachedUserView]
GO

CREATE VIEW [CachedUserView]
AS
SELECT
  CU.CachedUserId,
  CU.DisplayName,
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
  CU.LastAccessedResourceId,
  CU.Comment,
  CU.Active
FROM CachedUser CU
INNER JOIN AccessRule AR ON CU.AccessRuleId = AR.AccessRuleId
INNER JOIN [Application] APP ON AR.AppId = APP.AppId
INNER JOIN AccessLevel AL ON AR.AccessLevelId = AL.AccessLevelId
INNER JOIN AccessScheme SCH ON AR.AccessSchemeId = SCH.AccessSchemeId
