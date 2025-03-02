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
