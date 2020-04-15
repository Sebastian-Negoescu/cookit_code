# Connect to Azure using the right context

$subName = "VSEnterprise_DEV"
$tenantName = "sebinego.onmicrosoft.com"
Write-Host "Current Service Principal used is http://AzDevOps" -ForegroundColor DarkYellow
$pwd = Read-Host "Enter your SP's secret: " -AsSecureString
$creds = New-Object System.Management.Automation.PSCredential("http://AzDevOps", $pwd)
Connect-AzAccount -ServicePrincipal -Credential $creds -Subscription $subName -Tenant $tenantName

# Check if RG Exists - if not, create it.
$masterFile = (Get-ChildItem -Recurse -Filter "master.json" | Select-Object FullName).FullName
Write-Host "Master file located at: $($masterFile)" -ForegroundColor DarkYellow
$masterContent = Get-Content $masterFile | ConvertFrom-JSON
$prefix = $masterContent.parameters.prefix.defaultValue
$rgName = $prefix + "_rg"

Get-AzResourceGroup -Name $rgName -ErrorAction SilentlyContinue
If ($?) {
    Write-Host "Resource Group already exists - continue the deployment process."
} Else {
    Write-Host "Resource Group $($rgName) does not exist yet. Let's create it first..."
    New-AzResourceGroup -Name $rgName -Location "West Europe"
    Write-Host "Resource Group $($rgName) created. Let's continue the deployment process."
}

# Test Deployment
$repoUrl = $masterContent.variables.repoUrl
$eligibleBranch = @("master", "dev")
$branch = (Read-Host "Choose one of the following branches - MASTER / DEV").ToLower()
If ($eligibleBranch.Contains($branch)) {
    $templateUri = $repoUrl + $branch + '/cookit_infra/master.json'
    $testCommand = Test-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateUri $templateUri -branch $branch

    If (!($testCommand.Code)) {
        Write-Host "Looks like there were no syntax errors. Let's deploy the template now!" -ForegroundColor DarkYellow
        New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateUri $templateUri -branch $branch
        Write-Host "Deployment finished!" -ForegroundColor DarkYellow
    } Else {
        Write-Host "Oopsie - there were some template validation errors. Check them below:" -ForegroundColor DarkYellow
        Write-Host "Deployment Error Code: " $testCommand.Code -ForegroundColor DarkYellow
        Write-Host "Deployment Error Message: " $testCommand.Message -ForegroundColor DarkYellow
    }
}
Else {
    Write-Host "The specified branch - $($branch) - is not eligible. Please try again..."
}