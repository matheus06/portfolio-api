using Azure.Storage.Blobs.Models;
using Microservice.Portfolio.Helpers.Abstractions;

namespace Microservice.Portfolio.Helpers;

public class AzureHelper : IAzureHelper
{
    private readonly IConfiguration _configuration;

    public AzureHelper(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public string GetBlobContainerUri()
    {
        var accountName = _configuration["BlobConfigurations:AccountName"];
        var containerName = _configuration["BlobConfigurations:ContainerName"];
        var containerUrl = _configuration["BlobConfigurations:ContainerUrl"];

        if (string.IsNullOrEmpty(accountName))
            throw new ArgumentNullException(nameof(accountName));

        if (string.IsNullOrEmpty(containerName))
            throw new ArgumentNullException(nameof(containerName));

        if (string.IsNullOrEmpty(containerUrl))
            throw new ArgumentNullException(nameof(containerUrl));
        
        // Construct the blob container endpoint from the arguments.
        return string.Format(containerUrl, accountName, containerName);
    }
    
    public string? GetMetadataValue(BlobItem blob, string metadataKey)
    {           
        return blob.Metadata.TryGetValue(metadataKey, out var value) ? value : null;
    }

    public string GetCosmosAccountEndpoint()
    {
        var accountEndpoint = _configuration["CosmosConfiguration:AccountEndpoint"];
        if (string.IsNullOrEmpty(accountEndpoint))
            throw new ArgumentNullException(nameof(accountEndpoint));

        return accountEndpoint;
    }

    public string GetCosmosDatabase()
    {
        var databaseName = _configuration["CosmosConfiguration:Database"];
        if (string.IsNullOrEmpty(databaseName))
            throw new ArgumentNullException(nameof(databaseName));

        return databaseName;
    }

    public string GetCosmosContainer()
    {
        var containerName = _configuration["CosmosConfiguration:Container"];
        if (string.IsNullOrEmpty(containerName))
            throw new ArgumentNullException(nameof(containerName));

        return containerName;
    }
}