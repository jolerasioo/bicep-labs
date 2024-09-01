param location string = resourceGroup().location
param uniqueProjectName string
param kvSecretName string
param environmentName string = 'dev'

var webAppPlanName = 'asp-${uniqueProjectName}-${environmentName}'
var webAppSiteName = 'web-${uniqueProjectName}-${environmentName}'
var appInsightsName = 'appins-${uniqueProjectName}-${environmentName}'
var enableAppInsights = environmentName == 'prod' ? true : false
var keyVaultName = 'kv-${uniqueProjectName}-${environmentName}'


// resources
resource webAppPlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: webAppPlanName
  location: location
  sku: {
    name: environmentName == 'prod' ? 'S1' : 'B1'
    tier: environmentName == 'prod' ? 'Standard' : 'Basic'
  }
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: webAppSiteName
  location: location
  properties: {
    serverFarmId: webAppPlan.id
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// Application Insights resource, only deployed if enabled
resource appInsights 'Microsoft.Insights/components@2020-02-02' = if (enableAppInsights) {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Redfield'
    Request_Source: 'AzureBicep'
    IngestionMode: 'ApplicationInsights'
  }
}

// Configure the Web App to send telemetry to Application Insights
resource appInsightsConfig 'Microsoft.Web/sites/config@2022-03-01' = if (enableAppInsights) {
  name: 'appsettings'
  parent: webApp
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsights.properties.InstrumentationKey
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsights.properties.ConnectionString
    ApplicationInsightsAgent_EXTENSION_VERSION: '~3'  // Enable AI agent in the web app
  }
}

// Configure the Web App to connect to the SQL Database via existing Key Vault
resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource appConfig 'Microsoft.Web/sites/config@2023-12-01' = {
  name: 'connectionstrings'
  parent: webApp
  properties: {
    sqlConnectionString: {
        value: '@Microsoft.KeyVault({VaultName=${kv.name};SecretName=${kvSecretName}})'
        type: 'SQLServer'
    }
  }
}


output webAppUrl string = webApp.properties.defaultHostName
output appInsightsUrl string = appInsights.properties.AppId





//// reference to the exisiting env key vault for hierarchical deployment
//resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
//  name: keyVaultName
//}
//
//// must have role access policy configured to access the key vault
//// this has been done in the keyvault.bicep file
//resource appConfig 'Microsoft.Web/sites/config@2023-12-01' = {
//  name: 'connectionstrings'
//  parent: webApp
//  properties: {
//    sqlConnectionString: {
//        value: '@Microsoft.KeyVault({VaultName=${kv.name};SecretName=${kvSecretName}})'
//        type: 'SQLServer'
//    }
//  }
//}


//resource keyVaultAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
//  parent: kv
//  name: 'add'
//  properties: {
//    accessPolicies: [
//      {
//        tenantId: subscription().tenantId
//        objectId: webApp.identity.principalId
//        permissions: {
//          keys: [
//            'get',
//            'list'
//          ]
//          secrets: [
//            'get',
//            'list'
//          ]
//        }
//      }
//    ]
//  }
//}
