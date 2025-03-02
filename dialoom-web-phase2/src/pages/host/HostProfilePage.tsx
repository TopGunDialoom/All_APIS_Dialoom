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
