/// 데이터 처리, DB 연동 등 실제 비즈니스 로직을 처리

import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateCommunityBoardDto } from './dto/create-community-board.dto';
import { UpdateCommunityBoardDto } from './dto/update-community-board.dto';
import { CommunityBoard } from './entities/community-board.entity';

@Injectable()
export class CommunityBoardService {
  constructor(
    @InjectRepository(CommunityBoard)
    private communityBoardRepository: Repository<CommunityBoard>,
  ) { }

  async create(createCommunityBoardDto: CreateCommunityBoardDto): Promise<CommunityBoard> {
    const post = this.communityBoardRepository.create(createCommunityBoardDto);
    return await this.communityBoardRepository.save(post);
  }

  async findAll(): Promise<CommunityBoard[]> {
    return await this.communityBoardRepository.find({
      relations: ['comments'],
      order: { createdAt: 'DESC' }
    });
  }

  async findOne(id: number): Promise<CommunityBoard> {
    const post = await this.communityBoardRepository.findOne({
      where: { id },
      relations: ['comments']
    });

    if (!post) {
      throw new NotFoundException(`Community board post with ID ${id} not found`);
    }

    return post;
  }

  async update(id: number, updateCommunityBoardDto: UpdateCommunityBoardDto): Promise<CommunityBoard> {
    const post = await this.findOne(id);
    Object.assign(post, updateCommunityBoardDto);
    return await this.communityBoardRepository.save(post);
  }

  async remove(id: number): Promise<void> {
    const post = await this.findOne(id);
    await this.communityBoardRepository.remove(post);
  }

  async incrementViewCount(id: number): Promise<void> {
    await this.communityBoardRepository.increment({ id }, 'viewCount', 1);
  }

  async incrementLikeCount(id: number): Promise<void> {
    await this.communityBoardRepository.increment({ id }, 'likeCount', 1);
  }
}
