import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateCommentDto } from './dto/create-comment.dto';
import { Comment } from './entities/comment.entity';

@Injectable()
export class CommentService {
    constructor(
        @InjectRepository(Comment)
        private commentRepository: Repository<Comment>,
    ) { }

    async create(createCommentDto: CreateCommentDto): Promise<Comment> {
        const comment = this.commentRepository.create(createCommentDto);
        return await this.commentRepository.save(comment);
    }

    async findByPostId(postId: number): Promise<Comment[]> {
        return await this.commentRepository.find({
            where: { postId },
            order: { createdAt: 'ASC' }
        });
    }

    async findOne(id: number): Promise<Comment> {
        const comment = await this.commentRepository.findOne({
            where: { id }
        });

        if (!comment) {
            throw new NotFoundException(`Comment with ID ${id} not found`);
        }

        return comment;
    }

    async update(id: number, updateCommentDto: Partial<CreateCommentDto>): Promise<Comment> {
        const comment = await this.findOne(id);
        Object.assign(comment, updateCommentDto);
        return await this.commentRepository.save(comment);
    }

    async remove(id: number): Promise<void> {
        const comment = await this.findOne(id);
        await this.commentRepository.remove(comment);
    }

    async incrementLikeCount(id: number): Promise<void> {
        await this.commentRepository.increment({ id }, 'likeCount', 1);
    }
}