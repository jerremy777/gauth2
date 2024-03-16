namespace GAuth2.Model;

/// <summary>
/// Represents database items that will be tracked by an audit trail.
/// </summary>
public class GenericRecord
{
  public Guid? CreatedByGuid { get; set; }
  public Guid? ModifiedByGuid { get; set; }
  public string? CreatedByDisplayName { get; set; }
  public string? ModifiedByDisplayName { get; set; }
  public DateTime CreatedOn { get; set; }
  public DateTime ModifiedOn { get; set; }
  public DateTime ValidStart { get; set; }
  public DateTime? ValidEnd { get; set; }
  public bool Active { get; set; }
}
