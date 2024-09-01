// params and vars
@maxLength(15)
@description('String with a unique identifyer of the project')
param projectUniqueName string = 'bicepwslab'

@allowed([
  'uksouth'
  'ukwest'
  'northeurope'
  'westeurope'
])
@description('The location for all resources')
param location string = 'uksouth'

@allowed([
  'dev'
  'prod'
])
@description('The environment name (dev or prod)')
param environmentName string = 'dev'

@secure()
@description('SQL Admin Password')
param sqlAdminPassword string


// variables
@description('Key Vault Secret Name for the Sql Connection String')
var kvSecretName = 'SqlConnectionString'



// scope to subscription
targetScope = 'subscription'


// resource group
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${projectUniqueName}-${environmentName}'
  location: location
  tags: {
    environment: environmentName
  }
}

// web app module
module webAppModule './modules/webApp.bicep' = {
  name: 'webApp-${environmentName}'
  scope: resourceGroup(rg.id)
  params: {
    environmentName: environmentName
    location: location
    uniqueProjectName: projectUniqueName
    kvSecretName: kvSecretName
  }
}

// sql module
module sqlModule './modules/sql.bicep' = {
  name: 'sql-${environmentName}'
  scope: resourceGroup(rg.id)
  params: {
    environmentName: environmentName
    location: location
    projectUniqueName: projectUniqueName
    kvSecretName: kvSecretName
    sqlAdminPassword: sqlAdminPassword
  }
}

// key vault module
module keyVaultModule './modules/keyVault.bicep' = {
  name: 'keyVault-${environmentName}'
  scope: resourceGroup(rg.id)
  params: {
    environmentName: environmentName
    location: location
    projectUniqueName: projectUniqueName
  }
}
