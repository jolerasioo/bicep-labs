// Lab 1: My First Bicep Deployment
// please change the name of the resources to a globally unique name

resource webAppPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'ji-asp-myfirstwebapp'
  location: 'uksouth'
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
  properties: {
    reserved: false
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'ji-webapp-myfirstwebapp'
  location: 'uksouth'
  properties: {
    serverFarmId: webAppPlan.id
  }
}

output webAppUrl string = webApp.properties.defaultHostName

