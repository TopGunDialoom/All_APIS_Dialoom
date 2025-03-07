import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Setting } from './entities/setting.entity';
import { Log } from './entities/log.entity';

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(Setting)
    private settingsRepo: Repository<Setting>,

    @InjectRepository(Log)
    private logRepo: Repository<Log>,
  ) {}

  async getSetting(key: string): Promise<Setting> {
    const setting = await this.settingsRepo.findOne({ where: { key } });
    if (!setting) {
      throw new NotFoundException(`Setting no encontrado para key=${key}`);
    }
    return setting;
  }

  async updateSetting(key: string, value: string): Promise<Setting> {
    // Buscamos
    let setting = await this.settingsRepo.findOne({ where: { key } });
    if (!setting) {
      // Si no existe, lo creamos
      setting = this.settingsRepo.create({ key, value });
    } else {
      setting.value = value;
    }
    const saved = await this.settingsRepo.save(setting);

    // Registra log
    await this.logRepo.save({
      action: `UPDATE_SETTING:${key}=${value}`,
      performedBy: 'admin'
    });

    return saved;
  }
}
