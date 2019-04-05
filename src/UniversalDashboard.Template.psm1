
# The main index.js bundle
$IndexJs = Get-ChildItem "$PSScriptRoot\index.*.bundle.js"

# Any other JS files in the bundle 
$JsFiles = Get-ChildItem "$PSScriptRoot\*.bundle.js"

# Source maps to make it easier to debug in the browser 
$Maps = Get-ChildItem "$PSScriptRoot\*.map"

# Register the main script and get the AssetID
$AssetId = [UniversalDashboard.Services.AssetService]::Instance.RegisterScript($IndexJs.FullName)

# Register all the other scripts. We don't care about the asset ID. They will be loaded by the main JS file.
foreach($item in $JsFiles)
{
    [UniversalDashboard.Services.AssetService]::Instance.RegisterScript($item.FullName) | Out-Null
}

# Register all the source map files so we can make debugging easier.
foreach($item in $Maps)
{
    [UniversalDashboard.Services.AssetService]::Instance.RegisterScript($item.FullName) | Out-Null
}

<#
    Sample control function. This function must have an ID and return a hash table 
#> 
function New-UDComponent {
    param(
        [Parameter()]
        [string]$Id = (New-Guid).ToString(),
        [Parameter()]
        [int]$Text
    )

    End {
        @{
            # The AssetID of the main JS File
            assetId = $AssetId 
            # Tell UD this is a plugin
            isPlugin = $true 
            # This ID must be the same as the one used in the JavaScript to register the control with UD
            type = "ud-knob"
            # An ID is mandatory 
            id = $Id

            # This is where you can put any other properties. They are passed to the React control's props
            # The keys are case-sensitive in JS. 
            text = $Text
            
        }
    }
}