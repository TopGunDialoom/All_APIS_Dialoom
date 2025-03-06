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
