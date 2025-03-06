#!/usr/bin/env bash
set -e

echo "Creando estructura de carpetas para Fase 2 (Web) de Dialoom..."

# 1) Carpetas principales
mkdir -p dialoom-web-phase2
cd dialoom-web-phase2

mkdir -p public
mkdir -p src
mkdir -p src/assets
mkdir -p src/components
mkdir -p src/components/admin
mkdir -p src/components/auth
mkdir -p src/components/common
mkdir -p src/components/host
mkdir -p src/components/moderation
mkdir -p src/context
mkdir -p src/hooks
mkdir -p src/i18n/locales/en
mkdir -p src/i18n/locales/es
mkdir -p src/layouts
mkdir -p src/pages
mkdir -p src/pages/admin
mkdir -p src/pages/auth
mkdir -p src/pages/host
mkdir -p src/pages/moderation
mkdir -p src/pages/user
mkdir -p src/routes
mkdir -p src/services
mkdir -p src/types
mkdir -p src/utils

# 2) package.json de ejemplo
cat << 'EOF' > package.json
{
  "name": "dialoom-web-phase2",
  "version": "2.0.0",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "start": "vite preview"
  },
  "dependencies": {
    "@reduxjs/toolkit": "^1.9.5",
    "@types/react": "^18.0.28",
    "@types/react-dom": "^18.0.11",
    "axios": "^1.3.4",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-redux": "^8.0.5",
    "react-router-dom": "^6.8.2",
    "react-i18next": "^12.2.0",
    "i18next": "^22.0.0",
    "typescript": "^4.9.5"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.0.0",
    "@types/node": "^18.0.0",
    "vite": "^4.2.0"
  }
}
EOF

# 3) Vite config
cat << 'EOF' > vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000
  }
});
EOF

# 4) tsconfig.json
cat << 'EOF' > tsconfig.json
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "jsx": "react",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src"]
}
EOF

# 5) index.html en public
cat << 'EOF' > public/index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" href="/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dialoom Phase2 Web</title>
  </head>
  <body>
    <div id="root"></div>
    <!-- Accessibility note: ensure good contrast, aria-labels, skip-to-content link, etc. -->
  </body>
</html>
EOF

# 6) src/main.tsx
cat << 'EOF' > src/main.tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import App from './App';
import './i18n/i18n'; // inicializa i18n

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </React.StrictMode>
);
EOF

# 7) src/App.tsx
cat << 'EOF' > src/App.tsx
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
EOF

# 8) Ejemplo de Layout
cat << 'EOF' > src/layouts/Layout.tsx
import React from 'react';
import Navbar from '../components/common/Navbar';
import Footer from '../components/common/Footer';

interface Props {
  children: React.ReactNode;
}

export default function Layout({ children }: Props) {
  return (
    <div className="layout-container">
      <Navbar />
      <main>{children}</main>
      <Footer />
    </div>
  );
}
EOF

# 9) Rutas (PrivateRoute) - control de roles
cat << 'EOF' > src/routes/PrivateRoute.tsx
import React from 'react';
import { Navigate, Outlet } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';

interface Props {
  requiredRole?: string;
}

export default function PrivateRoute({ requiredRole }: Props) {
  const { isAuthenticated, user } = useAuth();

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  if (requiredRole && user?.role !== requiredRole) {
    return <Navigate to="/" replace />;
  }

  return <Outlet />;
}
EOF

# 10) Hooks de Auth (simples, usando localStorage)
cat << 'EOF' > src/hooks/useAuth.ts
import { useEffect, useState } from 'react';
import axios from 'axios';

interface User {
  id: number;
  name: string;
  email: string;
  role: string;
}

