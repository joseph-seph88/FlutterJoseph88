import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ConfigService } from '@nestjs/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const config = app.get(ConfigService);
  const port = config.get('PORT', 3000);
  const ip = config.get('SERVER_IP', '127.0.0.1');
  await app.listen(port, ip);
  console.log(`Server Running : ${ip} : ${port}`);
}
bootstrap();