

# Authenticate to Azure


Write-Output "Starting Runbook..."

[string] $FailureMessage = "Failed to execute the command"
[int] $RetryCount = 3 
[int] $TimeoutInSecs = 20
$RetryFlag = $true
$Attempt = 1

do
{
   $connectionName = "AzureRunAsConnection"
   try
   {
      Write-Output "Logging into Azure subscription using Az cmdlets..."
      
      # Get the connection "AzureRunAsConnection "
      $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName         

      $AzureContext = Add-AzAccount `
         -ServicePrincipal `
         -TenantId $servicePrincipalConnection.TenantId `
         -ApplicationId $servicePrincipalConnection.ApplicationId `
         -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
        
      Write-Output "Successfully logged into Azure subscription using Az cmdlets..."

      $RetryFlag = $false
   }
   catch 
   {
      if (!$servicePrincipalConnection)
      {
         $ErrorMessage = "Connection $connectionName not found."

         $RetryFlag = $false

         throw $ErrorMessage
      }

      if ($Attempt -gt $RetryCount) 
      {
         Write-Output "$FailureMessage! Total retry attempts: $RetryCount"

         Write-Output "[Error Message] $($_.exception.message) `n"

         $RetryFlag = $false
      }
      else 
      {
         Write-Output "[$Attempt/$RetryCount] $FailureMessage. Retrying in $TimeoutInSecs seconds..."

         Start-Sleep -Seconds $TimeoutInSecs

         $Attempt = $Attempt + 1
      }   
   }
}
while ($RetryFlag)

Write-Output "Current Context: $($AzureContext.Subscription)"
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

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
