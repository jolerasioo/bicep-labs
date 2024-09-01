param projectUniqueName string
param environmentName string = 'dev'
param location string = resourceGroup().location
param kvSecretName string = 'SqlConnectionString'

@secure()
param sqlAdminPassword string


var sqlServerName = 'sql-serv-${projectUniqueName}-${environmentName}'
var sqlDbName = 'sql-db-${projectUniqueName}-${environmentName}'
var keyVaultName = 'kv-${projectUniqueName}-${environmentName}'



// sql server resource
resource sqlServer 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: sqlAdminPassword
    version: '12.0'
  }
}

// sql database resource
resource sqlDb 'Microsoft.Sql/servers/databases@2023-08-01-preview' = {
  parent: sqlServer
  name: sqlDbName
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}

// key vault existing resource
resource kv 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}

// key vault secret resource
resource kvSecret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: kv
  name: kvSecretName
  properties: {
    value: listKeys(sqlServer.id, '2021-08-01-preview').primaryConnectionString
  }
}
