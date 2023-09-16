import React from 'react';
import { useAuth } from './AuthContext';

function MapComponent() {
    const { currentUser} = useAuth(); // currentUser , signIn, signOut 

    return (
        <div>
            {currentUser ? <p>Welcome, {currentUser.username}</p> : <p>Please sign in</p>}
            {/* You can now use signIn, signOut, and other methods provided by the context */}
        </div>
    );
}

export default MapComponent;
