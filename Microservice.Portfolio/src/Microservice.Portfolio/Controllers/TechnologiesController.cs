using Azure.Identity;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Microservice.Portfolio.Dto;
using Microsoft.AspNetCore.Mvc;

namespace Microservice.Portfolio.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TechnologiesController : ControllerBase
    {
        private readonly ILogger<TechnologiesController> _logger;

        public TechnologiesController(ILogger<TechnologiesController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "GetTechnologies")]
        public IEnumerable<Technologies> Get()
        {
            string accountName = "blobportfolio";
            string containerName = "portfolio";

            // Construct the blob container endpoint from the arguments.
            string containerEndpoint = string.Format("https://{0}.blob.core.windows.net/{1}", accountName, containerName);

            // Get a credential and create a service client object for the blob container.
            BlobContainerClient containerClient = new BlobContainerClient(new Uri(containerEndpoint), new DefaultAzureCredential());

            var listOfCertifications = new List<Technologies>();
            foreach (BlobItem blob in containerClient.GetBlobs(traits: BlobTraits.Metadata, prefix: nameof(Technologies).ToLower()))
            {
                listOfCertifications.Add(new Technologies() { Name = GetMetadataValue(blob, nameof(Technologies.Name)), ImageUrl = $"{containerClient.Uri}/{blob.Name}" });
            }

            return listOfCertifications;
        }

        private string? GetMetadataValue(BlobItem blob, string metadataKey)
        {
            return blob.Metadata.ContainsKey(metadataKey) ? blob.Metadata[metadataKey] : null;
        }
    }
}