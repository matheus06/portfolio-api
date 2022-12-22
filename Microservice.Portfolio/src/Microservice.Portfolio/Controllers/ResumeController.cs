using Azure.Identity;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Microservice.Portfolio.Dto;
using Microsoft.AspNetCore.Mvc;

namespace Microservice.Portfolio.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ResumeController : ControllerBase
    {
        private readonly ILogger<ResumeController> _logger;

        public ResumeController(ILogger<ResumeController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "GetResume")]
        public IEnumerable<Resume> Get()
        {
            string accountName = "blobportfolio";
            string containerName = "portfolio";

            // Construct the blob container endpoint from the arguments.
            string containerEndpoint = string.Format("https://{0}.blob.core.windows.net/{1}", accountName, containerName);

            // Get a credential and create a service client object for the blob container.
            BlobContainerClient containerClient = new BlobContainerClient(new Uri(containerEndpoint), new DefaultAzureCredential());
                     

            var listOfResume = new List<Resume>();
            foreach (BlobItem blob in containerClient.GetBlobs(traits: BlobTraits.Metadata, prefix: nameof(Resume).ToLower()))
            {
                listOfResume.Add(new Resume() { Description = GetMetadataValue(blob, nameof(Resume.Description)), BlobUrl = $"{containerClient.Uri}/{blob.Name}" });
            }

            return listOfResume;
        }

        private string? GetMetadataValue(BlobItem blob, string metadataKey)
        {           
            return blob.Metadata.ContainsKey(metadataKey) ? blob.Metadata[metadataKey] : null;
        }
    }
}