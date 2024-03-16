using Microsoft.AspNetCore.Authentication.Negotiate;
using GAuth2.Context;
using GAuth2.Repository;
using GAuth2.Service;

var builder = WebApplication.CreateBuilder(args);


builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddAuthentication(NegotiateDefaults.AuthenticationScheme)
   .AddNegotiate();

builder.Services.AddAuthorization(options =>
{
    options.FallbackPolicy = options.DefaultPolicy;
});

// Initialize database connection string and add GAuthContext to the container
builder.Services.AddSingleton<GAuthContext>();
builder.Services.AddSingleton<ClinicalDashboardContext>();

// Add Services and Repositories to the container

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

app.Run();
