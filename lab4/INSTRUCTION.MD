```pwsh
az login

az deployment sub create --subscription "cb72b49c-6479-4ec7-891f-f18be9ee10f2" `
--template-file main.bicep --parameters @main-parameters.json  `
--location "uksouth" `
--parameters sqlAdminPassword="<your secure password>" `
#--what-if
```