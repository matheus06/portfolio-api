using Azure.Identity;
using Microservice.Portfolio.Helpers;
using Microservice.Portfolio.Helpers.Abstractions;
using Microsoft.FeatureManagement;

var builder = WebApplication.CreateBuilder(args);

var MyAllowSpecificOrigins = "_myAllowSpecificOrigins";
var azureAppConfigurationConnectionString = builder.Configuration.GetConnectionString("AzureAppConfigUrl");

builder.Services.AddFeatureManagement();
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Configuration.AddAzureAppConfiguration(option =>
{
    option.Connect(new Uri(azureAppConfigurationConnectionString), new DefaultAzureCredential())
        .UseFeatureFlags();
});

builder.Services.AddScoped<IAzureHelper, AzureHelper>();

builder.Services.AddCors(options =>
{
  options.AddPolicy(name: MyAllowSpecificOrigins,
                    policy =>
                    {
                      policy.AllowAnyOrigin();
                      policy.AllowAnyHeader();
                      policy.AllowAnyMethod();
                    });
});

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseCors(MyAllowSpecificOrigins);

app.UseAzureAppConfiguration();
app.UseAuthorization();

app.MapControllers();

app.Run();
