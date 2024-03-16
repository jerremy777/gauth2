namespace GAuth2.Model;
/*
Match entity to this view:
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
*/
public class AccessRule : GenericRecord
{
    public int AccessRuleId { get; set; }
    public int AppId { get; set; }
    public int AccessLevelId { get; set; }
    public int ResourceId { get; set; }
    public int AccessSchemeId { get; set; }
    public string ApplicationName { get; set; } = "";
    public string ResourceKey { get; set; } = "";
    public int ResourceValue { get; set; }
    public string AccessLevelName { get; set; } = "";
    public string AccessSchemeName { get; set; } = "";
    public int DurationValid { get; set; } = 1440;
    public string? AccessRuleKey { get; set; }
    public string? AccessRuleValue { get; set; }
    public string? AccessRuleSecondaryValue { get; set; }
    public string? Comment { get; set; }
}
