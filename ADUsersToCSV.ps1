# Run this script from a domain controller

Import-Module ActiveDirectory

$SearchBase = ""

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
Get-ADUser -Filter * -SearchBase $SearchBase | Where-Object {$_.Enabled -eq $True} | Select-Object SAMAccountName
