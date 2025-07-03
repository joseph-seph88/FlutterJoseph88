import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, IsNull } from 'typeorm';
import { CreateCommentDto } from './dto/create-comment.dto';
import { Comment } from '../comment/entities/comment.entity';
import { ResponseCommentDto } from './dto/response-comment.dto';
import { plainToInstance } from 'class-transformer';
import { UpdateCommentDto } from './dto/update-comment.dto';
import { CommonResponse } from 'src/common/response-dto/common-response.dto';

@Injectable()
export class CommentService {
    constructor(
        @InjectRepository(Comment)
        private commentRepository: Repository<Comment>,
    ) { }

    async create(createCommentDto: CreateCommentDto): Promise<CommonResponse> {
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
        await this.commentRepository.save(comment);
        return {
            statusCode: 201,
            message: '리소스가 성공적으로 생성되었습니다.'
        };
    }

    async findByPostId(postId: number): Promise<ResponseCommentDto[]> {
        const comments = await this.commentRepository.find({
            where: { postId, parentCommentId: IsNull(), deletedAt: IsNull() },
            relations: ['replies', 'replies.replies'],
            order: {
                createdAt: 'ASC',
                replies: {
                    createdAt: 'ASC',
                    replies: { createdAt: 'ASC' }
                }
            }
        });
        return comments;
    }

    async findRepliesByCommentId(commentId: number): Promise<ResponseCommentDto[]> {
        const replies = await this.commentRepository.find({
            where: { parentCommentId: commentId, deletedAt: IsNull() },
            relations: ['replies'],
            order: {
                createdAt: 'ASC',
                replies: { createdAt: 'ASC' }
            }
        });
        return replies;
    }

    async findOne(id: number): Promise<ResponseCommentDto> {
        const comment = await this.commentRepository.findOne({
            where: { id, deletedAt: IsNull() },
            relations: ['replies', 'replies.replies', 'parentComment']
        });

        if (!comment) {
            throw new NotFoundException(`Comment with ID ${id} not found`);
        }

        return comment;
    }

    async update(id: number, updateCommentDto: UpdateCommentDto): Promise<ResponseCommentDto> {
        const comment = await this.findOne(id);
        Object.assign(comment, updateCommentDto);
        await this.commentRepository.save(comment);

        return plainToInstance(ResponseCommentDto, comment, { excludeExtraneousValues: true });
    }

    async remove(id: number): Promise<CommonResponse> {
        await this.commentRepository.softDelete(id);
        return {
            statusCode: 204,
            message: '리소스가 성공적으로 삭제되었습니다.'
        };
    }

    async incrementLikeCount(id: number): Promise<void> {
        await this.commentRepository.increment({ id }, 'likeCount', 1);
    }

    async findCommentTree(postId: number): Promise<Comment[]> {
        const comments = await this.commentRepository.find({
            where: { postId, deletedAt: IsNull() },
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
            where: { id: commentId, deletedAt: IsNull() },
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