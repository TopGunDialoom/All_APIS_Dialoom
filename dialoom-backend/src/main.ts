import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import helmet from 'helmet';
import { json, urlencoded } from 'express';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Seguridad HTTP
  app.use(helmet());
  // Aceptar cuerpos de cierto tamaño
  app.use(json({ limit: '10mb' }));
  app.use(urlencoded({ extended: true, limit: '10mb' }));

  // Versionado global (opcional)
  // app.setGlobalPrefix('api/v1');
  // O bien:
  // import { VersioningType } from '@nestjs/common';
  // app.enableVersioning({
  //   type: VersioningType.URI,
  //   defaultVersion: '1'
  // });

  // Validación de DTOs global
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    transform: true
  }));

  app.enableCors({ origin: '*' });
  await app.listen(3000);
  console.log('Dialoom backend running on port 3000');
}
bootstrap();
