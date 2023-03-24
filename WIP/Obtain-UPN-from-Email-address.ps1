# Obtain UserPrincipalName and other data from email address stored in a CSV
Connect-MgGraph -Scopes “User.Read.All” 
# for each value in the "EmailAddress" Column
(Import-Csv "C:\Temp\Users.csv").EmailAddress | ForEach-Object {
    # if the user exists in Azure AD
    if($azusr = Get-MgUser -Filter "mail eq '$_'") {
        # output this object
        [pscustomobject]@{
            UserName           = $azusr.DisplayName
            UserPrincipalName  = $azusr.UserPrincipalName
            PrimarySmtpAddress = $azusr.Mail
            AliasSmtpAddresses = $azusr.ProxyAddresses -clike 'smtp:*' -replace 'smtp:' -join ','
            UserId             = $azusr.ObjectId
        }
    }
 } | Export-CSV "C:\IntuneFiles\user-upn.csv" -NoTypeInformation -Encoding UTF8