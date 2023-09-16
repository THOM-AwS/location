import React from "react";
import ReactDOM from "react-dom/client";
import "./index.css";
import App from "./App";
import reportWebVitals from "./reportWebVitals";
import { AuthProvider } from "./AuthContext";
import SignUpComponent from "./SignUpComponent";
import MapComponent from "./MapComponent.tsx";
import { Amplify } from "aws-amplify";

Amplify.configure({
  Auth: {
    region: "us-east-1",
    userPoolId: "us-east-1_JVCsxSGbj",
    userPoolWebClientId: "4jbt18g357p3osj6vjkk2s0v6d",
  },
});

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(
  <React.StrictMode>
    <AuthProvider>
      <SignUpComponent />
      <App />
      <MapComponent />
    </AuthProvider>
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
