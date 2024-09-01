# Lab 2: Parametrizing My Template
## Objective: 
Modify the solution from Lab 1 to include a parameters.bicep file. You will parameterize the web app name, app service plan, location, and include a secure parameter for the database password. We'll also introduce output functions and Bicep functions like uniqueString.

## Instructions
Create two files:
1. main.bicep: The main deployment file.
2. parameters.bicepparms: To hold parameters for the deployment.
Understand Decorators: You will use decorators like @description() and @allowed() to provide context and validation.

## Deployment instructions

```pwsh
# Log in to Azure
az login

# Set the variables
$resourceGroupName = "myResourceGroup"
$location = "EastUS"
$templateFile = "main.bicep"
$parameterFile = "parameters.bicepparams"

# Create the resource group
az group create --name $resourceGroupName --location $location

# Deploy the Bicep template
az deployment group create --resource-group $resourceGroupName --template-file $templateFile --parameter $parameterFile
```
Or

```pwsh
# Login to azure
az login

# Set the variables
$resourceGroupName = "myResourceGroup"
$location = "EastUS"
$templateFile = "main.bicep"
$parameterFile = "parameters.bicepparams"

# Create the resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Deploy the Bicep template
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -TemplateParameterFile $parameterFile
```