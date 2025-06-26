import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, IsNull } from 'typeorm';
import { CreateCommentDto } from './dto/create-comment.dto';
import { Comment } from '../comment/entities/comment.entity';

@Injectable()
export class CommentService {
    constructor(
        @InjectRepository(Comment)
        private commentRepository: Repository<Comment>,
    ) { }

    async create(createCommentDto: CreateCommentDto): Promise<Comment> {
        if (createCommentDto.parentCommentId) {
            const parentComment = await this.commentRepository.findOne({
                where: { id: createCommentDto.parentCommentId }
            });

            if (!parentComment) {
                throw new NotFoundException(`Parent comment with ID ${createCommentDto.parentCommentId} not found`);
            }

            if (parentComment.postId !== createCommentDto.postId) {
                throw new BadRequestException('Reply must be on the same post as the parent comment');
            }
        }

        const comment = this.commentRepository.create(createCommentDto);
        return await this.commentRepository.save(comment);
    }

    async findByPostId(postId: number): Promise<Comment[]> {
        return await this.commentRepository.find({
            where: { postId, parentCommentId: IsNull() },
            relations: ['replies', 'replies.replies'],
            order: {
                createdAt: 'ASC',
                replies: {
                    createdAt: 'ASC',
                    replies: { createdAt: 'ASC' }
                }
            }
        });
    }

    async findRepliesByCommentId(commentId: number): Promise<Comment[]> {
        return await this.commentRepository.find({
            where: { parentCommentId: commentId },
            relations: ['replies'],
            order: {
                createdAt: 'ASC',
                replies: { createdAt: 'ASC' }
            }
        });
    }

    async findOne(id: number): Promise<Comment> {
        const comment = await this.commentRepository.findOne({
            where: { id },
            relations: ['replies', 'replies.replies', 'parentComment']
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

        if (comment.replies && comment.replies.length > 0) {
            comment.content = '[삭제된 댓글입니다]';
            comment.deletedBy = 'user';
            await this.commentRepository.save(comment);
        } else {
            await this.commentRepository.remove(comment);
        }
    }

    async incrementLikeCount(id: number): Promise<void> {
        await this.commentRepository.increment({ id }, 'likeCount', 1);
    }

    async findCommentTree(postId: number): Promise<Comment[]> {
        const comments = await this.commentRepository.find({
            where: { postId },
            relations: ['replies', 'replies.replies', 'replies.replies.replies'],
            order: {
                createdAt: 'ASC',
                replies: {
                    createdAt: 'ASC',
                    replies: {
                        createdAt: 'ASC',
                        replies: { createdAt: 'ASC' }
                    }
                }
            }
        });

        return comments.filter(comment => !comment.parentCommentId);
    }

    async findCommentSubtree(commentId: number): Promise<Comment> {
        const comment = await this.commentRepository.findOne({
            where: { id: commentId },
            relations: ['replies', 'replies.replies', 'replies.replies.replies'],
            order: {
                replies: {
                    createdAt: 'ASC',
                    replies: {
                        createdAt: 'ASC',
                        replies: { createdAt: 'ASC' }
                    }
                }
            }
        });

        if (!comment) {
            throw new NotFoundException(`Comment with ID ${commentId} not found`);
        }

        return comment;
    }
}