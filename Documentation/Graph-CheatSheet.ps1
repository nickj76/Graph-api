#Graph API commands need to be run in Powershell 7
General Commands

#Connect to Microsoft Graph: The ‘Connect-MgGraph’ cmdlet allows you to connect to Microsoft Graph PowerShell. You will need to sign in with an admin account to consent to the required scopes.
Connect-MgGraph -Scopes “User.Read.All” 

#If you want to connect to Microsoft Graph with multiple scopes, you can provide them as comma- separated values.
Connect-MgGraph -Scopes “User.Read.All”,”Group.ReadWrite.All”

#View Microsoft Graph PowerShell Commands:
Get-Command -Module Microsoft.Graph.Users 

#To view all the Microsoft Graph cmdlets, execute the following cmdlet.
Get-Command -Module Microsoft.Graph.*  

#To connect to another tenant, you must disconnect the Microsoft Graph session using the following cmdlet.
Disconnect-MgGraph 

#To avoid using an earlier token cache, you can connect to Microsoft Graph using ‘TenantId’ as below.
Connect-MgGraph -TenantId <TenantId> 

#To update the SDK, you can use the following cmdlet.
Update-Module Microsoft.Graph

#If you want to uninstall the Microsoft Graph PowerShell module, you must uninstall the main module first. And then all its dependency modules.
Uninstall-Module Microsoft.Graph 
Get-InstalledModule Microsoft.Graph.* | %{ if($_.Name -ne "Microsoft.Graph.Authentication"){ Uninstall-Module $_.Name } }  
Uninstall-Module Microsoft.Graph.Authentication 

User Stuff

#Show all users [kinda like Get-ADUser –Filter *]
Get-MgUser

#Find a user based on an attribute
Get-MgUser | Where-Object {$_.Mail -like "*@gmail.com"}

#Update a user's info
Update-MgUser -UserId (Get-MgUser -Filter "DisplayName eq '<firstname> <lastname> ADM'").Id -BusinessPhones "(123) 456-7890" -MobilePhone "(123) 456-7890"

#Confirm
Get-MgUser -Filter "DisplayName eq '<firstname> <lastname> ADM'" | Select-Object BusinessPhones, MobilePhone

#Show groups the user is in (only shows group ID)
(Get-MgUser -Filter "DisplayName eq 'Twinsey'" -ExpandProperty MemberOf).MemberOf

#Bear in mind that Microsoft Graph and AAD use the Id attribute rather like AD uses the SamAccountName. For example ‘Get-ADUser mishka’ works as SamAccountName is the default.
#Microsoft Graph however requires one to specify, for example: 

Get-MgUser -UserId <Id>
# Additionally MS Graph only returns Ids for groups that the user is in, which aren’t easily recognizable like SamAccountNames tend to be. 

Group Stuff

#Group stuff [kinda like Get-ADGroup]
#Show all properties of a group (doesn't work well for showing members though)
Get-MgGroup -Filter "DisplayName eq 'SSPR'"

#or
Get-MgGroup | Where-Object {$_.DisplayName -like "*SSPR*"}

#Show group members
Get-MgGroup -Filter "DisplayName eq 'SSPR'" -ExpandProperty Members | Select-Object Members

#Much like querying the groups that a given user is in, querying the users in a given group only shows the Id. Luckily there’s a solution to this.
#Getting readable output
#Simply save the below and import the PS1. One can then

Get-AADPrincipalGroupMembership "<firstname> <lastname>"

#Or if one only wants to see the group names

(Get-AADPrincipalGroupMembership "<firstname> <lastname>").DisplayName

#One can query group membership the same way via ‘Get-AADGroupMember’. I am used to AD’s commands so I simply tweaked them for AAD.

Import-Module Microsoft.Graph
Connect-MgGraph -Scopes "Directory.ReadWrite.All", "User.ReadWrite.All", "Group.ReadWrite.All", "GroupMember.Read.All"

Function Get-AADPrincipalGroupMembership {
        param (
        [parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]$User
        )
    Try {
        $Groups = (Get-MgUserMemberOf -UserId (Get-MgUser | Where-Object {$_.DisplayName -eq "$User"}).Id).Id
        ForEach ($Group in $Groups)
        {
Get-MgGroup -GroupId $Group -ExpandProperty Members
    }}
    Catch {Write-Host "User not found. These are you options:"; Get-MgUser}
    }

        Function Get-AADGroupMember {
        param (
        [parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]$Group
        )
    Try {
        $Members = (Get-MgGroupMember -GroupId (Get-MgGroup | Where-Object {$_.DisplayName -eq "$Group"}).Id).Id
        ForEach ($Member in $Members)
        {
        Get-MgUser -UserId $Member -ExpandProperty MemberOf
        }}
    Catch {Write-Host "Group not found. These are you options:"; Get-MgGroup}
}

Other / Devices

#Show devices [kinda like Get-ADComputer]
Get-MgDevice | Select-Object DisplayName, Id, DeviceId, OperatingSystem, OperatingSystemVersion

#Show license info
Get-MgUserLicenseDetail -UserId <Id> | Select-Object *

# One can also query via the web API, just in case there something that the PowerShell module doesn’t support yet.

(Invoke-MgGraphRequest -Method GET https://graph.microsoft.com/v1.0/groups).Value | Where-Object {$_.DisplayName -like "*SSPR*"}
# One can substitute ‘users’ or ‘devices’ for ‘groups’ on the end of the URL to query those.

#The following example can be used to only return the managedDevice objects where the deviceName property equals ‘CLDCLN53’.

Get-MgDeviceManagementManagedDevice -Filter "deviceName eq 'CLDCLN53'" 

#The less than or equal to (le) operator can be used to query for objects that have a specific property that is less than or equal to the specified value. The following example can be used to only return the managedDevice objects where the lastSyncDateTime property is less than or equal to the specified date of 2022-01-19.
Get-MgDeviceManagementManagedDevice -Filter "lastSyncDateTime le 2022-01-19"

