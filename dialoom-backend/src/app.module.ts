import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { MailerModule } from './modules/mailer/mailer.module';

@Module({
  imports: [,,,,
    ScalabilityModule
    I18nModule
    AdminModule
    NotificationsModule
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        type: 'mysql',
        host: config.get<string>('DB_HOST'),
        port: config.get<number>('DB_PORT'),
        username: config.get<string>('DB_USER'),
        password: config.get<string>('DB_PASSWORD'),
        database: config.get<string>('DB_NAME'),
        entities: [__dirname + '/modules/**/*.entity.{ts,js}'],
        synchronize: false,
      }),
    }),
    // Módulos iniciales
    AuthModule,
    UsersModule,
    PaymentsModule,
    MailerModule, // placeholder para correo
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
