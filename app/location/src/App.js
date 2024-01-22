import React from "react";
import { Amplify } from "aws-amplify";
import { withAuthenticator } from "@aws-amplify/ui-react";
import "@aws-amplify/ui-react/styles.css";

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
