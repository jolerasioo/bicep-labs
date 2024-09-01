// Lab 4: Web App and App Service Plan Module

@description('The environment name (dev or prod)')
param environmentName string

@description('The location for all resources')
param location string

@description('Key Vault name to reference')
param keyVaultName string


// Modify SKU based on environment
var sku = environmentName == 'prod' ? {
  tier: 'Standard'
  size: 'S2'
} : {
  tier: 'Standard'
  size: 'S1'
}




// App Service Plan
resource webAppPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'appServicePlan-${environmentName}'
  location: location
  sku: sku
  properties: {
    reserved: false
  }
}

// Web App
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'webApp-${environmentName}'
  location: location
  properties: {
    serverFarmId: webAppPlan.id
    keyVaultReferenceIdentity: 'SystemAssigned'
    //identity: {
    //  type: 'SystemAssigned'
    //}
  }
}   

resource kv 'Microsoft.KeyVault/vaults@2024-04-01-preview' existing = {
  name: keyVaultName
}

resource keyVaultAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2024-04-01-preview' = {
  parent: kv
  name: 'add'
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: webApp.identity.principalId
        permissions: {
          keys: [
            'get'
            'list'
          ]
          secrets: [
            'get'
            'list'
          ]
          certificates: []
        }
      }
    ]
  }
}

resource SqlConnectionStringConfig 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'connectionstrings'
  kind: 'string'
  parent: webApp
  properties: {
    SQLCONNECTIONSTRING: {
      value:'@Microsoft.KeyVault(SecretUri=https://${keyVaultName}.vault.azure.net/secrets/sql-connection-string)'
      type: 'SQLAzure'
    }
  }
} 


output webAppUrl string = webApp.properties.defaultHostName
