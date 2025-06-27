import { Resolver, Query, Mutation, Args, Int } from '@nestjs/graphql';
import { Comment } from './entities/comment.entity';
import { CommentService } from './comment.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';

@Resolver(() => Comment)
export class CommentResolver {
    constructor(private readonly commentService: CommentService) { }

    @Query(() => [Comment])
    async getCommentsByPostId(@Args('postId', { type: () => Int }) postId: number): Promise<Comment[]> {
        return this.commentService.findByPostId(postId);
    }

    @Mutation(() => Comment)
    async createComment(
        @Args('createCommentInput') createCommentDto: CreateCommentDto,
    ): Promise<Comment> {
        return this.commentService.create(createCommentDto);
    }

    @Mutation(() => Comment)
    async updateComment(
        @Args('id', { type: () => Int }) id: number,
        @Args('updateCommentInput') updateCommentDto: UpdateCommentDto,
    ): Promise<Comment> {
        return this.commentService.update(id, updateCommentDto);
    }

    @Mutation(() => Comment)
    async removeComment(@Args('id', { type: () => Int }) id: number): Promise<Comment> {
        const comment = await this.commentService.findOne(id);
        await this.commentService.remove(id);
        return comment;
    }
}