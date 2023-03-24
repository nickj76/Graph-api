﻿## install Graph & Connect-MgGraph -Scopes "User.Read.All","UserAuthenticationMethod.Read.All"
Param
(
    [Parameter(Mandatory = $false)]
    [switch]$CreateSession
)
 #Check for module installation
 $Module=Get-Module -Name microsoft.graph -ListAvailable
 if($Module.count -eq 0) 
 { 
  Write-Host Microsoft Graph PowerShell SDK is not available  -ForegroundColor yellow  
  $Confirm= Read-Host Are you sure you want to install module? [Y] Yes [N] No 
  if($Confirm -match "[yY]") 
  { 
   Write-host "Installing Microsoft Graph PowerShell module..."
   Install-Module Microsoft.Graph -Repository PSGallery -Scope CurrentUser -AllowClobber -Force
  }
  else
  {
   Write-Host "Microsoft Graph PowerShell module is required to run this script. Pleaseinstall module using Install-Module Microsoft.Graph cmdlet." 
   Exit
  }
 }
 #Disconnect Existing MgGraph session
 if($CreateSession.IsPresent)
 {
  Disconnect-MgGraph
 }
 #Connecting to MgGraph beta
 Select-MgProfile -Name beta
 Write-Host Connecting to Microsoft Graph...
 Connect-MgGraph -Scopes "User.Read.All","UserAuthenticationMethod.Read.All"


if((Get-MgContext) -ne "")
{
 Write-Host Connected to Microsoft Graph PowerShell using (Get-MgContext).Account account -ForegroundColor Yellow
}
