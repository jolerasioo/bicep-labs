// Lab 4: SQL Server and Database Module

@description('The location for all resources')
param location string

@description('SQL Server admin password')
@secure()
param sqlAdminPassword string


// SQL Server
resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: 'sqlserver-${uniqueString(location)}'
  location: location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: sqlAdminPassword
  }
}

// SQL Database
resource sqlDb 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  parent: sqlServer
  name: 'sqldb-${uniqueString(location)}'
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}

output sqlServerName string = sqlServer.name
output sqlDbName string = sqlDb.name
