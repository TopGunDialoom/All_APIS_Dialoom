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
