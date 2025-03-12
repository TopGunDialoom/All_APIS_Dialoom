import { IsString, IsOptional, MaxLength } from 'class-validator';
import { UserRole } from '../entities/user.entity';

export class UpdateUserDto {
  @IsOptional()
  @IsString()
  @MaxLength(100)
  name?: string;

  @IsOptional()
  role?: UserRole;  // cambiar el rol si es admin
}
