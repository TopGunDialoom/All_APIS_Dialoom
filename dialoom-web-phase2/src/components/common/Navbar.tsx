import React from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';

export default function Navbar() {
  const { isAuthenticated, user, logout } = useAuth();

  return (
    <nav>
      <Link to="/">Inicio</Link>
      {isAuthenticated && user ? (
        <>
          <Link to="/user/profile">Mi Perfil</Link>
          {user.role === 'admin' && <Link to="/admin">Admin Panel</Link>}
          {user.role === 'admin' && <Link to="/moderation">Moderación</Link>}
          <button onClick={logout}>Salir</button>
        </>
      ) : (
        <>
          <Link to="/login">Ingresar</Link>
          <Link to="/register">Registrarse</Link>
        </>
      )}
    </nav>
  );
}
