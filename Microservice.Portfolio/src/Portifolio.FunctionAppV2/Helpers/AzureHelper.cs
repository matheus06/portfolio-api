using Azure.Storage.Blobs.Models;
using Microsoft.Extensions.Options;
using Portifolio.FunctionApp.Helpers.Abstractions;

namespace Portifolio.FunctionApp.Helpers;

public class AzureHelper : IAzureHelper
{
    private readonly IOptions<BlobOptions> _blobOptions;

    public AzureHelper(IOptions<BlobOptions> blobOptions)
    {
        _blobOptions = blobOptions;
    }

    public string GetBlobContainerUri()
    {
        var accountName = _blobOptions.Value.AccountName;
        var containerName = _blobOptions.Value.ContainerName;
        var containerUrl = _blobOptions.Value.ContainerUrl;

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

}