export function useAuth() {
  const [token, setToken] = useState<string | null>(null);
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  const isAuthenticated = !!token;

  useEffect(() => {
    const storedToken = localStorage.getItem('dialoom_token');
    if (storedToken) {
      setToken(storedToken);
      fetchUserProfile(storedToken);
    } else {
      setLoading(false);
    }
  }, []);

  async function fetchUserProfile(tokenVal: string) {
    try {
      const resp = await axios.get('/api/v1/users/me', {
        headers: { Authorization: \`Bearer \${tokenVal}\` }
      });
      setUser(resp.data);
    } catch (err) {
      console.error(err);
      logout();
    } finally {
      setLoading(false);
    }
  }

  function login(newToken: string) {
    localStorage.setItem('dialoom_token', newToken);
    setToken(newToken);
    fetchUserProfile(newToken);
  }

  function logout() {
    localStorage.removeItem('dialoom_token');
    setToken(null);
    setUser(null);
  }

  return {
    token,
    user,
    loading,
    isAuthenticated,
    login,
    logout
  };
}
EOF

# 11) Páginas

# 11.1) pages/HomePage.tsx
cat << 'EOF' > src/pages/HomePage.tsx
import React from 'react';
import { useTranslation } from 'react-i18next';

export default function HomePage() {
  const { t } = useTranslation();
  return (
    <div>
      <h1>{t('general.welcome')} a Dialoom</h1>
      <p>Fase 2: Web responsiva, experiencia de usuario mejorada.</p>
    </div>
  );
}
EOF

# 11.2) pages/auth/LoginPage.tsx
cat << 'EOF' > src/pages/auth/LoginPage.tsx
import React, { useState } from 'react';
import axios from 'axios';
import { useAuth } from '../../hooks/useAuth';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const { login } = useAuth();
  const { t } = useTranslation();
  const navigate = useNavigate();

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    try {
      const resp = await axios.post('/api/v1/auth/login', { email, password });
      login(resp.data.accessToken);
      navigate('/');
    } catch (err: any) {
      alert(t('errors.invalid_credentials'));
    }
  }

  async function handleOAuth(provider: string) {
    // Redirige a la ruta que inicia la OAuth en backend
    window.location.href = \`/api/v1/auth/\${provider}\`;
  }

  return (
    <div>
      <h2>{t('general.login')}</h2>
      <form onSubmit={handleSubmit}>
        <label>{t('validation.invalid_email')}</label>
        <input value={email} onChange={(e) => setEmail(e.target.value)} type="email" required />

        <label>{t('general.password')}</label>
        <input value={password} onChange={(e) => setPassword(e.target.value)} type="password" required />

        <button type="submit">{t('general.login')}</button>
      </form>
      <hr />
      <div>
        <p>O ingresa con:</p>
        <button onClick={() => handleOAuth('google')}>Google</button>
        <button onClick={() => handleOAuth('facebook')}>Facebook</button>
        <button onClick={() => handleOAuth('microsoft')}>Microsoft</button>
        <button onClick={() => handleOAuth('apple')}>Apple</button>
      </div>
    </div>
  );
}
EOF

# 11.3) pages/auth/RegisterPage.tsx
cat << 'EOF' > src/pages/auth/RegisterPage.tsx
import React, { useState } from 'react';
import axios from 'axios';
import { useAuth } from '../../hooks/useAuth';
import { useNavigate } from 'react-router-dom';

export default function RegisterPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const { login } = useAuth();
  const navigate = useNavigate();

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    try {
      const resp = await axios.post('/api/v1/auth/register', { email, password, name });
      // resp.data.accessToken
      login(resp.data.accessToken);
      navigate('/');
    } catch (err) {
      alert('Error registering');
    }
  }

  return (
    <div>
      <h2>Registro</h2>
      <form onSubmit={handleSubmit}>
        <label>Email</label>
        <input value={email} onChange={(e) => setEmail(e.target.value)} type="email" required />
        <label>Password</label>
        <input value={password} onChange={(e) => setPassword(e.target.value)} type="password" required />
        <label>Nombre</label>
        <input value={name} onChange={(e) => setName(e.target.value)} type="text" required />
        <button type="submit">Crear cuenta</button>
      </form>
    </div>
  );
}
EOF

# 11.4) pages/auth/OAuthCallbackPage.tsx
cat << 'EOF' > src/pages/auth/OAuthCallbackPage.tsx
import React, { useEffect } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import axios from 'axios';

export default function OAuthCallbackPage() {
  const [searchParams] = useSearchParams();
  const { login } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    const code = searchParams.get('code');
    const provider = searchParams.get('provider');
    // Llamar a un endpoint del backend para intercambiar code -> accessToken
    if (code && provider) {
      handleOAuthCallback(code, provider);
    }
  }, []);

  async function handleOAuthCallback(code: string, provider: string) {
    try {
      const resp = await axios.post('/api/v1/auth/oauth/callback', { code, provider });
      login(resp.data.accessToken);
      navigate('/');
    } catch (err) {
      console.error(err);
      navigate('/login');
    }
  }

  return <div>Procesando login social...</div>;
}
EOF

# 11.5) pages/admin/AdminDashboard.tsx
cat << 'EOF' > src/pages/admin/AdminDashboard.tsx
import React, { useEffect, useState } from 'react';
import axios from 'axios';

interface User {
  id: number;
  name: string;
  email: string;
  role: string;
  verified: boolean;
}

export default function AdminDashboard() {
  const [users, setUsers] = useState<User[]>([]);

  useEffect(() => {
    fetchUsers();
  }, []);

  async function fetchUsers() {
    try {
      const resp = await axios.get('/api/v1/admin/users', { /* headers if needed */ });
      setUsers(resp.data);
    } catch (err) {
      console.error(err);
    }
  }

  async function toggleVerify(userId: number) {
    try {
      await axios.put(\`/api/v1/admin/users/\${userId}/verifyToggle\`);
      fetchUsers();
    } catch (err) {
      console.error(err);
    }
  }

  return (
    <div>
      <h2>Panel de Administración (Fase 2 Expandido)</h2>
      <table>
        <thead>
          <tr>
            <th>ID</th><th>Nombre</th><th>Rol</th><th>Verificado</th><th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          {users.map(u => (
            <tr key={u.id}>
              <td>{u.id}</td>
              <td>{u.name} ({u.email})</td>
              <td>{u.role}</td>
              <td>{u.verified ? 'Sí' : 'No'}</td>
              <td>
                <button onClick={() => toggleVerify(u.id)}>
                  {u.verified ? 'Quitar verificación' : 'Verificar'}
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
EOF

# 11.6) pages/moderation/ModerationDashboard.tsx
cat << 'EOF' > src/pages/moderation/ModerationDashboard.tsx
import React, { useEffect, useState } from 'react';
import axios from 'axios';

interface Report {
  id: number;
  reason: string;
  reporterId: number;
  targetId: number;
  resolved: boolean;
}

export default function ModerationDashboard() {
  const [reports, setReports] = useState<Report[]>([]);

  useEffect(() => {
    fetchReports();
  }, []);

  async function fetchReports() {
    try {
      const resp = await axios.get('/api/v1/admin/reports');
      setReports(resp.data);
    } catch (err) {
      console.error(err);
    }
  }

  async function resolve(reportId: number) {
    try {
      await axios.post(\`/api/v1/admin/reports/\${reportId}/resolve\`);
      fetchReports();
    } catch (err) {
      console.error(err);
    }
  }

  return (
    <div>
      <h2>Panel de Moderación</h2>
      <ul>
        {reports.map(r => (
          <li key={r.id}>
            <p>Reporte #{r.id} - razón: {r.reason}</p>
            <p>reporter: {r.reporterId}, target: {r.targetId} - {r.resolved ? 'resuelto' : 'pendiente'}</p>
            {!r.resolved && <button onClick={() => resolve(r.id)}>Marcar Resuelto</button>}
            <hr />
          </li>
        ))}
      </ul>
    </div>
  );
}
EOF

# 11.7) pages/host/HostProfilePage.tsx
cat << 'EOF' > src/pages/host/HostProfilePage.tsx
import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { useParams } from 'react-router-dom';

interface Host {
  id: number;
  name: string;
  bio: string;
  verified: boolean;
  rating: number;
}

export default function HostProfilePage() {
  const { hostId } = useParams();
  const [host, setHost] = useState<Host | null>(null);

  useEffect(() => {
    if (hostId) fetchHost(hostId);
  }, [hostId]);

  async function fetchHost(id: string) {
    try {
      const resp = await axios.get(\`/api/v1/hosts/\${id}\`);
      setHost(resp.data);
    } catch (err) {
      console.error(err);
    }
  }

  function handleReserve() {
    // ejemplo de reserva
    alert("Reservar la sesión con este host (Fase 2) - Lógica a implementar");
  }

  if (!host) return <div>Cargando host...</div>;

  return (
    <div>
      <h2>Host: {host.name}</h2>
      <p>Bio: {host.bio}</p>
      <p>Verificado: {host.verified ? 'Sí' : 'No'}</p>
      <p>Rating promedio: {host.rating}</p>
      <button onClick={handleReserve}>Reservar Sesión</button>
    </div>
  );
}
EOF

# 11.8) pages/user/UserProfilePage.tsx
cat << 'EOF' > src/pages/user/UserProfilePage.tsx
import React, { useEffect, useState } from 'react';
import axios from 'axios';

interface Reservation {
  id: number;
  hostName: string;
  date: string;
  status: string;
}

export default function UserProfilePage() {
  const [reservations, setReservations] = useState<Reservation[]>([]);

  useEffect(() => {
    fetchMyReservations();
  }, []);

  async function fetchMyReservations() {
    try {
      const resp = await axios.get('/api/v1/reservations/mine');
      setReservations(resp.data);
    } catch (err) {
      console.error(err);
    }
  }

  return (
    <div>
      <h2>Mi Perfil</h2>
      <h3>Mis Reservas</h3>
      <ul>
        {reservations.map(r => (
          <li key={r.id}>
            Con {r.hostName} el {r.date}, estado: {r.status}
          </li>
        ))}
      </ul>
    </div>
  );
}
EOF

# 12) Componentes Comunes (Navbar, Footer, etc.)

# 12.1) components/common/Navbar.tsx
cat << 'EOF' > src/components/common/Navbar.tsx
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
EOF

# 12.2) components/common/Footer.tsx
cat << 'EOF' > src/components/common/Footer.tsx
import React from 'react';

export default function Footer() {
  return (
    <footer style={{ marginTop: '2rem', background: '#f5f5f5', padding: '1rem' }}>
      <p>Dialoom - Fase 2. Todos los derechos reservados.</p>
    </footer>
  );
}
EOF

# 13) i18n

cat << 'EOF' > src/i18n/i18n.ts
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import en from './locales/en/translation.json';
import es from './locales/es/translation.json';

i18n
  .use(initReactI18next)
  .init({
    resources: {
      en: { translation: en },
      es: { translation: es }
    },
    lng: 'es',
    fallbackLng: 'es',
    interpolation: { escapeValue: false }
  });

export default i18n;
EOF

# 14) i18n locales

cat << 'EOF' > src/i18n/locales/en/translation.json
{
  "general": {
    "welcome": "Welcome",
    "password": "Password",
    "login": "Login"
  },
  "errors": {
    "invalid_credentials": "Invalid username or password"
  },
  "validation": {
    "invalid_email": "Please enter a valid email"
  }
}
EOF

cat << 'EOF' > src/i18n/locales/es/translation.json
{
  "general": {
    "welcome": "¡Bienvenido!",
    "password": "Contraseña",
    "login": "Iniciar sesión"
  },
  "errors": {
    "invalid_credentials": "Usuario o contraseña inválidos"
  },
  "validation": {
    "invalid_email": "Ingrese un correo válido"
  }
}
EOF

# 15) Utils o servicios de API (ejemplo)
cat << 'EOF' > src/services/api.ts
import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:3000', // ajusta segun tu backend
});

// Podrías interceptar requests para inyectar el token:
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('dialoom_token');
  if (token && config.headers) {
    config.headers.Authorization = \`Bearer \${token}\`;
  }
  return config;
});

export default api;
EOF

# 16) .gitignore minimal
cat << 'EOF' > .gitignore
node_modules/
dist/
.vite
.env
EOF

# Mensaje final
echo "Estructura de Fase 2 generada. Ahora, dentro de 'dialoom-web-phase2', ejecuta 'npm install' y luego 'npm run dev' (si usas Vite) para probar."
echo "Recuerda ajustar los endpoints de la API (en axios) y tus credenciales OAuth reales."
