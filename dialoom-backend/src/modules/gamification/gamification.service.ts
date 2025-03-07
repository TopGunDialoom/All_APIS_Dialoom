import { Injectable } from '@nestjs/common';

@Injectable()
export class GamificationService {
  getAchievements() {
    return ['Achievement1','Achievement2'];
  }
}
