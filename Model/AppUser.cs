namespace GAuth2.Model;
/*
CREATE TABLE [Gum].[AppUser](
[Guid] [uniqueidentifier] NOT NULL,
[FullName] [nvarchar](255) NULL,
[FirstName] [nvarchar](255) NULL,
[LastName] [nvarchar](255) NULL,
[Title] [nvarchar](255) NULL,
[Description] [nvarchar](255) NULL,
[DisplayName] [nvarchar](255) NULL,
[Department] [nvarchar](255) NULL,
[Uid] [nvarchar](255) NULL,
[Active] [bit] NOT NULL,
[Domain] [char](2) NULL
*/
/// <summary>
/// Class representing a user from the Gum.AppUser table in ClinicalDashboard.
/// </summary>
public class AppUser
{
    public Guid Guid { get; set; }
    public string? FullName { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public string? Title { get; set; }
    public string? DisplayName { get; set; }
    public string? Department { get; set; }
    public string? Uid { get; set; }
    public string? Domain { get; set; }
    public bool Active { get; set; }
}
