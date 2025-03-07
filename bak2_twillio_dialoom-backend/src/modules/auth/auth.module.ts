import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
// import { AppleStrategy } from './strategies/apple.strategy';

@Module({
  controllers: [AuthController],
  providers: [
    // AppleStrategy, etc.
  ],
  exports: []
})
export class AuthModule {}
