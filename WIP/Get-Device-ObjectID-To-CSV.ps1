# Get Objectid's from a csv containing a list of device names and output to a csv, make sure the header in the single column csv starts devicename.
Connect-MgGraph -Scopes “User.Read.All” 

(Import-Csv "C:\Temp\Devices.csv").DeviceName | ForEach-Object {
    # if the device exists in Azure AD
    if($azdevice = Get-MgDevice -Filter "displayname eq '$_'") {
        # output this object
        [pscustomobject]@{
            DisplayName        = $azdevice.DisplayName
            ObjectID           = $azdevice.ObjectId
            DeviceOSType       = $azdevice.DeviceOSType
        }
    }
 } | Export-CSV "C:\IntuneFiles\objectid.csv" -NoTypeInformation -Encoding UTF8

