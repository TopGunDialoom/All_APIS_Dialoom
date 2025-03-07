export enum UserRole {
  USER = 'user',
  HOST = 'host',
  ADMIN = 'admin',
  SUPERADMIN = 'superadmin'
}

export class User {
  id!: number;
  name!: string;
  email!: string;
  role!: UserRole;
}
