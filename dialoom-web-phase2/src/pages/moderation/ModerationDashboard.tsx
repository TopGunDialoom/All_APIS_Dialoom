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
