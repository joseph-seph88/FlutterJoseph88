import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CommentService } from '../comment/comment.service';
import { CommentController } from '../comment/comment.controller';
import { Comment } from '../comment/entities/comment.entity';

@Module({
    imports: [TypeOrmModule.forFeature([Comment])],
    controllers: [CommentController],
    providers: [CommentService],
    exports: [CommentService],
})
export class CommentModule { }
