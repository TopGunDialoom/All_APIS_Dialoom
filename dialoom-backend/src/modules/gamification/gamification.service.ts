import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Badge } from './badge.entity';
import { UserBadge } from './user_badge.entity';
import { User } from '../../users/entities/user.entity';

/**
 * GamificationService:
 * - Cálculo y actualización de puntos / niveles.
 * - Manejo de badges (insignias).
 */
@Injectable()
export class GamificationService {
  constructor(
    @InjectRepository(Badge) private badgeRepo: Repository<Badge>,
    @InjectRepository(UserBadge) private userBadgeRepo: Repository<UserBadge>,
    @InjectRepository(User) private userRepo: Repository<User>,
  ) {}

  // Crear o actualizar una Badge
  async createOrUpdateBadge(id: number, data: Partial<Badge>): Promise<Badge> {
    let badge: Badge;
    if (id) {
      badge = await this.badgeRepo.findOne({ where: { id } });
      if (!badge) throw new NotFoundException('Badge not found');
      Object.assign(badge, data);
    } else {
      badge = this.badgeRepo.create(data);
    }
    return this.badgeRepo.save(badge);
  }

  // Listar badges
  async findAllBadges(): Promise<Badge[]> {
    return this.badgeRepo.find();
  }

  // Otorgar una badge a un user
  async awardBadgeToUser(userId: number, badgeId: number): Promise<UserBadge> {
    const user = await this.userRepo.findOne({ where: { id: userId }});
    if (!user) throw new NotFoundException('User not found');
    const badge = await this.badgeRepo.findOne({ where: { id: badgeId }});
    if (!badge) throw new NotFoundException('Badge not found');

    // Revisar si el user ya la tiene
    const existing = await this.userBadgeRepo.findOne({ where: { user: { id: userId }, badge: { id: badgeId } }});
    if (existing) {
      // ya la tiene
      return existing;
    }
    // Sino, crear
    const ub = this.userBadgeRepo.create({ user, badge });
    // Optionally, sumarle pointsReward
    if (badge.pointsReward && badge.pointsReward > 0) {
      await this.incrementUserPoints(user, badge.pointsReward);
    }
    return this.userBadgeRepo.save(ub);
  }

  // Sumar puntos a un user y check if sube de nivel
  async incrementUserPoints(user: User, additionalPoints: number): Promise<User> {
    user.points = (user.points || 0) + additionalPoints;
    // Lógica de niveles, p.ej. cada 100 pts -> +1 level
    const newLevel = Math.floor((user.points || 0) / 100) + 1; // ejemplo simple
    user.level = newLevel;
    return this.userRepo.save(user);
  }

  // Lógica para awarding badges de forma automatica, p.ej. si user completa X
  // Se puede invocar en hooks de reservaciones, etc.
  async checkAndAwardAchievementBySession(userId: number): Promise<void> {
    // dummy: ej. si user pasa 10 sesiones -> award "Súper Viajero"
    // En la vida real, revisas # de reservas completadas, etc.
  }
}
