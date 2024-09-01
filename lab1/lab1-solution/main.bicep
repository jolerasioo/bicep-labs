// Lab 1: My First Bicep Deployment

resource webAppPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'myAppServicePlan'
  location: 'uksouth'
  sku: {
    tier: 'Standard'
    size: 'S1'
  }
  properties: {
    reserved: false
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'myFirstWebApp'
  location: 'uksouth'
  properties: {
    serverFarmId: webAppPlan.id
  }
}

output webAppUrl string = webApp.properties.defaultHostName
