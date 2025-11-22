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
    public class CertificationsController : ControllerBase
    {
        private readonly ILogger<CertificationsController> _logger;
        private readonly IAzureHelper _azureHelper;

        public CertificationsController(ILogger<CertificationsController> logger, IAzureHelper azureHelper)
        {
            _logger = logger;
            _azureHelper = azureHelper;
        }

        [HttpGet(Name = "GetCertifications")]
        public IEnumerable<Certification> Get()
        {
            var containerEndpoint = _azureHelper.GetBlobContainerUri();

            // Get a credential and create a service client object for the blob container.
            BlobContainerClient containerClient = new(new Uri(containerEndpoint), new DefaultAzureCredential());

            var listOfCertifications = new List<Certification>();
            foreach (BlobItem blob in containerClient.GetBlobs(traits: BlobTraits.Metadata, prefix: nameof(Certification).ToLower()))
            {
                listOfCertifications.Add(new Certification() { Name = _azureHelper.GetMetadataValue(blob, nameof(Certification.Name)), ImageUrl = $"{containerClient.Uri}/{blob.Name}", BadgeUrl = _azureHelper.GetMetadataValue(blob, nameof(Certification.BadgeUrl)) });
            }

            return listOfCertifications;
        }
    }
}