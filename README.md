# Portfolio API

* https://matheus.azurewebsites.net/

> This is my portfolio-api made in C# and .NET 7.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Build And Deploy Status

![Build And Deploy Api to Azure](https://github.com/matheus06/portfolio-api/actions/workflows/azure-container-webapp-api.yml/badge.svg)

![Build And Deploy Function to Azure](https://github.com/matheus06/portfolio-api/actions/workflows/azure-function-app.yml/badge.svg)

## Architeture

![architeture](/architeture/portfolio.png)

To see the UI app please go to this repo:

* <https://github.com/matheus06/portfolio-ui>

## Technologies

* C#
* .NET 7
* Azure App Service
* Azure Functions
* Twilio SendGrid
* Azure Blob Storage
* Azure Cosmos DB (No SQL)
* Azure API Management
* Azure App Configuration
* Azure Feature Manager
* Managed Identities for Azure Resources
* Github Actions
* Docker
* Terraform

## Assign Cosmos DB Built-in Data Contributor Role to your Managed Identity

* Managed identities provide an automatically managed identity in Azure Active Directory for applications to use when connecting to resources that support Azure Active Directory (Azure AD) authentication.
* In Azure Cosmos DB, we can use managed identities to provide resources with the roles and permissions required to perform actions on our data.
* It is not possible to assing these roles using Azure Portal so run this command only if you are deploying to Azure.

```bash
 az cosmosdb sql role assignment create --account-name {yourCosmosResourceName} --resource-group {yourResourceGroup} --scope "/" -p {yourAzureObjectID} --role-definition-id 00000000-0000-0000-0000-000000000002
```

Read more:

* <https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-setup-rbac>

## Azurite

* The Azurite open-source emulator provides a free local environment for testing your Azure Blob, Queue Storage, and Table Storage applications. 
* To run it locally with some files already in Azurite copy `azurite` repo folder to your local `c:/azurite`

```bash
 docker run -p 10000:10000 -p 10001:10001 -p 10002:10002 -v c:/azurite:/data mcr.microsoft.com/azure-storage/azurite
```

Read more:

* <https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azurite?tabs=visual-studio>
