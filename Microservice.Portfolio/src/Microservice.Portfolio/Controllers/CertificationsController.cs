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
        private readonly IConfiguration _configuration;

        public CertificationsController(ILogger<CertificationsController> logger, IConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;
        }

        [HttpGet(Name = "GetCertifications")]
        public IEnumerable<Certification> Get()
        {
            string? accountName = _configuration["BlobConfigurations:AccountName"];
            string? containerName = _configuration["BlobConfigurations:ContainerName"];
            string? containerUrl = _configuration["BlobConfigurations:ContainerUrl"];
            
            if (string.IsNullOrEmpty(accountName))
                throw new ArgumentNullException(nameof(accountName));
            
            if (string.IsNullOrEmpty(containerName))
                throw new ArgumentNullException(nameof(containerName));
            
            if (string.IsNullOrEmpty(containerUrl))
                throw new ArgumentNullException(nameof(containerUrl));


            // Construct the blob container endpoint from the arguments.
            string containerEndpoint = string.Format(containerUrl, accountName, containerName);

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