import { Injectable } from '@nestjs/common';

@Injectable()
export class UsersService {
  async findById(id: number) {
    // Ejemplo: retorna un user simulado
    if (id === 1) {
      return { id:1, name: 'John', email: 'john@dialoom.com' };
    }
    return null; // o undefined
  }
}
