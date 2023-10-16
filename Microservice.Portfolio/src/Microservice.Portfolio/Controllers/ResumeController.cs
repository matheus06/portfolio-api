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
    public class ResumeController : ControllerBase
    {
        private readonly ILogger<ResumeController> _logger;
        private readonly IAzureHelper _azureHelper;

        public ResumeController(ILogger<ResumeController> logger, IAzureHelper azureHelper)
        {
            _logger = logger;
            _azureHelper = azureHelper;
        }

        [HttpGet(Name = "GetResume")]
        public IEnumerable<Resume> Get()
        {
            var containerEndpoint = _azureHelper.GetBlobContainerUri();
            
            // Get a credential and create a service client object for the blob container.
            BlobContainerClient containerClient = new BlobContainerClient(new Uri(containerEndpoint), new DefaultAzureCredential());
            
            var listOfResume = new List<Resume>();
            foreach (BlobItem blob in containerClient.GetBlobs(traits: BlobTraits.Metadata, prefix: nameof(Resume).ToLower()))
            {
                listOfResume.Add(new Resume() { Description = _azureHelper.GetMetadataValue(blob, nameof(Resume.Description)), BlobUrl = $"{containerClient.Uri}/{blob.Name}" });
            }

            return listOfResume;
        }
    }
}