# Lab 1: My First Bicep Deployment
## Objective: 
Deploy a simple Azure Web App and App Service Plan with hardcoded values to familiarize students with Bicep basics.

## Instructions
- Open VS Code: Make sure you have the Bicep extension installed and the Azure CLI set up.
- Create a new file: main.bicep.
- Write the Bicep template: This template will deploy a resource group, an App Service Plan, and a Web App with hardcoded values.

## Deployment instructions

```pwsh
# Log in to Azure
az login

# Set the variables
$resourceGroupName = "myResourceGroup"
$location = "EastUS"
$templateFile = "main.bicep"

# Create the resource group
az group create --name $resourceGroupName --location $location

# Deploy the Bicep template
az deployment group create --resource-group $resourceGroupName --template-file $templateFile
```
Or

```pwsh
# Login to azure
az login

# Set the variables
$resourceGroupName = "myResourceGroup"
$location = "EastUS"
$templateFile = "main.bicep"

# Create the resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Deploy the Bicep template
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile
```