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
      version = "~> 4.5"   # or just "~> 4.0" to stay on 4.x
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
  container_access_type = "private"
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
  
    application_stack {
        docker_registry_username = var.registry_username
        docker_registry_password = var.registry_password
        docker_image_name   = var.ui_image_name
        docker_registry_url = var.registry_url
    }
     
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
    "CosmosConfiguration__DatabaseName"    = azurerm_cosmosdb_sql_database.contact_db.name
    "CosmosConfiguration__ContainerName"   = azurerm_cosmosdb_sql_container.contact_container.name
  }

  site_config { 
    minimum_tls_version = "1.2"
    always_on = false
  
    application_stack {
        docker_registry_username = var.registry_username
        docker_registry_password = var.registry_password
        docker_image_name   = var.api_image_name
        docker_registry_url = var.registry_url
    } 
  }
    identity {
      type = "SystemAssigned"
    }
}

# Create the role assignment for the web app to access the storage account
resource "azurerm_role_assignment" "ui_storage_reader" {
  scope                = azurerm_storage_account.storageacc.id
  role_definition_name = "Storage Blob Data Reader"
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

  site_config {}
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
  path                = "portfolio"
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

resource "azurerm_api_management_api_operation" "hello_get" {
  operation_id        = "certifications"
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
                <set-backend-service base-url="https://portfolio-api.azure-api.net/function/" />
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