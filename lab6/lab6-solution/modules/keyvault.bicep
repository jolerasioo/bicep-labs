param location string = resourceGroup().location
param projectUniqueName string
param environmentName string = 'dev'

var webAppName = 'web-${projectUniqueName}-${environmentName}'
var keyVaultName = 'kv-${projectUniqueName}-${environmentName}'



resource webApp 'Microsoft.Web/sites@2021-02-01' existing = {
  name: webAppName
}

// access policies might be a different resource
resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: webApp.identity.principalId  // reference the web app sys assigned managed id
        permissions: {
          keys: [
            'get'
            'list'
          ]
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
}




