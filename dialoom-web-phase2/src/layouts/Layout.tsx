import React from 'react';
import Navbar from '../components/common/Navbar';
import Footer from '../components/common/Footer';

interface Props {
  children: React.ReactNode;
}

export default function Layout({ children }: Props) {
  return (
    <div className="layout-container">
      <Navbar />
      <main>{children}</main>
      <Footer />
    </div>
  );
}
