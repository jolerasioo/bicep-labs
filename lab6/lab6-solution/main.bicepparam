using './main.bicep'

param projectUniqueName = 'bicepwslab'
param location = 'uksouth'
param environmentName = 'dev'
@secure()
param sqlAdminPassword = ''


