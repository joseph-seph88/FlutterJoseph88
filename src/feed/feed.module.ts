/// 관련된 컨트롤러, 서비스, 프로바이더를 묶어줍니다.

import { Module } from '@nestjs/common';
import { FeedService } from './feed.service';
import { FeedController } from './feed.controller';

@Module({
  controllers: [FeedController],
  providers: [FeedService],
})
export class FeedModule { }
