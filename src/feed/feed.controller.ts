/// Feed 관련 HTTP 요청을 처리 :: GET /feed, POST /feed 등 엔드포인트 정의
/// HTTP 요청을 받아서, 서비스로 전달하고, 응답을 반환합니다.

import { Controller, Get, Post, Body, Patch, Param, Delete, Query } from '@nestjs/common';
import { FeedService } from './feed.service';
import { CreateFeedDto } from './dto/create-feed.dto';
import { UpdateFeedDto } from './dto/update-feed.dto';

@Controller('feed')
export class FeedController {
  constructor(private readonly feedService: FeedService) { }

  @Post()
  create(@Body() createFeedDto: CreateFeedDto) {
    return this.feedService.create(createFeedDto);
  }

  @Get()
  findAll(
    @Query('type') type?: string,
    @Query('category') category?: string,
  ) {
    return this.feedService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.feedService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateFeedDto: UpdateFeedDto) {
    return this.feedService.update(+id, updateFeedDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.feedService.remove(+id);
  }
}
