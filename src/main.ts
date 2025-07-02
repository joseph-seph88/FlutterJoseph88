import { NestFactory } from '@nestjs/core';
import { AppModule } from './app/app.module';
import { ConfigService } from '@nestjs/config';
import { setupMiddlewares } from './config/middleware.config';
import { SwaggerModule } from '@nestjs/swagger';
import { swaggerConfig } from './config/swagger.config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    cors: {
      origin: true,
      credentials: true,
    }
  });
  setupMiddlewares(app.getHttpAdapter().getInstance());

  const document = SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup('api', app, document);

  const configService = app.get(ConfigService);
  const port = configService.get('PORT', 3000);
  const ip = configService.get('SERVER_IP', '127.0.0.1');
  await app.listen(port, ip);
  console.log(`Server Running (ip/port/env) :`, ip, port, process.env.NODE_ENV);
  console.log(`Swagger UI available at: http://${ip}:${port}/api`);
  console.log(`Playground UI available at: http://${ip}:${port}/graphql`);
}
bootstrap();