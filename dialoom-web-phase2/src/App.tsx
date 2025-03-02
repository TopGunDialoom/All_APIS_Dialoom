import React from 'react';
import { Routes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage';
import LoginPage from './pages/auth/LoginPage';
import RegisterPage from './pages/auth/RegisterPage';
import OAuthCallbackPage from './pages/auth/OAuthCallbackPage';
import AdminDashboard from './pages/admin/AdminDashboard';
import PrivateRoute from './routes/PrivateRoute';
import HostProfilePage from './pages/host/HostProfilePage';
import UserProfilePage from './pages/user/UserProfilePage';
import ModerationDashboard from './pages/moderation/ModerationDashboard';
import Layout from './layouts/Layout';

function App() {
  return (
    <Layout>
      <Routes>
        <Route path="/" element={<HomePage />} />

        {/* Auth */}
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />
        <Route path="/auth/callback" element={<OAuthCallbackPage />} />

        {/* Secciones protegidas */}
        <Route element={<PrivateRoute requiredRole="user"/>}>
          <Route path="/user/profile" element={<UserProfilePage />} />
          <Route path="/host/:hostId" element={<HostProfilePage />} />
        </Route>

        <Route element={<PrivateRoute requiredRole="admin"/>}>
          <Route path="/admin" element={<AdminDashboard />} />
          <Route path="/moderation" element={<ModerationDashboard />} />
        </Route>

        <Route path="*" element={<h2>404 - Not Found</h2>} />
      </Routes>
    </Layout>
  );
}

export default App;
