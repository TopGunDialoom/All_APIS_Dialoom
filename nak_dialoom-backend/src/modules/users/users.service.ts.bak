import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from './entities/user.entity';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User) private usersRepo: Repository<User>,
  ) {}

  async findById(id: number): Promise<User | undefined> {
    return this.usersRepo.findOne({ where: { id } });
  }

  async findByEmail(email: string): Promise<User | undefined> {
    return this.usersRepo.findOne({ where: { email } });
  }

  async createOAuthUser(name: string, email: string, role: UserRole = UserRole.USER): Promise<User> {
    const user = this.usersRepo.create({ name, email, role });
    return await this.usersRepo.save(user);
  }

  async createLocalUser(name: string, email: string, password: string): Promise<User> {
    const hashed = await bcrypt.hash(password, 10);
    const user = this.usersRepo.create({ name, email });
    // user.passwordHash = hashed; // si se maneja pass local
    return await this.usersRepo.save(user);
  }

  async updateProfile(id: number, data: Partial<User>): Promise<User> {
    await this.usersRepo.update(id, data);
    return this.findById(id);
  }

  async verifyUser(id: number): Promise<void> {
    await this.usersRepo.update(id, { isVerified: true });
  }
}
