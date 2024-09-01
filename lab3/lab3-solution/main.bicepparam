using './main.bicep'

param appServicePlanName = 'asp-bicepws-${sys.uniqueString(uniqueString)}'
param webAppName = 'webapp-bicepws-${sys.uniqueString(uniqueString)}'
 param sqlAdminPassword = ''

var uniqueString = 'jolerasioo'

