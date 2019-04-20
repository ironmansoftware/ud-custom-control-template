import React from 'react';

class <%=$PLASTER_PARAM_ControlName%> extends React.Component {

  // state is for keeping control state before or after changes.
  state = {

    // the things you want to put in state.   
    // text: this.props.text //un comment the line to use state insted props
  }


  render() {

      // These props are returned from PowerShell!
      // return <h1>{this.state.text}</h1> // un comment the line to render using value from state.

      return <h1 id={this.props.id}>{this.props.text}</h1>
    
  }
}

export default <%=$PLASTER_PARAM_ControlName%>