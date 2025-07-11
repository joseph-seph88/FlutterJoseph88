import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

export const swaggerConfig = new DocumentBuilder()
    .setTitle('AI HAIR API FROM JOSEPH88')
    .setDescription('AI 헤어 API 문서')
    .setVersion('1.0.01')
    .build();