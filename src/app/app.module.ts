import { Logger, Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { CommunityBoardModule } from '../features/community-board/community-board.module';
import { CommentModule } from '../features/comment/comment.module';
import databaseConfig from '../config/database.config';
import { GraphQLModule } from '@nestjs/graphql';
import { ApolloDriver, ApolloDriverConfig } from '@nestjs/apollo';
import { ValidationPipe } from '@nestjs/common';
import { APP_PIPE, APP_FILTER } from '@nestjs/core';
import { ImageModule } from 'src/features/image/image.module';
import { GlobalExceptionFilter } from '../common/filters/global-exception.filter';

@Module({
  controllers: [],
  providers: [
    {
      provide: APP_PIPE,
      useValue: new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    },
    {
      provide: APP_FILTER,
      useClass: GlobalExceptionFilter,
    },
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
      introspection: true,
      context: ({ req }) => ({ req }),
      csrfPrevention: false,
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
