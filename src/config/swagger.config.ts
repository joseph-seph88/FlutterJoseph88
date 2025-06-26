import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

export const swaggerConfig = new DocumentBuilder()
    .setTitle('COMMUNITY BOARD API FROM JOSEPH88')
    .setDescription('커뮤니티 게시판 API 문서')
    .setVersion('1.0.01')
    .addTag('community-board')
    .addTag('comments')
    .build();