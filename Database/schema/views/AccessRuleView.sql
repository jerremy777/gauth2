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
  AR.Active
FROM AccessRule AR
INNER JOIN Application APP ON AR.AppId = APP.AppId
INNER JOIN AccessLevel AL ON AR.AccessLevelId = AL.AccessLevelId
INNER JOIN AccessScheme SCH ON AR.AccessSchemeId = SCH.AccessSchemeId
