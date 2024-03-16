namespace GAuth2.Model;
/*
CREATE TABLE RuleType (
  RuleTypeId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  RuleTypeName VARCHAR(50) NOT NULL,
  Active BIT NOT NULL DEFAULT 1
)
*/
public class RuleType
{
  public int RuleTypeId { get; set; }
  public string RuleTypeName { get; set; } = "";
  public bool Active { get; set; }
}