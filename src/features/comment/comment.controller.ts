import { Controller, Get, Post, Body, Patch, Param, Delete, HttpCode, HttpStatus, ParseIntPipe } from '@nestjs/common';
import { CommentService } from '../comment/comment.service';
import { CreateCommentDto } from '../comment/dto/create-comment.dto';
import {
    ApiCreateResponse,
    ApiGetResponse,
    ApiUpdateResponse,
    ApiDeleteResponse,
    ApiCommonResponses,
    ApiIdParam
} from '../../common/swagger/swagger.decorators';
import { ResponseCommentDto } from './dto/response-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';

@Controller('comments')
export class CommentController {
    constructor(
        private readonly commentService: CommentService,
    ) { }

    @Post(':id')
    @HttpCode(HttpStatus.CREATED)
    @ApiCreateResponse('댓글 작성')
    @ApiIdParam('id', '게시글 ID')
    createComment(
        @Param('id', ParseIntPipe) postId: number,
        @Body() createCommentDto: CreateCommentDto
    ) {
        createCommentDto.postId = postId;
        return this.commentService.create(createCommentDto);
    }

    @Get(':id')
    @ApiGetResponse('댓글 목록 조회', [ResponseCommentDto])
    @ApiIdParam('id', '게시글 ID')
    getComments(@Param('id', ParseIntPipe) postId: number) {
        return this.commentService.findByPostId(postId);
    }

    @Get(':commentId/comment')
    @ApiGetResponse('선택 댓글 조회', ResponseCommentDto)
    @ApiIdParam('commentId', '댓글 ID')
    getCommentOne(@Param('commentId', ParseIntPipe) commentId: number) {
        return this.commentService.findOne(commentId);
    }

    @Patch(':commentId/comment')
    @ApiUpdateResponse('댓글 수정', ResponseCommentDto)
    @ApiIdParam('commentId', '댓글 ID')
    updateComment(
        @Param('commentId', ParseIntPipe) commentId: number,
        @Body() updateCommentDto: UpdateCommentDto
    ) {
        return this.commentService.update(commentId, updateCommentDto);
    }

    @Delete(':commentId/comment')
    @HttpCode(HttpStatus.OK)
    @ApiDeleteResponse('댓글 삭제')
    @ApiIdParam('commentId', '댓글 ID')
    removeComment(@Param('commentId', ParseIntPipe) commentId: number) {
        return this.commentService.remove(commentId);
    }
}

//     @Post('comments/:commentId/like')
//     @HttpCode(HttpStatus.OK)
//     @ApiCommonResponses('댓글 좋아요')
//     @ApiIdParam('commentId', '댓글 ID')
//     likeComment(@Param('commentId', ParseIntPipe) commentId: number) {
//         return this.commentService.incrementLikeCount(commentId);
//     }

//     @Get('comments/:commentId/replies')
//     @ApiGetResponse('대댓글 목록 조회')
//     @ApiIdParam('commentId', '댓글 ID')
//     getReplies(@Param('commentId', ParseIntPipe) commentId: number) {
//         return this.commentService.findRepliesByCommentId(commentId);
//     }

//     @Post('comments/:commentId/replies')
//     @HttpCode(HttpStatus.CREATED)
//     @ApiCreateResponse('대댓글 작성')
//     @ApiIdParam('commentId', '댓글 ID')
//     createReply(
//         @Param('commentId', ParseIntPipe) parentCommentId: number,
//         @Body() createCommentDto: CreateCommentDto
//     ) {
//         createCommentDto.parentCommentId = parentCommentId;
//         return this.commentService.create(createCommentDto);
//     }

//     @Get(':id/comments/tree')
//     @ApiGetResponse('댓글 트리 조회')
//     @ApiIdParam('id', '게시글 ID')
//     getCommentTree(@Param('id', ParseIntPipe) postId: number) {
//         return this.commentService.findCommentTree(postId);
//     }

//     @Get('comments/:commentId/subtree')
//     @ApiGetResponse('댓글 서브트리 조회')
//     @ApiIdParam('commentId', '댓글 ID')
//     getCommentSubtree(@Param('commentId', ParseIntPipe) commentId: number) {
//         return this.commentService.findCommentSubtree(commentId);
//     }
// }