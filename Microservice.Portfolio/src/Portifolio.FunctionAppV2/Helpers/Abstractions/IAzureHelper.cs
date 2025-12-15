using Azure.Storage.Blobs.Models;

namespace Portifolio.FunctionApp.Helpers.Abstractions;

public interface IAzureHelper
{
    string GetBlobContainerUri();
    string? GetMetadataValue(BlobItem blob, string metadataKey);
}