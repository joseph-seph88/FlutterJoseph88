/// 관련 HTTP 요청을 받아서, 서비스로 전달하고, 응답을 반환 :: 엔드포인트 정의

import { Controller, Get, Post, Body, Patch, Param, Delete, HttpCode, HttpStatus, ParseIntPipe } from '@nestjs/common';
import { CommunityBoardService } from './community-board.service';
import { CommentService } from './comment.service';
import { CreateCommunityBoardDto } from './dto/create-community-board.dto';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommunityBoardDto } from './dto/update-community-board.dto';

@Controller('community-board')
export class CommunityBoardController {
  constructor(
    private readonly communityBoardService: CommunityBoardService,
    private readonly commentService: CommentService,
  ) { }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  create(@Body() createCommunityBoardDto: CreateCommunityBoardDto) {
    return this.communityBoardService.create(createCommunityBoardDto);
  }

  @Get()
  findAll() {
    return this.communityBoardService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id', ParseIntPipe) id: number) {
    await this.communityBoardService.incrementViewCount(id);
    return this.communityBoardService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id', ParseIntPipe) id: number, @Body() updateCommunityBoardDto: UpdateCommunityBoardDto) {
    return this.communityBoardService.update(id, updateCommunityBoardDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.communityBoardService.remove(id);
  }

  @Post(':id/like')
  @HttpCode(HttpStatus.OK)
  likePost(@Param('id', ParseIntPipe) id: number) {
    return this.communityBoardService.incrementLikeCount(id);
  }

  @Post(':id/comments')
  @HttpCode(HttpStatus.CREATED)
  createComment(
    @Param('id', ParseIntPipe) postId: number,
    @Body() createCommentDto: CreateCommentDto
  ) {
    createCommentDto.postId = postId;
    return this.commentService.create(createCommentDto);
  }

  @Get(':id/comments')
  getComments(@Param('id', ParseIntPipe) postId: number) {
    return this.commentService.findByPostId(postId);
  }

  @Patch('comments/:commentId')
  updateComment(
    @Param('commentId', ParseIntPipe) commentId: number,
    @Body() updateCommentDto: Partial<CreateCommentDto>
  ) {
    return this.commentService.update(commentId, updateCommentDto);
  }

  @Delete('comments/:commentId')
  @HttpCode(HttpStatus.NO_CONTENT)
  removeComment(@Param('commentId', ParseIntPipe) commentId: number) {
    return this.commentService.remove(commentId);
  }

  @Post('comments/:commentId/like')
  @HttpCode(HttpStatus.OK)
  likeComment(@Param('commentId', ParseIntPipe) commentId: number) {
    return this.commentService.incrementLikeCount(commentId);
  }

  @Get('comments/:commentId/replies')
  getReplies(@Param('commentId', ParseIntPipe) commentId: number) {
    return this.commentService.findRepliesByCommentId(commentId);
  }

  @Post('comments/:commentId/replies')
  @HttpCode(HttpStatus.CREATED)
  createReply(
    @Param('commentId', ParseIntPipe) parentCommentId: number,
    @Body() createCommentDto: CreateCommentDto
  ) {
    createCommentDto.parentCommentId = parentCommentId;
    return this.commentService.create(createCommentDto);
  }

  @Get(':id/comments/tree')
  getCommentTree(@Param('id', ParseIntPipe) postId: number) {
    return this.commentService.findCommentTree(postId);
  }

  @Get('comments/:commentId/subtree')
  getCommentSubtree(@Param('commentId', ParseIntPipe) commentId: number) {
    return this.commentService.findCommentSubtree(commentId);
  }
}
