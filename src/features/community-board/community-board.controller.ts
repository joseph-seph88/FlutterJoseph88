/// 관련 HTTP 요청을 받아서, 서비스로 전달하고, 응답을 반환 :: 엔드포인트 정의

import { Controller, Get, Post, Body, Patch, Param, Delete, HttpCode, HttpStatus, ParseIntPipe } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { CommunityBoardService } from './community-board.service';
// import { CommentService } from '../comment/comment.service';
import { CreateCommunityBoardDto } from './dto/create-community-board.dto';
import { CreateCommentDto } from '../comment/dto/create-comment.dto';
import { UpdateCommunityBoardDto } from './dto/update-community-board.dto';
import {
  ApiCreateResponse,
  ApiGetResponse,
  ApiUpdateResponse,
  ApiDeleteResponse,
  ApiCommonResponses,
  ApiIdParam
} from '../../common/swagger/swagger.decorators';

@ApiTags('community-board')
@Controller('community-board')
export class CommunityBoardController {
  constructor(
    private readonly communityBoardService: CommunityBoardService,
    // private readonly commentService: CommentService,
  ) { }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiCreateResponse('게시글 생성')
  create(@Body() createCommunityBoardDto: CreateCommunityBoardDto) {
    return this.communityBoardService.create(createCommunityBoardDto);
  }

  @Get()
  @ApiGetResponse('게시글 목록 조회')
  findAll() {
    return this.communityBoardService.findAll();
  }

  @Get(':id')
  @ApiGetResponse('게시글 상세 조회')
  @ApiIdParam('id', '게시글 ID')
  async findOne(@Param('id', ParseIntPipe) id: number) {
    await this.communityBoardService.incrementViewCount(id);
    return this.communityBoardService.findOne(id);
  }

  @Patch(':id')
  @ApiUpdateResponse('게시글 수정')
  @ApiIdParam('id', '게시글 ID')
  update(@Param('id', ParseIntPipe) id: number, @Body() updateCommunityBoardDto: UpdateCommunityBoardDto) {
    return this.communityBoardService.update(id, updateCommunityBoardDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiDeleteResponse('게시글 삭제')
  @ApiIdParam('id', '게시글 ID')
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.communityBoardService.remove(id);
  }

  @Post(':id/like')
  @HttpCode(HttpStatus.OK)
  @ApiCommonResponses('게시글 좋아요')
  @ApiIdParam('id', '게시글 ID')
  likePost(@Param('id', ParseIntPipe) id: number) {
    return this.communityBoardService.incrementLikeCount(id);
  }

  // @Post(':id/comments')
  // @HttpCode(HttpStatus.CREATED)
  // @ApiCreateResponse('댓글 작성')
  // @ApiIdParam('id', '게시글 ID')
  // createComment(
  //   @Param('id', ParseIntPipe) postId: number,
  //   @Body() createCommentDto: CreateCommentDto
  // ) {
  //   createCommentDto.postId = postId;
  //   return this.commentService.create(createCommentDto);
  // }

  // @Get(':id/comments')
  // @ApiGetResponse('댓글 목록 조회')
  // @ApiIdParam('id', '게시글 ID')
  // getComments(@Param('id', ParseIntPipe) postId: number) {
  //   return this.commentService.findByPostId(postId);
  // }

  // @Patch('comments/:commentId')
  // @ApiUpdateResponse('댓글 수정')
  // @ApiIdParam('commentId', '댓글 ID')
  // updateComment(
  //   @Param('commentId', ParseIntPipe) commentId: number,
  //   @Body() updateCommentDto: Partial<CreateCommentDto>
  // ) {
  //   return this.commentService.update(commentId, updateCommentDto);
  // }

  // @Delete('comments/:commentId')
  // @HttpCode(HttpStatus.NO_CONTENT)
  // @ApiDeleteResponse('댓글 삭제')
  // @ApiIdParam('commentId', '댓글 ID')
  // removeComment(@Param('commentId', ParseIntPipe) commentId: number) {
  //   return this.commentService.remove(commentId);
  // }

  // @Post('comments/:commentId/like')
  // @HttpCode(HttpStatus.OK)
  // @ApiCommonResponses('댓글 좋아요')
  // @ApiIdParam('commentId', '댓글 ID')
  // likeComment(@Param('commentId', ParseIntPipe) commentId: number) {
  //   return this.commentService.incrementLikeCount(commentId);
  // }

  // @Get('comments/:commentId/replies')
  // @ApiGetResponse('대댓글 목록 조회')
  // @ApiIdParam('commentId', '댓글 ID')
  // getReplies(@Param('commentId', ParseIntPipe) commentId: number) {
  //   return this.commentService.findRepliesByCommentId(commentId);
  // }

  // @Post('comments/:commentId/replies')
  // @HttpCode(HttpStatus.CREATED)
  // @ApiCreateResponse('대댓글 작성')
  // @ApiIdParam('commentId', '댓글 ID')
  // createReply(
  //   @Param('commentId', ParseIntPipe) parentCommentId: number,
  //   @Body() createCommentDto: CreateCommentDto
  // ) {
  //   createCommentDto.parentCommentId = parentCommentId;
  //   return this.commentService.create(createCommentDto);
  // }

  // @Get(':id/comments/tree')
  // @ApiGetResponse('댓글 트리 조회')
  // @ApiIdParam('id', '게시글 ID')
  // getCommentTree(@Param('id', ParseIntPipe) postId: number) {
  //   return this.commentService.findCommentTree(postId);
  // }

  // @Get('comments/:commentId/subtree')
  // @ApiGetResponse('댓글 서브트리 조회')
  // @ApiIdParam('commentId', '댓글 ID')
  // getCommentSubtree(@Param('commentId', ParseIntPipe) commentId: number) {
  //   return this.commentService.findCommentSubtree(commentId);
  // }
}
