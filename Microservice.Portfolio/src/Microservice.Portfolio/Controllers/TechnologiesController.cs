using Azure.Identity;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Microservice.Portfolio.Dto;
using Microservice.Portfolio.Helpers.Abstractions;
using Microsoft.AspNetCore.Mvc;

namespace Microservice.Portfolio.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TechnologiesController : ControllerBase
    {
        private readonly ILogger<TechnologiesController> _logger;
        private readonly IAzureHelper _azureHelper;

        public TechnologiesController(ILogger<TechnologiesController> logger, IAzureHelper azureHelper)
        {
            _logger = logger;
            _azureHelper = azureHelper;
        }

        [HttpGet(Name = "GetTechnologies")]
        public IEnumerable<Technologies> Get()
        {
            // Construct the blob container endpoint from the arguments.
            var containerEndpoint = _azureHelper.GetBlobContainerUri();

            // Get a credential and create a service client object for the blob container.
            BlobContainerClient containerClient = new(new Uri(containerEndpoint), new DefaultAzureCredential());

            var listOfCertifications = new List<Technologies>();
            foreach (BlobItem blob in containerClient.GetBlobs(traits: BlobTraits.Metadata, prefix: nameof(Technologies).ToLower()))
            {
                listOfCertifications.Add(new Technologies() { Name = _azureHelper.GetMetadataValue(blob, nameof(Technologies.Name)), ImageUrl = $"{containerClient.Uri}/{blob.Name}" });
            }

            return listOfCertifications;
        }
    }
}