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
