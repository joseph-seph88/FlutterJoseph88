import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CommunityBoardService } from './community-board.service';
import { CommentService } from '../comment/comment.service';
import { CommunityBoardController } from './community-board.controller';
import { CommunityBoard } from './entities/community-board.entity';
import { Comment } from '../comment/entities/comment.entity';
import { CommunityBoardResolver } from './community-board.resolver';

@Module({
  imports: [TypeOrmModule.forFeature([CommunityBoard, Comment])],
  controllers: [CommunityBoardController],
  providers: [CommunityBoardService, CommentService, CommunityBoardResolver],
  exports: [CommunityBoardService, CommentService],
})
export class CommunityBoardModule { }
