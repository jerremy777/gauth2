using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Options;
using System.Data;

namespace GAuth2.Context;
public class GAuthContext
{
    private readonly string _connectionString;
    public GAuthContext(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("GAuth") ??
            throw new ArgumentNullException("GAuth connection string not found");
    }

    public IDbConnection CreateConnection()
    {
        return new SqlConnection(_connectionString);
    }
}
public class ClinicalDashboardContext
{
    private readonly string _connectionString;
    public ClinicalDashboardContext(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("ClinicalDashboard") ??
            throw new ArgumentNullException("ClinicalDashboard connection string not found");
    }

    public IDbConnection CreateConnection()
    {
        return new SqlConnection(_connectionString);
    }
}
