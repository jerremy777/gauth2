namespace GAuth2.Model;

public class AccessRuleDTO : GenericRecord
{
  public int AccessRuleId { get; set; }
  public int AppId { get; set; }
  public Application Application { get; set; } = new Application();
  public int? ResourceId { get; set; }
  public Resource? Resource { get; set; }
  public int AccessLevelId { get; set; }
  public AccessLevel AccessLevel { get; set; } = new AccessLevel();
  public int RuleTypeId { get; set; }
  public RuleType RuleType { get; set; } = new RuleType();
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