using Azure.Identity;
using Microservice.Portfolio.Dto;
using Microservice.Portfolio.Helpers.Abstractions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Cosmos;

namespace Microservice.Portfolio.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ContactController : ControllerBase
    {
        private readonly ILogger<ContactController> _logger;
        private readonly IAzureHelper _azureHelper;

        public ContactController(ILogger<ContactController> logger, IAzureHelper azureHelper)
        {
            _logger = logger;
            _azureHelper = azureHelper;
        }

        [HttpPost(Name = "PostContact")]
        public async Task<IResult> Post(ContactRequest contactRequest)
        {
            CosmosClient cosmosClient = new CosmosClient(_azureHelper.GetCosmosAccountEndpoint(), new DefaultAzureCredential());
            Database database = cosmosClient.GetDatabase(_azureHelper.GetCosmosDatabase());
            Container container = database.GetContainer(_azureHelper.GetCosmosContainer());
            var contact = new Contact
            {
                id = Guid.NewGuid().ToString(),
                Name = contactRequest.Name,
                Email = contactRequest.Email,
                Message = contactRequest.Message
            };
            ItemResponse<Contact> item = await container.CreateItemAsync<Contact>(contact, new PartitionKey(contact.id));
            return Results.Ok();
        }
    }

    public class Contact
    {
        public string id { get; set; }
        public string? Name { get; set; }
        public string Email { get; set; }
        public string? Message { get; set; }
    }
}