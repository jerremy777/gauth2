namespace GAuth2.Model;

public class CachedUserDTO
{
    public int CachedUserId { get; set; }
    public Guid UserGuid { get; set; }
    public string? DisplayName { get; set; }
    public int AccessRuleId { get; set; }
    public AccessRuleDTO? AccessRule { get; set; }
    public bool IsAccessExpired { get; set; }
    public DateTime CreatedOn { get; set; }
    /// <summary>
    /// This is the last time this cached user passed the access rule.
    /// I.e. the last time the user was confirmed to be in the correct group,
    /// have the correct role etc.
    /// </summary>
    public DateTime LastRefresh { get; set; }
    public DateTime LastAccess { get; set; }
    public int? LastAccessedResourceId { get; set; }
    public string? Comment { get; set; }
    public bool Active { get; set; }
}