$BuildFolder = $PSScriptRoot

$powerShellGet = Import-Module PowerShellGet  -PassThru -ErrorAction Ignore
if ($powerShellGet.Version -lt ([Version]'1.6.0')) {
	Install-Module PowerShellGet -Scope CurrentUser -Force -AllowClobber
	Import-Module PowerShellGet -Force
}

Set-Location $BuildFolder

$OutputPath = "$BuildFolder\output\UniversalDashboard.<%=$PLASTER_PARAM_ControlName%>"

Remove-Item -Path $OutputPath -Force -ErrorAction SilentlyContinue -Recurse
Remove-Item -Path "$BuildFolder\public" -Force -ErrorAction SilentlyContinue -Recurse

New-Item -Path $OutputPath -ItemType Directory

npm install
npm run build

Copy-Item $BuildFolder\public\*.bundle.js $OutputPath
Copy-Item $BuildFolder\public\*.map $OutputPath
Copy-Item $BuildFolder\UniversalDashboard.<%=$PLASTER_PARAM_ControlName%>.psm1 $OutputPath
Copy-Item $BuildFolder\Scripts $OutputPath\Scripts -Recurse -Force

$Version = "1.0.0"

$manifestParameters = @{
	Path = "$OutputPath\UniversalDashboard.<%=$PLASTER_PARAM_ControlName%>.psd1"
	Author = "<%=$PLASTER_PARAM_Author%>"
	CompanyName = "Ironman Software, LLC"
	Copyright = "2019 Ironman Software, LLC"
	RootModule = "UniversalDashboard.<%=$PLASTER_PARAM_ControlName%>.psm1"
	Description = "<%=$PLASTER_PARAM_ControlDescription%>"
	ModuleVersion = $Version
	Tags = @("universaldashboard")
	ReleaseNotes = "<%=$PLASTER_PARAM_ReleaseNotes%>"
	FunctionsToExport = @(
		"<%=$PLASTER_PARAM_CommandName%>"
	)
}

New-ModuleManifest @manifestParameters

