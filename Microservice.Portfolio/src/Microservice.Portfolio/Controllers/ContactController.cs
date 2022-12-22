using Azure.Identity;
using Microservice.Portfolio.Dto;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Cosmos;

namespace Microservice.Portfolio.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ContactController : ControllerBase
    {
        private readonly ILogger<ContactController> _logger;

        public ContactController(ILogger<ContactController> logger)
        {
            _logger = logger;
        }

        [HttpPost(Name = "PostContact")]
        public async Task<IResult> Post(ContactRequest contactRequest)
        {
            CosmosClient cosmosClient = new CosmosClient("https://portfolio-contact-form.documents.azure.com:443/", new DefaultAzureCredential());
            Database database = cosmosClient.GetDatabase("portfolio-db");
            Container container = database.GetContainer("portfolio-contact");
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