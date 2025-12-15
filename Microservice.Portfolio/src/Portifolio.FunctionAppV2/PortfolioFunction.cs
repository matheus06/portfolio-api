using Azure.Identity;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Portifolio.FunctionApp.Dto;
using Portifolio.FunctionApp.Helpers.Abstractions;

namespace Portifolio.FunctionAppV2;

public class PortfolioFunction(IAzureHelper azureHelper, ILogger<PortfolioFunction> logger)
{

    private readonly IAzureHelper _azureHelper = azureHelper;

    [Function("resume")]
    public IActionResult GetResume([HttpTrigger(AuthorizationLevel.Function, "get", Route = "resume")] HttpRequest req)
    {
        string containerEndpoint = _azureHelper.GetBlobContainerUri();

        BlobContainerClient containerClient = new(new Uri(containerEndpoint), new DefaultAzureCredential());

        var listOfResume = new List<Resume>();
        foreach (BlobItem blob in containerClient.GetBlobs(traits: BlobTraits.Metadata, prefix: nameof(Resume).ToLower()))
        {
            listOfResume.Add(new Resume() { Description = _azureHelper.GetMetadataValue(blob, nameof(Resume.Description)), BlobUrl = $"{containerClient.Uri}/{blob.Name}" });
        }

        return new OkObjectResult(listOfResume);
    }

    [Function("certifications")]
    public IActionResult GetCertifications([HttpTrigger(AuthorizationLevel.Function, "get", Route = "certifications")] HttpRequest req)
    {
        try
        {
            string containerEndpoint = _azureHelper.GetBlobContainerUri();

            BlobContainerClient containerClient = new(new Uri(containerEndpoint), new DefaultAzureCredential());

            var listOfCertifications = new List<Certification>();
            foreach (BlobItem blob in containerClient.GetBlobs(traits: BlobTraits.Metadata, prefix: nameof(Certification).ToLower()))
            {
                listOfCertifications.Add(new Certification() { Name = _azureHelper.GetMetadataValue(blob, nameof(Certification.Name)), ImageUrl = $"{containerClient.Uri}/{blob.Name}", BadgeUrl = _azureHelper.GetMetadataValue(blob, nameof(Certification.BadgeUrl)) });
            }

            return new OkObjectResult(listOfCertifications);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error retrieving certifications");
            return new ObjectResult(ex.Message) { StatusCode = 500 };
        }
    }

    [Function("technologies")]
    public IActionResult GetTechnologies([HttpTrigger(AuthorizationLevel.Function, "get", Route = "technologies")] HttpRequest req)
    {
        string containerEndpoint = _azureHelper.GetBlobContainerUri();

        BlobContainerClient containerClient = new(new Uri(containerEndpoint), new DefaultAzureCredential());

        var listOfCertifications = new List<Technologies>();
        foreach (BlobItem blob in containerClient.GetBlobs(traits: BlobTraits.Metadata, prefix: nameof(Technologies).ToLower()))
        {
            listOfCertifications.Add(new Technologies() { Name = _azureHelper.GetMetadataValue(blob, nameof(Technologies.Name)), ImageUrl = $"{containerClient.Uri}/{blob.Name}" });
        }

        return new OkObjectResult(listOfCertifications);
    }

    [Function("projects")]
    public IActionResult GetProjects([HttpTrigger(AuthorizationLevel.Function, "get", Route = "projects")] HttpRequest req)
    {
        string containerEndpoint = _azureHelper.GetBlobContainerUri();

        BlobContainerClient containerClient = new(new Uri(containerEndpoint), new DefaultAzureCredential());

        var listOfProjects = new List<Projects>();
        foreach (BlobItem blob in containerClient.GetBlobs(traits: BlobTraits.Metadata, prefix: nameof(Projects).ToLower()))
        {
            listOfProjects.Add(new Projects() { Name = _azureHelper.GetMetadataValue(blob, nameof(Projects.Name)), ImageUrl = $"{containerClient.Uri}/{blob.Name}" });
        }

        return new OkObjectResult(listOfProjects);
    }


    //[Function("contact")]
    //[return: SendGrid(ApiKey = "SendGridApiKey")]
    //public async Task<SendGridMessage> PostContact([HttpTrigger(AuthorizationLevel.Function, "post", Route = "contact")] HttpRequest req)
    //{
    //    var content = await new StreamReader(req.Body).ReadToEndAsync();
    //    var contactRequest = JsonConvert.DeserializeObject<ContactRequest>(content);
    //    var msg = new SendGridMessage()
    //    {
    //        From = new EmailAddress("matheus.sexto@gmail.com", "Matheus Sexto"),
    //        Subject = $"{contactRequest.Name} - {contactRequest.Email}",
    //        PlainTextContent = $"{contactRequest.Message}"
    //    };
    //    msg.AddTo(new EmailAddress("matheus.sexto@gmail.com", "Matheus Sexto"));
    //    return msg;
    //}

    [Function("environment")]
    public IActionResult GetEnvironment([HttpTrigger(AuthorizationLevel.Function, "get", Route = "environment")] HttpRequest req)
    {
        return new OkObjectResult("Powered By Azure Functions");
    }
}