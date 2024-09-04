// Lab 4: Main Bicep Orchestrator for Dev and Prod environments

//@description('The environment name (dev or prod)')
//@allowed([
//  'dev'
//  'prod'
//])
//param environmentName string = 'dev'

@description('The location for all resources')
param location string = 'uksouth'

@description('A secure password for the database')
@secure()
param sqlAdminPassword string

@description('The base name for resource groups')
param rgBaseName string = 'aa-bicepws'

@description('Do you want to deploy a SQL Database?')
param deploySqlDb bool = true

param kvName string = 'kv-bicepws'


var envNames = [
  'dev'
  'prod'
]

@description('Resource Group names for each environment')
var rgNames = [
  '${rgBaseName}-${envNames[0]}'
  '${rgBaseName}-${envNames[1]}'
]

@description('Key Vault names for each environment')
var keyVaultNames = [
  '${kvName}-${envNames[0]}'
  '${kvName}-${envNames[1]}'
]


// set subscription as target scope
targetScope = 'subscription'

// Create resource groups for each environment
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = [for envName in envNames: {
  name: '${rgBaseName}-${envName}'
  location: location
}]

// Deploy the Web App module to both environments
module webAppModule './modules/webApp.bicep' = [for (envName, i) in envNames: {
  name: 'webApp-${envName}'
  scope: resourceGroup(rgNames[i])
  params: {
    environmentName: envName
    location: location
    keyVaultName: keyVaultNames[i]
  }
}]

// Conditionally deploy the SQL module only if enabled
module sqlModule './modules/sql.bicep' = [for (environmentName, i) in envNames: if (deploySqlDb) {
  name: 'sql-${environmentName}'
  scope: resourceGroup(rgNames[i])
  params: {
    sqlAdminPassword: sqlAdminPassword
    location: location
    keyVaultName: keyVaultNames[i]
  }
}]

module kvModule './modules/keyVault.bicep' = [for (environmentName, i) in envNames: {
  name: 'kv-${environmentName}'
  scope: resourceGroup(rgNames[i])
  params: {
    keyVaultName: keyVaultNames[i]
    location: location
    webAppName: 'webApp-${environmentName}'
  }
}]
