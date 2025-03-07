import { Injectable } from '@nestjs/common';

@Injectable()
export class AdminService {
  getAdminStuff() {
    return 'admin data';
  }
}
