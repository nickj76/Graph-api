
# Install Graph 
Install-Module Microsoft.Graph -Scope CurrentUser

#Connect MgGraph
$tenantid = 'xxxxxx-xxxxxxxxx-xxxxxxxxx-xxxxxx'
$appID = 'xxxxxx-xxxxxx-xxxxxxx-xxxxxxx'
$secret = "xxxxxxxxxxxxxxxxxxxxxxxxx"
 
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

# Check if Folder exists
$folderName = "IntuneFiles"
$Path = "C:\" + $folderName

if (!(Test-Path $Path)) {
    New-Item -ItemType Directory -Path C:\ -Name $folderName
} else {
    Write-Host "Folder already exists"
}

# Get CSV to Desktop of all Devices not used in 90 Days
$dt = (Get-Date).AddDays(-90)
$devices = Get-MgDevice -All:$true | Where-Object { $_.ApproximateLastSignInDateTime -le $dt }
$deviceList = $devices | Select-Object -Property AccountEnabled, DeviceId, Id, OperatingSystem, OperatingSystemVersion, DisplayName, TrustType, ApproximateLastSignInDateTime
$deviceList | Export-Csv C:\IntuneFiles\devicelist-olderthan-90days-summary.csv -NoTypeInformation
Disconnect-MgGraph
