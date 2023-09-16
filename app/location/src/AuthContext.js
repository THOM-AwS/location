import React, { createContext, useContext, useState } from "react";
import { Auth } from "aws-amplify";

const AuthContext = createContext();

export function useAuth() {
  return useContext(AuthContext);
}

export function AuthProvider({ children }) {
  const [currentUser, setCurrentUser] = useState(null);

  // Sign up function
  async function signUp(email, password) {
    try {
      const user = await Auth.signUp({
        username: email,
        password: password,
        attributes: {
          email: email,
        },
      });
      return user;
    } catch (error) {
      console.error("Error signing up:", error);
      throw error;
    }
  }

  // Sign in function
  async function signIn(email, password) {
    try {
      const user = await Auth.signIn(email, password);
      setCurrentUser(user);
      return user;
    } catch (error) {
      console.error("Error signing in:", error);
      throw error;
    }
  }

  // Sign out function
  async function signOut() {
    try {
      await Auth.signOut();
      setCurrentUser(null);
    } catch (error) {
      console.error("Error signing out:", error);
      throw error;
    }
  }

  // Get the current authenticated user
  async function fetchCurrentUser() {
    try {
      const user = await Auth.currentAuthenticatedUser();
      setCurrentUser(user);
      return user;
    } catch (error) {
      console.error("Error fetching current user:", error);
      return null;
    }
  }

  const value = {
    currentUser,
    signUp,
    signIn,
    signOut,
    fetchCurrentUser,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}
