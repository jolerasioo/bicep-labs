// Lab 4: SQL Server and Database Module

@description('The location for all resources')
param location string

@description('SQL Server admin password')
@secure()
param sqlAdminPassword string
param sqlAdmin string = 'sqlAdmin'

param keyVaultName string 

param connectionStringSecretName string = 'SqlConnectionString'

// SQL Server
resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: 'sqlServer-${uniqueString(location)}'
  location: location
  properties: {
    administratorLogin: sqlAdmin
    administratorLoginPassword: sqlAdminPassword
  }
}

// SQL Database
resource sqlDb 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  parent: sqlServer
  name: 'sqlDb-${uniqueString(location)}'
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}


// existing keyvault resource
resource kv 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}


resource sqlConnectionSecret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: kv
  name: connectionStringSecretName
  properties: {
    value:'Server=tcp:${sqlServer.name}.database.windows.net,1433;Initial Catalog=${sqlDb.name};Persist Security Info=False;User ID=${sqlAdmin}};Password=${sqlAdminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
  }
}

output sqlServerName string = sqlServer.name
output sqlDbName string = sqlDb.name

