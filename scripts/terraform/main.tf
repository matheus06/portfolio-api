terraform {
  backend "azurerm" {
    resource_group_name  = "matheus-shared-rg"
    storage_account_name = "matheussharedstorageacc"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
   required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.56.0"   # or just "~> 4.0" to stay on 4.x
    }
  }
}

data "azuread_client_config" "current" {}

provider "azurerm" {
  features {}
     subscription_id = var.subscription_id
     tenant_id       = var.tenant_id
  
}

# Create the resource group for the App
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-rg"
  location = var.location
}

# Create the storage acc
resource "azurerm_storage_account" "storageacc" {
  name                     = "portfoliostorageaccv2"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  tags = {
    environment = "portfolio"
  }
}

# Create the storage container
resource "azurerm_storage_container" "container" {
  name                  = "portfolio-container"
  storage_account_id  = azurerm_storage_account.storageacc.id
  container_access_type = "blob"
}

# Upload certAzure.png to the storage container
resource "azurerm_storage_blob" "certAzure" {
  name                   = "certifications/certAzure.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/certifications/certAzure.png"
  content_type = "image/png"

  metadata = {
    badgeurl    = "https://www.credly.com/badges/bca16ceb-8c50-423c-b74d-84935fbd9588"
    name        = "Azure Fundamentals"
  }
}


# Upload certAzureDev.png to the storage container
resource "azurerm_storage_blob" "certAzureDev" {
  name                   = "certifications/certAzureDev.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/certifications/certAzureDev.png"
  content_type = "image/png"

  metadata = {
    badgeurl    = "https://www.credly.com/badges/bc3f5b0b-46ec-4434-b1d9-e7982097f837"
    name        = "Azure Developer Associate"
  }
}

# Upload certAzureDev.png to the storage container
resource "azurerm_storage_blob" "certAzureDevops" {
  name                   = "certifications/certAzureDevops.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/certifications/certAzureDevops.png"
  content_type = "image/png"

  metadata = {
    badgeurl    = "https://www.credly.com/badges/b672a24f-dda1-4115-931e-cc1b438a2f73"
    name        = "Azure Devops"
  }
}

# Upload certCKAD.png to the storage container
resource "azurerm_storage_blob" "certCKAD" {
  name                   = "certifications/certCKAD.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/certifications/certCKAD.png"
  content_type = "image/png"

  metadata = {
    badgeurl    = "https://www.credly.com/badges/a76100da-c9d9-49c2-ace8-79978fdba020"
    name        = "CKAD"
  }
}

# Upload certExam480.png to the storage container
resource "azurerm_storage_blob" "certExam480" {
  name                   = "certifications/certExam480.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/certifications/certExam480.png"
  content_type = "image/png"

  metadata = {
    badgeurl    = "https://www.credly.com/badges/be10d2bf-269e-4d80-8028-4a595f5912ec"
    name        = "480"
  }
}

# Upload certOracle.png to the storage container
resource "azurerm_storage_blob" "certOracle" {
  name                   = "certifications/certOracle.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/certifications/certOracle.png"
  content_type = "image/png"

  metadata = {
    badgeurl    = "https://www.credly.com/badges/2f2524d9-a541-432f-b98c-5447b5c38b0a"
    name        = "Oracle"
  }
}

# Upload certScrum.png to the storage container
resource "azurerm_storage_blob" "certScrum" {
  name                   = "certifications/certScrum.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/certifications/certScrum.png"
  content_type = "image/png"

  metadata = {
    badgeurl    = "https://www.credly.com/badges/35f4bb95-5a30-428e-8233-a6d37a73eb07"
    name        = "Scrum"
  }
}

# Upload ArticleArch.png to the storage container
resource "azurerm_storage_blob" "article_arch" {
  name                   = "projects/article_arch.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/projects/ArticleArch.png"
  content_type = "image/png"
}

# Upload Pantryk8sArch.png to the storage container
resource "azurerm_storage_blob" "pantry_k8s_arch" {
  name                   = "projects/pantry_k8s_arch.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/projects/Pantryk8sArch.png"
  content_type = "image/png"
}

