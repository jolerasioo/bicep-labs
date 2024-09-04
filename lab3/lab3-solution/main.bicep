// Lab 3: Adding Logic

@description('The name of the App Service Plan')
param appServicePlanName string

@description('The name of the Web App')
param webAppName string

@description('The location for all resources')
param location string = resourceGroup().location

@description('Do you want to deploy a SQL Database?')
@allowed([
  true
  false
])
param deploySqlDb bool = true

@description('The name of the SQL Server')
param sqlServerName string 

@description('The name of the SQL Database')
param sqlDbName string 

@description('SQL Server admin username')
param sqlAdminUsername string = 'sqladmin'

@description('SQL Server admin password')
@secure()
param sqlAdminPassword string



// App Service Plan
resource webAppPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    tier: 'Standard'
    name: 'S1'
  }
  properties: {
    reserved: false
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

// Conditional deployment of SQL Server and Database
resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = if (deploySqlDb) {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdminUsername
    administratorLoginPassword: sqlAdminPassword
  }
}

resource sqlDb 'Microsoft.Sql/servers/databases@2022-02-01-preview' = if (deploySqlDb) {
  parent: sqlServer
  name: sqlDbName
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}

// Outputs
output uniqueWebAppSuffix string = uniqueString(resourceGroup().id)
output webAppUrl string = webApp.properties.defaultHostName
output sqlServerName string = (deploySqlDb ? sqlServer.name : 'N/A')
output sqlDbName string = (deploySqlDb ? sqlDb.name : 'N/A')
