# Universal Dashboard Custom Control Template
A custom control template for Universal Dashboard.

## Developing Custom Components 

You can use this template to develop custom components. You will need to install [NodeJS](https://nodejs.org/en/) to be able to build React components. 

### Step 1

Install the React component that you would like to implement using `npm`. 

For example, we could install `react-leaflet` with the following command. `react-leaflet` also requires `react-dom` and `leaflet`. This type of information will be found on the package's documentation. 

```
cd .\src
npm install react-leafleft --save 
npm install leafleft --save 
npm install react-dom --save 
```

This will save the package to the `package.json` file. 

### Step 2 

Create a React component to register with UD. This can be done by editing the `.\src\Components\component.jsx` file. 

For example, I could wrap `react-leaflet` in a custom component. The `props` for the component will come directly from PowerShell. 

```
import React, {Component} from 'react';
import { Map, TileLayer } from 'react-leaflet';

export default class UDMap extends Component {

  componentDidMount() {
      document.getElementsByClassName('leaflet-container')[0].style.height = this.props.height;
      document.getElementsByClassName('leaflet-container')[0].style.width = this.props.width;
  }

  render() {
    const position = [this.props.lat, this.props.lng]
      return (
        
          <Map center={position} zoom={this.props.zoom}>
            <TileLayer
              attribution='&amp;copy <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
              url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            />
          </Map>
        

      )
  }
}
```

### Step 3 

Register the new component with Universal Dashboard. This component will load dynamically when someone uses it. 

This can be done in `.\src\Components\index.js`. The first parameter in the register function is the type name for the component. This needs to be unique and match what you will specify in PowerShell.

```
import UDMap from './component';
UniversalDashboard.register("ud-map", UDMap);
```

### Step 4 

Create a PowerShell function in the module to create the component. The ID parameter is required. You will also need to set the AssetID, type and isPlugin properties. The type should match what you registered in `index.js`.

The rest of the properties are optional and are passed down to the React control via `props`. 

```
function New-UDMap {
    param(
        [Parameter()]
        [string]$Id = (New-Guid).ToString(),
        [Parameter()]
        [float]$Longitude,
        [Parameter()]
        [float]$Latitude,
        [Parameter()]
        [int]$Zoom,
        [Parameter()]
        [string]$Height = '500px',
        [Parameter()]
        [string]$Width = '100%'
    )

    End {
        @{
            assetId = $AssetId 
            isPlugin = $true 
            type = "ud-map"
            id = $Id

            lng = $Longitude
            lat = $Latitude
            zoom = $Zoom
            height = $Height
            width = $Width
        }
    }
}
```

### Step 5 (Optional)

Although not required, you can rename the `UniversalDashboard.Template.psm1` file to match the control(s) you are building. You will also have to update the `build.ps1` file to match your renamed module name. 

```
Rename-Item .\UniversalDashboard.Template.psm1 .\UniversalDashboard.Map.psm1
```

### Step 6

Build and test the component. You can build the component using the `.\build.ps1` script. This will output the module to the `.\src\output` folder. Once built, you can load it into Universal Dashboard. 

If the output directory is not part of `$PSModulePath`, you should use the full path. 

```
Import-Module UniversalDashboard 
Import-Module "F:\ud-leaflet\src\output\UniversalDashboard.Map\UniversalDashboard.Map.psd1"

Start-UDDashboard -Dashboard (
    New-UDDashboard -Title "Map" -Content {
        New-UDMap -Latitude 51.505 -Longitude -0.09 -Zoom 13 
    } -EndpointInitialization (New-UDEndpointInitialization -Module ("F:\ud-leaflet\src\output\UniversalDashboard.Map\UniversalDashboard.Map.psd1"))
) -Port 10000

```

## Full Source Code

You view the full source code for this example, look at the [ud-leaflet](https://github.com/ironmansoftware/ud-leaflet/tree/master/src) project.