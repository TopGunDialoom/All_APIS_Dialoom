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
