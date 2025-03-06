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
