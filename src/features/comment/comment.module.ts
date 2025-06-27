import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CommentService } from '../comment/comment.service';
import { CommentController } from '../comment/comment.controller';
import { Comment } from '../comment/entities/comment.entity';
import { CommentResolver } from './comment.resolver';


@Module({
    imports: [TypeOrmModule.forFeature([Comment])],
    controllers: [CommentController],
    providers: [CommentService, CommentResolver],
    exports: [CommentService],
})
export class CommentModule { }
