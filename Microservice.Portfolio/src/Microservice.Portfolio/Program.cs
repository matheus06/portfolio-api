using Azure.Identity;
using Microservice.Portfolio.Helpers;
using Microservice.Portfolio.Helpers.Abstractions;
using Microsoft.FeatureManagement;

var builder = WebApplication.CreateBuilder(args);

var MyAllowSpecificOrigins = "_myAllowSpecificOrigins";

builder.Services.AddFeatureManagement();
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddAzureAppConfiguration();
builder.Configuration.AddAzureAppConfiguration(option =>
{
    option.Connect(new Uri(builder.Configuration["AppConfig:Endpoint"]), new DefaultAzureCredential())
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
