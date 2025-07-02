import { Logger, Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
// import { AppController } from './app.controller';
// import { AppService } from './app.service';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { CommunityBoardModule } from '../features/community-board/community-board.module';
import { CommentModule } from '../features/comment/comment.module';
import databaseConfig from '../config/database.config';
import { GraphQLModule } from '@nestjs/graphql';
import { ApolloDriver, ApolloDriverConfig } from '@nestjs/apollo';
import { ValidationPipe } from '@nestjs/common';
import { APP_PIPE } from '@nestjs/core';
import { ImageModule } from 'src/features/image/image.module';
// import { UploadScalar } from 'src/common/scalars/upload.scalar';

@Module({
  controllers: [
    // AppController
  ],
  providers: [
    // AppService
    {
      provide: APP_PIPE,
      useValue: new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    },
    // UploadScalar,
  ],
  imports: [
    GraphQLModule.forRoot<ApolloDriverConfig>({
      driver: ApolloDriver,
      autoSchemaFile: true,
      playground: {
        settings: {
          'request.credentials': 'include',
          'schema.polling.enable': false,
        },
      },
      // debug: true,
      introspection: true,
      context: ({ req }) => ({ req }),
      csrfPrevention: false, // CSRF 보호 비활성화 (개발 환경용)
    }),
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: [`.env.${process.env.NODE_ENV}`, '.env'],
      load: [databaseConfig],
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (config: ConfigService) => config.get('database') || {},
      inject: [ConfigService],
    }),
    CommunityBoardModule,
    CommentModule,
    ImageModule
  ],
})
export class AppModule { }
