import { Injectable } from '@nestjs/common';

@Injectable()
export class AdminService {
  // EJEMPLO VACÍO
  getAdminStuff() {
    return 'admin data';
  }
}
