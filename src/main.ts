import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ConfigService } from '@nestjs/config';
import * as morgan from 'morgan';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.use(morgan('dev'));

  const config = app.get(ConfigService);
  const port = config.get('PORT', 2000);
  const ip = config.get('SERVER_IP', '127.0.0.2');
  await app.listen(port, ip);
  console.log(`Server Running :`, ip, port);
  console.log('Current Environment:', process.env.NODE_ENV);
}
bootstrap();