import React from 'react';

export default class UDComponent extends React.Component {
  render() {
      // These props are returned from PowerShell!
      return <h1>{this.props.text}</h1>
    
  }
}