# Upload PantryLocalArch.png to the storage container
resource "azurerm_storage_blob" "pantry_local_arch" {
  name                   = "projects/pantry_local_arch.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/projects/PantryLocalArch.png"
  content_type = "image/png"
}

# Upload PortfolioArch.png to the storage container
resource "azurerm_storage_blob" "portfolio_arch" {
  name                   = "projects/portfolio_arch.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/projects/PortfolioArch.png"
  content_type = "image/png"
}

# Upload angular.png to the storage container
resource "azurerm_storage_blob" "angular_logo" {
  name                   = "technologies/angular.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/technologies/angular.png"
  content_type = "image/png"

  metadata = {
    name        = "Angular"
  }
}

# Upload aws.png to the storage container
resource "azurerm_storage_blob" "aws_logo" {
  name                   = "technologies/aws.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/technologies/aws.png"
  content_type = "image/png"

  metadata = {
    name        = "AWS"
  }
}

# Upload azure.png to the storage container
resource "azurerm_storage_blob" "azure_logo" {
  name                   = "technologies/azure.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/technologies/azure.png"
  content_type = "image/png"

  metadata = {
    name        = "Azure"
  }
}

# Upload csharp.png to the storage container
resource "azurerm_storage_blob" "csharp_logo" {
  name                   = "technologies/csharp.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/technologies/csharp.png"
  content_type = "image/png"

  metadata = {
    name        = "C#"
  }
}

# Upload docker.png to the storage container
resource "azurerm_storage_blob" "docker_logo" {
  name                   = "technologies/docker.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/technologies/docker.png"
  content_type = "image/png"

  metadata = {
    name        = "Docker"
  }
}

# Upload git.png to the storage container
resource "azurerm_storage_blob" "git_logo" {
  name                   = "technologies/git.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/technologies/git.png"
  content_type = "image/png"

  metadata = {
    name        = "Git"
  }
}

# Upload helm.png to the storage container
resource "azurerm_storage_blob" "helm_logo" {
  name                   = "technologies/helm.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/technologies/helm.png"
  content_type = "image/png"

  metadata = {
    name        = "Helm"
  }
}

# Upload k8s.png to the storage container
resource "azurerm_storage_blob" "k8s_logo" {
  name                   = "technologies/k8s.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/technologies/k8s.png"
  content_type = "image/png"

  metadata = {
    name        = "Kubernetes"
  }
}

# Upload powershell.png to the storage container
resource "azurerm_storage_blob" "powershell_logo" {
  name                   = "technologies/powershell.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/technologies/powershell.png"
  content_type = "image/png"

  metadata = {
    name        = "PowerShell"
  }
}

# Upload specflow.png to the storage container
resource "azurerm_storage_blob" "specflow_logo" {
  name                   = "technologies/specflow.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/technologies/specflow.png"
  content_type = "image/png"

  metadata = {
    name        = "SpecFlow"
  }
}

# Upload sql.png to the storage container
resource "azurerm_storage_blob" "sql_logo" {
  name                   = "technologies/sql.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/technologies/sqlserver.png"
  content_type = "image/png"

  metadata = {
    name        = "SQL Server"
  }
}

# Upload mongodb.png to the storage container
resource "azurerm_storage_blob" "mongodb_logo" {
  name                   = "technologies/mongodb.png"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/technologies/mongodb.png"
  content_type = "image/png"

  metadata = {
    name        = "MongoDB"
  }
}

# Upload Resume.pdf to the storage container
resource "azurerm_storage_blob" "resume_pdf" {
  name                   = "resume/resume.pdf"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/resume/resume.pdf"
  content_type = "application/pdf"

  metadata = {
    description        = "View My Resume"
  }
}

# Upload Competence.pdf to the storage container
resource "azurerm_storage_blob" "competence_pdf" {
  name                   = "resume/competence.pdf"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source = "${path.module}/assets/resume/competence.pdf"
  content_type = "application/pdf"

  metadata = {
    description        = "View My Competence Dossier"
  }
}

