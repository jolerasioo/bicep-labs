using './main.bicep'

//param appServicePlanName = ''
param webAppName = 'myWebApp-${uniqueString('webappy')}'
param webAppPlanSku = {
  tier: 'Basic'
  size: 'S1'
}
param location = 'eastus'
param isReservedAppPlan = false

