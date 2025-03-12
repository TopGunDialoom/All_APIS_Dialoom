import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import helmet from 'helmet';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Helmet para seguridad
  app.use(helmet());

  // Validation global
  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));

  // CORS
  app.enableCors();

  const port = process.env.PORT || 3000;
  await app.listen(port);
  console.log(`Dialoom running on port ${port}`);
}
bootstrap();
