using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using MPortifolio.FunctionApp.Helpers;
using Portifolio.FunctionApp.Helpers;
using Portifolio.FunctionApp.Helpers.Abstractions;
using System.IO;

[assembly: FunctionsStartup(typeof(Portifolio.FunctionApp.Startup))]
namespace Portifolio.FunctionApp
{
    public class Startup : FunctionsStartup
    {
        public override void Configure(IFunctionsHostBuilder builder)
        {
            builder.Services.AddTransient<IAzureHelper, AzureHelper>();

            builder.Services.AddOptions<BlobOptions>()
                 .Configure<IConfiguration>((settings, configuration) =>
                 {
                     configuration.GetSection("BlobConfigurations").Bind(settings);
                 });

        }

        public override void ConfigureAppConfiguration(IFunctionsConfigurationBuilder builder)
        {
            base.ConfigureAppConfiguration(builder);

            FunctionsHostBuilderContext context = builder.GetContext();

            builder.ConfigurationBuilder
                .AddJsonFile(Path.Combine(context.ApplicationRootPath, "appsettings.json"),optional: true, reloadOnChange: false)
                .AddJsonFile(Path.Combine(context.ApplicationRootPath, $"appsettings.{context.EnvironmentName}.json"),optional: true, reloadOnChange: false)
                .AddEnvironmentVariables();

        }
    }
}
