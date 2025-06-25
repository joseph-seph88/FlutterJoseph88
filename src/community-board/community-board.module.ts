import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CommunityBoardService } from './community-board.service';
import { CommentService } from './comment.service';
import { CommunityBoardController } from './community-board.controller';
import { CommunityBoard } from './entities/community-board.entity';
import { Comment } from './entities/comment.entity';

@Module({
  imports: [TypeOrmModule.forFeature([CommunityBoard, Comment])],
  controllers: [CommunityBoardController],
  providers: [CommunityBoardService, CommentService],
  exports: [CommunityBoardService, CommentService],
})
export class CommunityBoardModule { }
