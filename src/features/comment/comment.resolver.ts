import { Resolver, Query, Mutation, Args, Int } from '@nestjs/graphql';
import { Comment } from './entities/comment.entity';
import { CommentService } from './comment.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';
import { BasicResponse } from 'src/common/response-dto/basic-response.dto';
import { ResponseCommentDto } from './dto/response-comment.dto';

@Resolver(() => Comment)
export class CommentResolver {
    constructor(private readonly commentService: CommentService) { }

    @Query(() => [ResponseCommentDto])
    async getCommentsByPostId(@Args('postId', { type: () => Int }) postId: number) {
        return await this.commentService.findByPostId(postId);
    }

    @Mutation(() => BasicResponse)
    async createComment(
        @Args('createCommentInput') createCommentDto: CreateCommentDto) {
        return await this.commentService.create(createCommentDto);
    }

    @Mutation(() => ResponseCommentDto)
    async updateComment(
        @Args('id', { type: () => Int }) id: number,
        @Args('updateCommentInput') updateCommentDto: UpdateCommentDto) {
        return await this.commentService.update(id, updateCommentDto);
    }

    @Mutation(() => BasicResponse)
    async removeComment(@Args('id', { type: () => Int }) id: number) {
        return await this.commentService.remove(id);
    }
}