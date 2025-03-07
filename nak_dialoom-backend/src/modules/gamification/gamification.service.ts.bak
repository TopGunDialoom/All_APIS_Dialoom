import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { Achievement } from './entities/achievement.entity';
import { Level } from './entities/level.entity';
import { UserAchievement } from './entities/user-achievement.entity';
import { UsersService } from '../users/users.service';
import { User } from '../users/entities/user.entity';

@Injectable()
export class GamificationService {
  constructor(
    @InjectRepository(Achievement) private achieveRepo: Repository<Achievement>,
    @InjectRepository(Level) private levelRepo: Repository<Level>,
    @InjectRepository(UserAchievement) private userAchRepo: Repository<UserAchievement>,
    private usersService: UsersService,
  ) {}

  async awardAchievement(userId: number, achievementId: number) {
    const user = await this.usersService.findById(userId);
    const achievement = await this.achieveRepo.findOne({ where: { id: achievementId } });
    if (!user || !achievement) return;
    // Verificar si ya existe
    const exists = await this.userAchRepo.findOne({ where: { user: { id: userId }, achievement: { id: achievementId } } });
    if (!exists) {
      const ua = this.userAchRepo.create({ user, achievement });
      await this.userAchRepo.save(ua);
      // Sumar puntos si achievement.points > 0
      if (achievement.points > 0) {
        await this.addPoints(userId, achievement.points);
      }
    }
  }

  async addPoints(userId: number, points: number) {
    const user = await this.usersService.findById(userId);
    if (!user) return;
    user.points += points;
    // Check nivel
    const levels = await this.levelRepo.find();
    levels.sort((a,b) => a.requiredPoints - b.requiredPoints);
    let newLevel = user.level;
    for (const lvl of levels) {
      if (user.points >= lvl.requiredPoints && lvl.levelNumber > newLevel) {
        newLevel = lvl.levelNumber;
      }
    }
    user.level = newLevel;
    await this.usersService.updateProfile(user.id, { points: user.points, level: user.level });
  }

  // CRUD básicos para logros, niveles
  async createAchievement(name: string, description: string, points: number = 0) {
    const achieve = this.achieveRepo.create({ name, description, points });
    return this.achieveRepo.save(achieve);
  }

  async createLevel(levelNumber: number, requiredPoints: number) {
    const lvl = this.levelRepo.create({ levelNumber, requiredPoints });
    return this.levelRepo.save(lvl);
  }
}
