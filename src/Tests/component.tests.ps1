
# Stop the testing dashboard that run on port 10000 if it alredy running.
# Stop-UDDashboard -Port 10000 -ErrorAction SilentlyContinue

Describe "<%=$PLASTER_PARAM_ControlName%>" {

    Context "content" {
        
        # Create the dashboard for testing.
        $Dashboard = New-UDDashboard -Title "Test" -Content {

            # MaterializeCss row component.
            New-UDRow -Columns {
                
                # MaterializeCss column component.
                New-UDColumn -LargeSize 8 -LargeOffset 2 -Content {
                    
                    # Your custom component.
                    <%=$PLASTER_PARAM_CommandName%> -id 'test' -Text 'Congratulation!!, your custom control is working.'  
             
                }
            }
        }

        # Start the testing dashboard with the custom component.
        $Server = Start-UDDashboard -Port 10000 -Dashboard $Dashboard

        # Open firefox browser.
        $Driver = Start-SeFirefox

        # Display the testing dashboard in firefox
        Enter-SeUrl -Url "http://localhost:10000" -Driver $Driver 

           
        # Test if the component have the default testing text.
        It 'has a content' {
            (Find-SeElement -Id 'test' -Driver $Driver).Text | should -Be 'Congratulation!!, your custom control is working.'
        }


        # Stop selenium driver
        Stop-SeDriver -Driver $Driver

        # Stop the dashboard
        $Server.Stop()
    }
}