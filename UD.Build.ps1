
param(
    [Parameter(Mandatory)]
    [string]$Destination
)

Invoke-Plaster .\ -DestinationPath $Destination

cd $Destination

.\src\build.ps1

$Name = dir -Recurse -Filter *.psd1 | select -expand BaseName

Import-Module UniversalDashboard.Community -Force
Import-Module ".\output\$Name\$Name.psd1" -Force

Invoke-Pester 