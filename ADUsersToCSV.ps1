# Run this script from a domain controller

Import-Module ActiveDirectory

$SearchBase = ""
$File = "ADUsers.csv"
$FileTemp = "temp.csv"

# Get user input
$DomainName = Read-Host "Enter the domain name"
$OU = Read-Host "Enter the organization unit"

# Split the string by .
$DomainParts = $DomainName.split(".")

# Create the LDAP search string
$SearchBase = "OU=" + $OU + ","
ForEach($Part in $DomainParts) {
  $SearchBase = $SearchBase + "DC=" + $Part + ","
}

# Remove the last character (the extra comma)
$SearchBase = $SearchBase.Substring(0,$SearchBase.Length-1)

Write-Host "Searching: " $SearchBase

# Return a list of users
$Users = Get-ADUser -Filter * -SearchBase $SearchBase -Properties Office, EmailAddress, Title, OfficePhone | Where-Object {$_.Enabled -eq $True} | Select-Object SAMAccountName, Office, GivenName, Surname, EmailAddress, Title, OfficePhone

# Export data to CSV file
$Users | Export-Csv $File

# Remove the first line of the file
Get-Content $File |
    Select -Skip 1 |
    Set-Content "$FileTemp"
Move "$FileTemp" $File -Force
