import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';
import { CommunityBoardModule } from './community-board/community-board.module';

@Module({
  controllers: [AppController],
  providers: [AppService],
  imports: [
    ConfigModule.forRoot(),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'joseph',
      password: 'admin123!',
      database: 'nest_test',
      autoLoadEntities: true,
      synchronize: true,
    }),
    CommunityBoardModule
  ],
})
export class AppModule { }
