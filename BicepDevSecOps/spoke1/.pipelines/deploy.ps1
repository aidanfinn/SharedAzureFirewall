param ($subscriptionId, $resourceGroupName, $location, $deploymentName, $templateFile, $templateParameterFile)
Write-Host "Verifying $MyInvocation.MyCommand deployment script parameter values:"
Write-Host "> subscriptionId: $subscriptionId"
Write-Host "> resourceGroupName: $resourceGroupName"
Write-Host "> location: $location"
Write-Host "> deploymentName: $deploymentName"
Write-Host "> templateFile: $templateFile"
Write-Host "> templateParameterFile: $templateParameterFile"


#########################################################
##### Check for the existence of the required files #####
#########################################################

Write-Host "Processing: Files availability verification"

# Check for the existence of the template file
if (!(Get-Item $templateFile -ErrorAction SilentlyContinue))
{
    # The template file cannot be found
    Write-Host "The $templateFile template file cannot be found" -ForegroundColor Red
    Break
}

# Check for the existence of the template parameter file
if (!(Get-Item $templateParameterFile -ErrorAction SilentlyContinue))
{
    # The template parameter file cannot be found
    Write-Host "The $templateParameterFile template parameter file cannot be found" -ForegroundColor Red
    Break
}


#########################################
##### Select the Azure Subscription ##### 
#########################################

Write-Host "Processing: Azure subscription selection"

try 
{
  # Deploy the template file to the resource group
  Write-Host "Selecting the subscription $subscriptionId"
  $subscriptionDetails = Select-AzSubscription $subscriptionId
  $subscriptionName = $subscriptionDetails.Name
  $tenantId = $subscriptionDetails.Tenant.Id
  Write-Host "Working on subscription $subscriptionName in tenant $tenantId"
  Start-Sleep -Seconds 5
}
catch 
{
  # Something went wrong with the subscription selection
  Write-Host "The subscription $subscription could not be selected" -ForegroundColor Red
  Break
}


##################################################
##### Create the resource group, if required ##### 
##################################################

Write-Host "Processing: Resource Group"

# Check the existence of the resource group
if (!(Get-AzResourceGroup $resourceGroupName -ErrorAction SilentlyContinue))
{ 
  try 
  {
    # The resource group does not exist so create it
    Write-Host "Creating the $resourceGroupName resource group"
    New-AzResourceGroup -Name $resourceGroupName -Location $location -ErrorAction SilentlyContinue
  }
  catch 
  {
    # There was an error creating the resoruce group
    Write-Host "There was an error creaating the $resourceGroupName resource group" -ForegroundColor Red
    Break
  }
}
else
{
  # The resoruce group already exists so there is nothing to do
  Write-Host "The $resourceGroupName resource group already exists"
}


###########################################################
##### Deploy or update the hub resources, if required #####
###########################################################

Write-Host "Processing: Deployment"

try 
{
  # Deploy the template file to the resource group
  Write-Host "Executing the $deploymentName deployment of $templateFile to $resourceGroupName"
  New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -TemplateParameterFile $templateParameterFile
}
catch 
{
  # Something went wrong with the deployment
  # We deliberately do not silently continue so we can see the ARM error on screen
  Write-Host "There was an error with the $deploymentName deployment of $templateFile to $resourceGroupName" -ForegroundColor Red
}