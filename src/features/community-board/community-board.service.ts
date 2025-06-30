import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, IsNull } from 'typeorm';
import { CreateCommunityBoardDto } from './dto/create-community-board.dto';
import { UpdateCommunityBoardDto } from './dto/update-community-board.dto';
import { ResponseCommunityBoardDto } from './dto/response-community-board.dto';
import { CommunityBoard } from './entities/community-board.entity';
import { BasicResponse } from 'src/common/response.dto.ts/basic-response.dto';
import { plainToInstance } from 'class-transformer';

@Injectable()
export class CommunityBoardService {
  constructor(
    @InjectRepository(CommunityBoard)
    private communityBoardRepository: Repository<CommunityBoard>,
  ) { }

  async create(createCommunityBoardDto: CreateCommunityBoardDto): Promise<BasicResponse> {
    const post = this.communityBoardRepository.create(createCommunityBoardDto);
    await this.communityBoardRepository.save(post);
    return {
      statusCode: 201,
      message: '리소스가 성공적으로 생성되었습니다.'
    };
  }

  async findOne(id: number): Promise<ResponseCommunityBoardDto> {
    const post = await this.communityBoardRepository.findOne({
      where: { id, deletedAt: IsNull() },
      relations: ['comments']
    });

    if (!post) {
      throw new NotFoundException(`Community board post with ID ${id} not found`);
    }

    return post;
  }

  async findAll(): Promise<ResponseCommunityBoardDto[]> {
    const posts = await this.communityBoardRepository.find({
      where: { deletedAt: IsNull() },
      relations: ['comments'],
      order: { createdAt: 'DESC' }
    });

    return posts;
  }

  async update(id: number, updateCommunityBoardDto: UpdateCommunityBoardDto): Promise<ResponseCommunityBoardDto> {
    const post = await this.communityBoardRepository.findOne({
      where: { id, deletedAt: IsNull() }
    });

    if (!post) {
      throw new NotFoundException(`Community board post with ID ${id} not found`);
    }

    Object.assign(post, updateCommunityBoardDto);
    await this.communityBoardRepository.save(post);
    return plainToInstance(ResponseCommunityBoardDto, post, { excludeExtraneousValues: true });
  }

  async remove(id: number): Promise<BasicResponse> {
    // const post = await this.findOne(id);
    // await this.communityBoardRepository.remove(post);
    await this.communityBoardRepository.softDelete(id);

    return {
      statusCode: 204,
      message: '리소스가 성공적으로 삭제되었습니다.'
    };
  }

  async incrementViewCount(id: number): Promise<void> {
    await this.communityBoardRepository.increment({ id }, 'viewCount', 1);
  }

  async incrementLikeCount(id: number): Promise<void> {
    await this.communityBoardRepository.increment({ id }, 'likeCount', 1);
  }
}
