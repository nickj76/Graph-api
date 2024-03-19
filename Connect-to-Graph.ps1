$tenantid = 'xxxxxx-xxxxxx-xxxxx'
$appID = 'xxxxx-xxxxxx-xxxxxx-xxxxxx'
$secret = "xxxxxxxxxxxxxxxxxxx"
 
$body =  @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $appid
    Client_Secret = $secret
}
 
$connection = Invoke-RestMethod `
    -Uri https://login.microsoftonline.com/$tenantid/oauth2/v2.0/token `
    -Method POST `
    -Body $body
 
    $token = $connection.access_token | ConvertTo-SecureString -AsPlainText -Force
    Connect-MgGraph -AccessToken $token