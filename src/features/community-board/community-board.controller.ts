import { Controller, Get, Post, Body, Patch, Param, Delete, HttpCode, HttpStatus, ParseIntPipe } from '@nestjs/common';
import { CommunityBoardService } from './community-board.service';
import { CreateCommunityBoardDto } from './dto/create-community-board.dto';
import { ResponseCommunityBoardDto } from './dto/response-community-board.dto';
import { UpdateCommunityBoardDto } from './dto/update-community-board.dto';
import {
  ApiCreateResponse,
  ApiGetResponse,
  ApiUpdateResponse,
  ApiDeleteResponse,
  ApiCommonResponses,
  ApiIdParam
} from '../../common/swagger/swagger.decorators';

@Controller('community-board')
export class CommunityBoardController {
  constructor(
    private readonly communityBoardService: CommunityBoardService,
  ) { }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiCreateResponse('게시글 생성')
  async create(@Body() createCommunityBoardDto: CreateCommunityBoardDto) {
    return await this.communityBoardService.create(createCommunityBoardDto);
  }

  @Get()
  @ApiGetResponse('게시글 목록 조회', [ResponseCommunityBoardDto])
  findAll() {
    return this.communityBoardService.findAll();
  }

  @Get(':id')
  @ApiGetResponse('게시글 상세 조회', ResponseCommunityBoardDto)
  @ApiIdParam('id', '게시글 ID')
  async findOne(@Param('id', ParseIntPipe) id: number) {
    await this.communityBoardService.incrementViewCount(id);
    return this.communityBoardService.findOne(id);
  }

  @Patch(':id')
  @ApiUpdateResponse('게시글 수정', ResponseCommunityBoardDto)
  @ApiIdParam('id', '게시글 ID')
  async update(@Param('id', ParseIntPipe) id: number, @Body() updateCommunityBoardDto: UpdateCommunityBoardDto) {
    return await this.communityBoardService.update(id, updateCommunityBoardDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @ApiDeleteResponse('게시글 삭제')
  @ApiIdParam('id', '게시글 ID')
  async remove(@Param('id', ParseIntPipe) id: number) {
    return await this.communityBoardService.remove(id);
  }

  // @Post(':id/like')
  // @HttpCode(HttpStatus.OK)
  // @ApiCommonResponses('게시글 좋아요')
  // @ApiIdParam('id', '게시글 ID')
  // likePost(@Param('id', ParseIntPipe) id: number) {
  //   return this.communityBoardService.incrementLikeCount(id);
  // }
}