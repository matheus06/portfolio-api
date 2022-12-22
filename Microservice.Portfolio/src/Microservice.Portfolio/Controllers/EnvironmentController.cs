using Microsoft.AspNetCore.Mvc;

namespace Microservice.Portfolio.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class EnvironmentController : ControllerBase
    {
        private readonly ILogger<EnvironmentController> _logger;

        public EnvironmentController(ILogger<EnvironmentController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "GetEnvironment")]
        public string Get()
        {
           return "Powered By Azure App Service";
        }
    }
}