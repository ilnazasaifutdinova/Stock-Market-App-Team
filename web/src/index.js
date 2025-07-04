import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import './css/style.css';  // assuming you have your CSS here
import './css/landing.css';
import './css/auth-common.css';


// Create App component
const App = () => {
    return (
        <Router>
            <div id="app">
                <Routes>
                    <Route path="/" element={<Landing />} />
                    <Route path="/login" element={<Login />} />
                    <Route path="/register" element={<Register />} />
                    <Route path="/market" element={<Market />} />
                    <Route path="/portfolio" element={<Portfolio />} />
                    <Route path="/pro-version" element={<ProVersion />} />
                    <Route path="*" element={<Navigate to="/" />} />
                </Routes>
            </div>
        </Router>
    );
};

// Create basic components (we'll enhance these later)
const Landing = () => <div>Landing Page</div>;
const Login = () => <div>Login Page</div>;
const Register = () => <div>Register Page</div>;
const Market = () => <div>Market Page</div>;
const Portfolio = () => <div>Portfolio Page</div>;
const ProVersion = () => <div>Pro Version Page</div>;

// Render the app
const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
    <React.StrictMode>
        <App />
    </React.StrictMode>
);