# Create the Linux App Service Plan for Azure Function
resource "azurerm_service_plan" "functionserviceplan" {
  name                = var.function_service_plan_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

# Create the Linux App Service Plan for Web Apps
resource "azurerm_service_plan" "appserviceplan" {
  depends_on = [azurerm_service_plan.functionserviceplan]
  name                = var.webb_app_service_plan_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

# Create the web app
resource "azurerm_linux_web_app" "webapp" {
  name                  = var.ui_app_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  
  site_config { 
    minimum_tls_version = "1.2"
    always_on = false
  }

}

# Create the web app api
resource "azurerm_linux_web_app" "webappapi" {
  name                  = var.api_app_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  app_settings = {
    "BlobConfigurations__AccountName"     = azurerm_storage_account.storageacc.name
    "BlobConfigurations__ContainerName"   = azurerm_storage_container.container.name
    "BlobConfigurations__ContainerUrl"    = "https://{0}.blob.core.windows.net/{1}"
    "CosmosConfiguration__AccountEndpoint" = azurerm_cosmosdb_account.portfolio_contact_form.endpoint
    "CosmosConfiguration__Database"    = azurerm_cosmosdb_sql_database.contact_db.name
    "CosmosConfiguration__Container"   = azurerm_cosmosdb_sql_container.contact_container.name
    "WEBSITES_PORT"   = "8080"
  }

  site_config { 
    minimum_tls_version = "1.2"
    always_on = false

  }
    identity {
      type = "SystemAssigned"
    }
}

# Create the role assignment for the web app to access the storage account
resource "azurerm_role_assignment" "api_storage_reader" {
  scope                = azurerm_storage_account.storageacc.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_linux_web_app.webappapi.identity[0].principal_id
}

# Look up existing App Configuration
data "azurerm_app_configuration" "appconfig" {
  name                = var.shared_app_configuration_name
  resource_group_name = var.shared_rg_name
}

# Create the role assignment for the web app to access the configuration account
resource "azurerm_role_assignment" "api_configuration_reader" {
  scope                = data.azurerm_app_configuration.appconfig.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_linux_web_app.webappapi.identity[0].principal_id
}

# Create the az function
resource "azurerm_linux_function_app" "functionapi" {
  name                = "matheus-portfolio-function-v2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.storageacc.name
  storage_account_access_key = azurerm_storage_account.storageacc.primary_access_key
  service_plan_id            = azurerm_service_plan.functionserviceplan.id


  app_settings = {
    "BlobConfigurations__AccountName"     = azurerm_storage_account.storageacc.name
    "BlobConfigurations__ContainerName"   = azurerm_storage_container.container.name
    "BlobConfigurations__ContainerUrl"    = "https://{0}.blob.core.windows.net/{1}"
    "FUNCTIONS_WORKER_RUNTIME"              = "dotnet-isolated"
  }

 site_config {
    application_stack {
      dotnet_version              = "10.0"
      use_dotnet_isolated_runtime = true
    }
  }
  identity {
      type = "SystemAssigned"
    }
}

# Create the role assignment for the function to access the storage account
resource "azurerm_role_assignment" "function_storage_reader" {
  scope                = azurerm_storage_account.storageacc.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_linux_function_app.functionapi.identity[0].principal_id
}

# Create Api Management
resource "azurerm_api_management" "portfolioapimgmt" {
  name                = "portfolio-apim"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "portfolio-apim"
  publisher_email     = "matheus.sexto@gmail.com"

  sku_name = "Consumption_0"
}

# Create Api Management Open Api
resource "azurerm_api_management_api" "openapi" {
  name                = "MicroservicePortfolio"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.portfolioapimgmt.name
  revision            = "1"
  display_name        = "MicroservicePortfolio"
  service_url         = "https://matheus-portfolio-api-v2.azurewebsites.net"
  path                = ""
  protocols           = ["https"]

  import {
    content_format = "openapi+json-link"
    content_value  = "https://matheus-portfolio-api.azurewebsites.net/swagger/v1/swagger.json"
  }
}

# Create Api Management Function Api
resource "azurerm_api_management_api" "functionapi" {
  name                = "PortifolioFunctionApp"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.portfolioapimgmt.name
  revision            = "1"
  display_name        = "PortifolioFunctionApp"
  service_url         = "https://matheus-portfolio-function-v2.azurewebsites.net" 
  path                = "function"
  protocols           = ["https"]
  
}

# Create Api Management Product
resource "azurerm_api_management_product" "portfolio_public" {
  product_id          = "portfolio-public"  # URL-safe ID, shown in portal
  api_management_name = azurerm_api_management.portfolioapimgmt.name
  resource_group_name = azurerm_resource_group.rg.name

  display_name        = "Portfolio Public"
  description         = "Public APIs for the portfolio site."

  # Whether a subscription key is required
  subscription_required = false
  approval_required     = false
  published             = true
  subscriptions_limit   = 0        # 0 = unlimited

  terms = "By using this API you agree to the portfolio terms of service."
}

resource "azurerm_api_management_product_api" "portfolio_public_openapi" {
  api_management_name = azurerm_api_management.portfolioapimgmt.name
  resource_group_name = azurerm_resource_group.rg.name

  product_id = azurerm_api_management_product.portfolio_public.product_id
  api_name   = azurerm_api_management_api.openapi.name
}

resource "azurerm_api_management_product_api" "portfolio_public_functionapi" {
  api_management_name = azurerm_api_management.portfolioapimgmt.name
  resource_group_name = azurerm_resource_group.rg.name

  product_id = azurerm_api_management_product.portfolio_public.product_id
  api_name   = azurerm_api_management_api.functionapi.name
}

# resource "azurerm_api_management_backend" "api_function_backend" {
#   name                = "matheus-portfolio-function-v2-test-backend"
#   resource_group_name = azurerm_resource_group.rg.name
#   api_management_name = azurerm_api_management.portfolioapimgmt.name
#   protocol            = "http"
#   url                 = "https://matheus-portfolio-function-v2.azurewebsites.net/api"

#    credentials {
#     header = {
#       "x-functions-key" = var.function_key
#     }
#   }
# }

resource "azurerm_api_management_api_operation" "get_certifications" {
  operation_id        = "get-certifications"
  api_name            = azurerm_api_management_api.functionapi.name
  api_management_name = azurerm_api_management_api.functionapi.api_management_name
  resource_group_name = azurerm_api_management_api.functionapi.resource_group_name
  display_name        = "certifications"
  method              = "GET"
  url_template        = "/certifications"
}

resource "azurerm_api_management_api_operation" "get_environment" {
  operation_id        = "environment"
  api_name            = azurerm_api_management_api.functionapi.name
  api_management_name = azurerm_api_management_api.functionapi.api_management_name
  resource_group_name = azurerm_api_management_api.functionapi.resource_group_name
  display_name        = " environment"
  method              = "GET"
  url_template        = "/environment"
}

resource "azurerm_api_management_api_operation" "get_projects" {
  operation_id        = "projects"
  api_name            = azurerm_api_management_api.functionapi.name
  api_management_name = azurerm_api_management_api.functionapi.api_management_name
  resource_group_name = azurerm_api_management_api.functionapi.resource_group_name
  display_name        = "projects"
  method              = "GET"
  url_template        = "/projects"
}

resource "azurerm_api_management_api_operation" "get_resume" {
  operation_id        = "resume"
  api_name            = azurerm_api_management_api.functionapi.name
  api_management_name = azurerm_api_management_api.functionapi.api_management_name
  resource_group_name = azurerm_api_management_api.functionapi.resource_group_name
  display_name        = "resume"
  method              = "GET"
  url_template        = "/resume"
}

resource "azurerm_api_management_api_operation" "get_technologies" {
  operation_id        = "technologies"
  api_name            = azurerm_api_management_api.functionapi.name
  api_management_name = azurerm_api_management_api.functionapi.api_management_name
  resource_group_name = azurerm_api_management_api.functionapi.resource_group_name
  display_name        = "technologies"
  method              = "GET"
  url_template        = "/technologies"
}

resource "azurerm_api_management_api_operation" "post_contact" {
  operation_id        = "contact"
  api_name            = azurerm_api_management_api.functionapi.name
  api_management_name = azurerm_api_management_api.functionapi.api_management_name
  resource_group_name = azurerm_api_management_api.functionapi.resource_group_name
  display_name        = "contact"
  method              = "POST"
  url_template        = "/contact"
}

resource "azurerm_api_management_policy" "portfolioapipolicy" {
  api_management_id = azurerm_api_management.portfolioapimgmt.id
  xml_content = <<XML
<policies>
    <inbound>
        <cors allow-credentials="false">
            <allowed-origins>
                <origin>https://matheus.azurewebsites.net/</origin>
            </allowed-origins>
            <allowed-methods>
                <method>GET</method>
                <method>POST</method>
            </allowed-methods>
        </cors>
        <choose>
            <when condition="@(context.Request.Url.Query.GetValueOrDefault("api") == "function")">
                <set-backend-service base-url="https://portfolio-apim.azure-api.net/function/" />
            </when>
        </choose>
    </inbound>
    <backend>
        <forward-request />
    </backend>
    <outbound />
    <on-error />
</policies>
XML
}

# resource "azurerm_api_management_api_policy" "portfolioafunctionpolicy" {
#   api_management_name = azurerm_api_management.portfolioapimgmt.name
#   resource_group_name = azurerm_resource_group.rg.name
#   api_name      = azurerm_api_management_api.functionapi.name

#   xml_content = <<XML
# <policies>
#   <inbound>
#     <base />
#     <set-backend-service backend-id="${azurerm_api_management_backend.api_function_backend.name}" />
#   </inbound>
#   <backend>
#     <base />
#   </backend>
#   <outbound>
#     <base />
#   </outbound>
#   <on-error>
#     <base />
#   </on-error>
# </policies>
# XML
# }

#Create Cosmos DB Account
resource "azurerm_cosmosdb_account" "portfolio_contact_form" {
  name                = "matheus-portfolio-contact-form"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  offer_type = "Standard"          # databaseAccountOfferType
  kind       = "GlobalDocumentDB"  # SQL (Core) API
  free_tier_enabled = true
  public_network_access_enabled = true
  is_virtual_network_filter_enabled = false
  analytical_storage_enabled    = false
  minimal_tls_version = "Tls12"
  capabilities {
    name = "EnableServerless"      # capabilities: EnableServerless :contentReference[oaicite:1]{index=1}
  }
  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }
  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_cosmosdb_sql_database" "contact_db" {
  name                = "contact-db"
  resource_group_name = azurerm_cosmosdb_account.portfolio_contact_form.resource_group_name
  account_name        = azurerm_cosmosdb_account.portfolio_contact_form.name
}

resource "azurerm_cosmosdb_sql_container" "contact_container" {
  name                = "messages"
  resource_group_name = azurerm_cosmosdb_account.portfolio_contact_form.resource_group_name
  account_name        = azurerm_cosmosdb_account.portfolio_contact_form.name
  database_name       = azurerm_cosmosdb_sql_database.contact_db.name
  partition_key_paths = ["/id"]
}

resource "azurerm_cosmosdb_sql_role_assignment" "webapp_cosmos_data_contributor" {
  name                = "3f67e3a4-3ab3-4f95-9f5c-26f6c0a01234"
  resource_group_name = azurerm_cosmosdb_account.portfolio_contact_form.resource_group_name
  account_name        = azurerm_cosmosdb_account.portfolio_contact_form.name
  # Built-in Cosmos DB Data Contributor role
  role_definition_id  = "${azurerm_cosmosdb_account.portfolio_contact_form.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = azurerm_linux_web_app.webappapi.identity[0].principal_id
  scope               = azurerm_cosmosdb_account.portfolio_contact_form.id
}