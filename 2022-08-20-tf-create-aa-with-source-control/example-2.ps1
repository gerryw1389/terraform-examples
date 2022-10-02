
##############
# Authenticate to Azure: https://learn.microsoft.com/en-us/azure/automation/enable-managed-identity-for-automation#authenticate-access-with-system-assigned-managed-identity
##############
Write-Output "Starting Runbook..."
# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context

# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext
Write-Output "Successfully authenticated and logged in using Automation Accounts System Identity"
##############

$VMObjects = Get-AZVM -DefaultProfile $CurrentContext

If ( $($VMObjects.count) -gt 0)
{
   Foreach ( $VM in $VMObjects)
   {
      Write-Output "Virtual machine name: $($VM.Name)" 
   }
}
Else
{
   Write-Output "Subscription has no VM objects"
}
Write-Output "Current Virtual Machines: $VMs"

Function Get-MyVar
{
   $Variable = Get-AzAutomationVariable -AutomationAccountName "aa-sbx-scus-aa" -Name "tfex-example-var" -ResourceGroupName "aa-sbx-scus-aa-rg"
   $val = $Variable.value
   return $val
}

Write-Output "Example reading vars...."

$var_value = Get-MyVar
Write-Output "Variable value: $var_value"

Write-output "This is example 2"