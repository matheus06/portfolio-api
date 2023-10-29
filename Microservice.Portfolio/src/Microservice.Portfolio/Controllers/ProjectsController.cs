using Azure.Identity;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Microservice.Portfolio.Dto;
using Microservice.Portfolio.Helpers.Abstractions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.FeatureManagement;
using Microsoft.FeatureManagement.Mvc;

namespace Microservice.Portfolio.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProjectsController : ControllerBase
    {
        private readonly ILogger<ProjectsController> _logger;
        private readonly IAzureHelper _azureHelper;

        public ProjectsController(ILogger<ProjectsController> logger, IAzureHelper azureHelper)
        {
            _logger = logger;
            _azureHelper = azureHelper;
        }


        [HttpGet(Name = "GetProjects")]
        [FeatureGate("EnableProjects")]
        public IEnumerable<Projects> Get()
        {
            // Construct the blob container endpoint from the arguments.
            var containerEndpoint = _azureHelper.GetBlobContainerUri();

            // Get a credential and create a service client object for the blob container.
            BlobContainerClient containerClient = new BlobContainerClient(new Uri(containerEndpoint), new DefaultAzureCredential());

            var listOfProjects = new List<Projects>();
            foreach (BlobItem blob in containerClient.GetBlobs(traits: BlobTraits.Metadata, prefix: nameof(Projects).ToLower()))
            {
                listOfProjects.Add(new Projects() { Name = _azureHelper.GetMetadataValue(blob, nameof(Projects.Name)), ImageUrl = $"{containerClient.Uri}/{blob.Name}" });
            }

            return listOfProjects;
        }
    }
}