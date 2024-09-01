// Lab 2: Parametrize My First Deployment

@description('The name of the App Service Plan')
param appServicePlanName string = 'asp-${uniqueString(resourceGroup().id)}'

@description('The name of the Web App')
param webAppName string = 'webapp-${uniqueString(resourceGroup().id)}'

@description('The SKU settings for the App Service Plan')
param webAppPlanSku object = {
  tier: 'Standard'
  size: 'S1'
}

@description('The location for all resources')
param location string= resourceGroup().location 

@allowed([
  false
  true
])
@description('Boolean for reserved App Service Plan')
param isReservedAppPlan bool = false


// App Service Plan
resource webAppPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    tier: webAppPlanSku.tier
    size:  webAppPlanSku.size
  }
  properties: {
    reserved: isReservedAppPlan
  }
}

// Web App
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: webAppPlan.id
  }
}


// Output the web app's URL
output webAppUrl string = webApp.properties.defaultHostName
