import { Module } from '@nestjs/common';
import { HairService } from './hair.service';
import { HairController } from './hair.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Hair } from './entities/hair.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Hair])],
  controllers: [HairController],
  providers: [HairService],
})
export class HairModule { }
