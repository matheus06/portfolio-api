using Azure.Identity;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Microservice.Portfolio.Dto;
using Microsoft.AspNetCore.Mvc;

namespace Microservice.Portfolio.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CertificationsController : ControllerBase
    {
        private readonly ILogger<CertificationsController> _logger;

        public CertificationsController(ILogger<CertificationsController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "GetCertifications")]
        public IEnumerable<Certification> Get()
        {
            string accountName = "blobportfolio";
            string containerName = "portfolio";

            // Construct the blob container endpoint from the arguments.
            string containerEndpoint = string.Format("https://{0}.blob.core.windows.net/{1}", accountName, containerName);

            // Get a credential and create a service client object for the blob container.
            BlobContainerClient containerClient = new BlobContainerClient(new Uri(containerEndpoint), new DefaultAzureCredential());

            var listOfCertifications = new List<Certification>();
            foreach (BlobItem blob in containerClient.GetBlobs(traits: BlobTraits.Metadata, prefix: nameof(Certification).ToLower()))
            {
                listOfCertifications.Add(new Certification() { Name = GetMetadataValue(blob, nameof(Certification.Name)), ImageUrl = $"{containerClient.Uri}/{blob.Name}", BadgeUrl = GetMetadataValue(blob, nameof(Certification.BadgeUrl)) });
            }

            return listOfCertifications;
        }

        private string? GetMetadataValue(BlobItem blob, string metadataKey)
        {
            return blob.Metadata.ContainsKey(metadataKey) ? blob.Metadata[metadataKey] : null;
        }
    }
}