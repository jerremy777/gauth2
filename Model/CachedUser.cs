namespace GAuth2.Model;
/*
CREATE TABLE CachedUser (
  CachedUserId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  AccessRuleId INT NOT NULL,
  DisplayName NVARCHAR(255) NULL,
  UserGuid UNIQUEIDENTIFIER NOT NULL,
  CreatedOn DATETIME NOT NULL,
  LastRefresh DATETIME NOT NULL,
  LastAccess DATETIME NOT NULL,
  LastAccessedResourceId INT NULL,
  Comment NVARCHAR(100) NULL,
  Active BIT NOT NULL DEFAULT 1,
  CONSTRAINT FK_CachedUser_AccessRule FOREIGN KEY (AccessRuleId) REFERENCES AccessRule(AccessRuleId),
  CONSTRAINT FK_CachedUser_Resource FOREIGN KEY (LastAccessedResourceId) REFERENCES [Resource](ResourceId)
)
*/
public class CachedUser
{
    public int CachedUserId { get; set; }
    public int AccessRuleId { get; set; }
    public string? DisplayName { get; set; }
    public Guid UserGuid { get; set; }
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
