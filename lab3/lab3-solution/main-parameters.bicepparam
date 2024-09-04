using './main.bicep'

param appServicePlanName = 'asp-bicepws-${sys.uniqueString(myUniqueString)}'
param webAppName = 'webapp-bicepws-${sys.uniqueString(myUniqueString)}'
var myUniqueString = 'bicepws'
param sqlServerName = 'sqlserver-${uniqueString(myUniqueString)}'
param sqlAdminPassword =  '/*TODO*/'
param sqlDbName =  'sqldb-${uniqueString(myUniqueString)}'
