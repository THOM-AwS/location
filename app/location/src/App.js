import React from "react";
import "./App.css";
import { withAuthenticator } from "@aws-amplify/ui-react";

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>Location App</h1>
        <div id="data">Display data queried from DynamoDB here</div>
      </header>
    </div>
  );
}

export default withAuthenticator(App);
