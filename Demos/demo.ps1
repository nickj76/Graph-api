$UserIDGUID = "xxxxxxxxxxxxxxxxxxxxxx"
$bodyProcess = @{
      
    "@odata.id"= "https://graph.microsoft.com/v1.0/users/$UserIDGUID"
   
}
$body = $bodyProcess | ConvertTo-Json


$Uri = 'https://graph.microsoft.com/v1.0/groups/Xxxx-xxxxX-Group-Unique-Identifier-XXXXX-Xxxxx/members/$ref'
Invoke-RestMethod -Uri $Uri -Headers $Header -Method POST -ContentType "application/json" -Body $Body