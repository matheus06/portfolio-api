using Azure.Storage.Blobs.Models;

namespace Microservice.Portfolio.Helpers.Abstractions;

public interface IAzureHelper
{
    string GetBlobContainerUri();
    string? GetMetadataValue(BlobItem blob, string metadataKey);
    string GetCosmosAccountEndpoint();
    string GetCosmosDatabase();
    string GetCosmosContainer();
}