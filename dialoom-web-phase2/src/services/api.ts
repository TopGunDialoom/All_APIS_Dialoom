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
