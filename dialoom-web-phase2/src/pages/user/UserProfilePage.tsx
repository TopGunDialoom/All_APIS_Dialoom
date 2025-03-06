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
