using Dapper;

namespace GAuth2.Entities
{
    /*
    Match entity to this view:
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
    */
    public class CachedUser
    {
        public int CachedUserId { get; set; }
        public string DisplayName { get; set; } = "";
        public int AccessRuleId { get; set; }
        public bool AccessExpired { get; set; }
        public int AppId { get; set; }
        public string ApplicationName { get; set; } = "";
        public int AccessLevelId { get; set; }
        public string AccessLevelName { get; set; } = "";
        public int AccessSchemeId { get; set; }
        public string AccessSchemeName { get; set; } = "";
        public Guid UserGuid { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime LastRefresh { get; set; }
        public DateTime LastAccess { get; set; }
        public int? LastAccessedResourceId { get; set; }
        public string? Comment { get; set; }
        public bool Active { get; set; }
    }
}
