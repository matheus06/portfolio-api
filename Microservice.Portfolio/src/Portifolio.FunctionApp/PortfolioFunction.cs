using Azure.Identity;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Portifolio.FunctionApp.Dto;
using SendGrid.Helpers.Mail;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace Portifolio.FunctionApp
{
    public static class PortfolioFunction
    {
        [FunctionName("resume")]
        public static async Task<IActionResult> GetReumse([HttpTrigger(AuthorizationLevel.Function, "get", Route = "resume")] HttpRequest req,ILogger log)
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

            return new OkObjectResult(listOfResume);
        }

        [FunctionName("certifications")]
        public static async Task<IActionResult> GetCertifications([HttpTrigger(AuthorizationLevel.Function, "get", Route = "certifications")] HttpRequest req, ILogger log)
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

            return new OkObjectResult(listOfCertifications);
        }

        [FunctionName("technologies")]
        public static async Task<IActionResult> GetTechnologies([HttpTrigger(AuthorizationLevel.Function, "get", Route = "technologies")] HttpRequest req, ILogger log)
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

            return new OkObjectResult(listOfCertifications);
        }

  
        [FunctionName("contact")]
        [return: SendGrid(ApiKey = "SendGridApiKey")]
        public static async Task<SendGridMessage> PostContact([HttpTrigger(AuthorizationLevel.Function, "post", Route = "contact")] HttpRequest req, ILogger log)
        {
            var content = await new StreamReader(req.Body).ReadToEndAsync();
            var contactRequest = JsonConvert.DeserializeObject<ContactRequest>(content);
            var msg = new SendGridMessage()
            {
                From = new EmailAddress("matheus.sexto@gmail.com", "Matheus Sexto"),
                Subject = $"{contactRequest.Name} - {contactRequest.Email}",
                PlainTextContent = $"{contactRequest.Message}"
            };
            msg.AddTo(new EmailAddress("matheus.sexto@gmail.com", "Matheus Sexto"));
            return msg;
        }

        [FunctionName("environment")]
        public static async Task<IActionResult> GetEnvironment([HttpTrigger(AuthorizationLevel.Function, "get", Route = "environment")] HttpRequest req, ILogger log)
        {
           return new OkObjectResult("Powered By Azure Functions");
        }

        private static string? GetMetadataValue(BlobItem blob, string metadataKey)
        {
            return blob.Metadata.ContainsKey(metadataKey) ? blob.Metadata[metadataKey] : null;
        }
    }
}
