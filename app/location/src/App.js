import "./App.css";

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <div class="container">
          <h1>Welcome to Web App</h1>
          <div id="login-form">
            Cognito login form integration will go here
            <button class="button">Login</button> Example button, adjust as
            needed
          </div>
          <div id="data">Display data queried from DynamoDB here</div>
        </div>
      </header>
    </div>
  );
}

export default App;
