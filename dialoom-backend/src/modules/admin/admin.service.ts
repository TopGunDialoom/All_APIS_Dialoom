import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { UsersService } from '../users/users.service'; // asumiendo que existe
import { PaymentsService } from '../payments/payments.service'; // asumiendo
// import { ReservationsService } from '../reservations/reservations.service'; // si existe

@Injectable()
export class AdminService {
  private readonly logger = new Logger(AdminService.name);

  constructor(
    private readonly usersService: UsersService,
    private readonly paymentsService: PaymentsService,
    // private readonly reservationsService: ReservationsService,
  ) {}

  /**
   * Ejemplo: Obtener info de un user, forzando su ban, etc.
   */
  async banUser(userId: number): Promise<void> {
    this.logger.warn(`Baneando user con ID=${userId} (ejemplo)`);
    const user = await this.usersService.findById(userId);
    if (!user) {
      throw new BadRequestException('Usuario no encontrado');
    }
    // user.isBanned = true; // si tu entity user tiene esa prop
    await this.usersService.saveUser(user);
    // la acción de ban se registra en logs o en una entidad de logs
  }

  /**
   * Ejemplo de ver transacciones globales.
   */
  async getAllTransactions() {
    return this.paymentsService.findAllTransactions(); // asumiendo tengas un findAll
  }

  /**
   * Ej: Ajustar la comisión global en stripe, etc.
   */
  async setCommissionRate(newRate: number) {
    // tu logic
    this.logger.log(`Set commissionRate = ${newRate} (placeholder).`);
    // Podrías usar un SettingService, o config global
  }

  // ... añade aquí la lógica de admin que requieras
}
