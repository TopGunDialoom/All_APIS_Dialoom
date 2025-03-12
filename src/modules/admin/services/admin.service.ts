import { Injectable, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AdminLog } from '../entities/admin-log.entity';
import { UsersService } from '../../users/services/users.service';
import { User, UserRole } from '../../users/entities/user.entity';

/**
 * Ejemplo de service que hace acciones 'privadas' de admin:
 * - upgrade user -> host
 * - ban user
 * - etc.
 */
@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(AdminLog)
    private readonly logsRepo: Repository<AdminLog>,
    private readonly usersService: UsersService,
  ) {}

  async banUser(userId: number, reason: string) {
    // BAN => Cambiamos rol a 'user' con algo, o bloqueado
    const user = await this.usersService.findById(userId);
    if (user.role === UserRole.ADMIN) {
      throw new ForbiddenException('No puedes banear a un admin');
    }
    // Podríamos hacer "eliminar" o setear "role=host_banned", etc.
    // Por simplicidad, removeUser
    await this.usersService.removeUser(userId);

    const log = this.logsRepo.create({
      action: 'BAN_USER',
      details: \`banned user \${userId}, reason: \${reason}\`,
    });
    await this.logsRepo.save(log);
    return { message: \`User \${userId} was banned.\` };
  }

  async promoteToHost(userId: number) {
    const user = await this.usersService.findById(userId);
    if (user.role === UserRole.HOST) {
      throw new Error('User is already a host');
    }
    user.role = UserRole.HOST;
    await this.usersService.updateUser(userId, { role: UserRole.HOST });
    const log = this.logsRepo.create({
      action: 'PROMOTE_TO_HOST',
      details: \`user \${userId} => host\`,
    });
    await this.logsRepo.save(log);
    return { message: \`User \${userId} is now a host.\` };
  }

  async promoteToAdmin(userId: number) {
    // Quiza solo un superadmin puede hacer esto, verifica en admin.controller con RolesGuard
    await this.usersService.updateUser(userId, { role: UserRole.ADMIN });
    const log = this.logsRepo.create({
      action: 'PROMOTE_TO_ADMIN',
      details: \`user \${userId} => admin\`,
    });
    await this.logsRepo.save(log);
    return { message: \`User \${userId} is now admin.\` };
  }

  async getLogs() {
    return this.logsRepo.find({
      order: { createdAt: 'DESC' },
      take: 50,
    });
  }
}
