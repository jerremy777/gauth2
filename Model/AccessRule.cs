namespace GAuth2.Model;
/*
Match entity to this table:
CREATE TABLE AccessRule (
  AccessRuleId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  AppId INT NOT NULL,
  ResourceId INT NULL,
  AccessLevelId INT NOT NULL,
  RuleTypeId INT NOT NULL,
  AccessRuleValue NVARCHAR(255) NULL,
  AccessRuleSecondaryValue NVARCHAR(255) NULL,
  DurationValid INT NULL DEFAULT 1440,
  Comment NVARCHAR(100) NULL,
  ModifiedByGuid UNIQUEIDENTIFIER NULL,
  ModifiedByDisplayName NVARCHAR(255) NULL,
  ModifiedOn DATETIME NOT NULL,
  CreatedByGuid UNIQUEIDENTIFIER NULL,
  CreatedByDisplayName NVARCHAR(255) NULL,
  CreatedOn DATETIME NOT NULL,
  ValidStart DATETIME NOT NULL,
  ValidEnd DATETIME NULL,
  Active BIT NOT NULL DEFAULT 1,
  CONSTRAINT FK_AccessRule_AccessLevel FOREIGN KEY (AccessLevelId) REFERENCES AccessLevel(AccessLevelId),
  CONSTRAINT FK_AccessRule_Application FOREIGN KEY (AppId) REFERENCES Application(AppId),
  CONSTRAINT FK_AccessRule_Resource FOREIGN KEY (ResourceId) REFERENCES Resource(ResourceId),
  CONSTRAINT FK_AccessRule_AccessRuleType FOREIGN KEY (RuleTypeId) REFERENCES AccessRuleType(RuleTypeId)
)
*/
public class AccessRule : GenericRecord
{
    public int AccessRuleId { get; set; }
    public int AppId { get; set; }
    public int? ResourceId { get; set; }
    public int AccessLevelId { get; set; }
    public int RuleTypeId { get; set; }
    /// <summary>
    /// The access rule value type is determined by the RuleTypeId. A Rule Type
    /// can be a user, group, role, department, all users etc.
    /// Examples of an Access Rule Value are the name of an AD group, or a user GUID.
    /// </summary>
    public string? AccessRuleValue { get; set; }
    /// <summary>
    /// The secondary value is used to store an optional secondary value for the access rule.
    /// This is to allow for more complex access rules.
    /// </summary>
    public string? AccessRuleSecondaryValue { get; set; }
    /// <summary>
    /// The duration valid is the number of minutes that the access rule is valid for.
    /// The default is 1440 minutes (24 hours). Once the access rule for a cached user
    /// has expired, the user will need to re-authenticate by passing the rule
    /// determined by the rule type. I.e. be in a certain group, have a certain role etc.
    /// </summary>
    public int DurationValid { get; set; } = 1440;
    public string? Comment { get; set; }
}