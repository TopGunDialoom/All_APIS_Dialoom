import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from '../entities/user.entity';
import { CreateUserDto } from '../dto/create-user.dto';
import { UpdateUserDto } from '../dto/update-user.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepo: Repository<User>,
  ) {}

  async findAll(): Promise<User[]> {
    return this.usersRepo.find();
  }

  async findById(id: number): Promise<User> {
    const user = await this.usersRepo.findOne({ where: { id } });
    if (!user) {
      throw new NotFoundException(\`User with id=\${id} not found\`);
    }
    return user;
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepo.findOne({ where: { email } });
  }

  async createUser(dto: CreateUserDto): Promise<User> {
    const { name, email, password, role } = dto;
    // Verificar si ya existe
    const existing = await this.findByEmail(email);
    if (existing) {
      throw new Error('Email already in use');
    }
    const hashed = await bcrypt.hash(password, 10);
    const user = this.usersRepo.create({
      name,
      email,
      password: hashed,
      role: role || UserRole.USER,
    });
    return this.usersRepo.save(user);
  }

  async updateUser(id: number, dto: UpdateUserDto): Promise<User> {
    const user = await this.findById(id);
    if (dto.name !== undefined) {
      user.name = dto.name;
    }
    if (dto.role !== undefined) {
      user.role = dto.role;
    }
    return this.usersRepo.save(user);
  }

  async removeUser(id: number): Promise<void> {
    const user = await this.findById(id);
    await this.usersRepo.remove(user);
  }
}
