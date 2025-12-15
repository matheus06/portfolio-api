using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Portifolio.FunctionApp.Helpers;
using Portifolio.FunctionApp.Helpers.Abstractions;

var builder = FunctionsApplication.CreateBuilder(args);

builder.Services.AddTransient<IAzureHelper, AzureHelper>();

builder.Services.AddOptions<BlobOptions>()
               .Configure<IConfiguration>((settings, configuration) =>
               {
                   configuration.GetSection("BlobConfigurations").Bind(settings);
               });

builder.ConfigureFunctionsWebApplication();

builder.Services
    .AddApplicationInsightsTelemetryWorkerService()
    .ConfigureFunctionsApplicationInsights();

builder.Build().Run();
