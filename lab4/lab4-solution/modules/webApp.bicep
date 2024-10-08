// Lab 4: Web App and App Service Plan Module

@description('The environment name (dev or prod)')
param environmentName string

@description('The location for all resources')
param location string

// Modify SKU based on environment
var sku = environmentName == 'prod' ? {
  tier: 'Standard'
  name: 'S2'
} : {
  tier: 'Standard'
  name: 'S1'
}

// App Service Plan
resource webAppPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'wasp-bicepws-${environmentName}'
  location: location
  sku: sku
  properties: {
    reserved: false
  }
}

// Web App
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'wap-bicepws-${environmentName}'
  location: location
  properties: {
    serverFarmId: webAppPlan.id
  }
}

output webAppUrl string = webApp.properties.defaultHostName
