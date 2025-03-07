import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Setting } from './entities/setting.entity';
import { Log } from './entities/log.entity';
import { UsersService } from '../users/users.service';
import { PaymentsService } from '../payments/payments.service';
import { GamificationService } from '../gamification/gamification.service';

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(Setting) private settingsRepo: Repository<Setting>,
    @InjectRepository(Log) private logRepo: Repository<Log>,
    private usersService: UsersService,
    private paymentsService: PaymentsService,
    private gamificationService: GamificationService,
  ) {}

  async getSetting(key: string): Promise<Setting> {
    return this.settingsRepo.findOne({ where: { key } });
  }

  async updateSetting(key: string, value: string): Promise<Setting> {
    let setting = await this.settingsRepo.findOne({ where: { key } });
    if (!setting) {
      setting = this.settingsRepo.create({ key, value });
    } else {
      setting.value = value;
    }
    const saved = await this.settingsRepo.save(setting);
    await this.logRepo.save({ action: \`UPDATE_SETTING:\${key}=\${value}\`, performedBy: 'admin' });
    return saved;
  }

  async banUser(userId: number) {
    // Cambia el rol o marca al usuario inactivo
    await this.usersService.updateProfile(userId, { role: 'banned' } as any);
    await this.logRepo.save({ action: \`BAN_USER:\${userId}\`, performedBy: 'admin' });
  }
}
