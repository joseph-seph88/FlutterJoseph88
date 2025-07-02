import { Resolver, Query, Mutation, Args, Int } from '@nestjs/graphql';
import { CommunityBoard } from './entities/community-board.entity';
import { CommunityBoardService } from './community-board.service';
import { CreateCommunityBoardDto } from './dto/create-community-board.dto';
import { UpdateCommunityBoardDto } from './dto/update-community-board.dto';
import { BasicResponse } from 'src/common/response-dto/basic-response.dto';
import { ResponseCommunityBoardDto } from './dto/response-community-board.dto';

@Resolver(() => CommunityBoard)
export class CommunityBoardResolver {
    constructor(private readonly communityBoardService: CommunityBoardService) { }

    @Query(() => [ResponseCommunityBoardDto])
    async getCommunityList() {
        return this.communityBoardService.findAll();
    }

    @Query(() => ResponseCommunityBoardDto, { nullable: true })
    async getCommunity(@Args('id', { type: () => Int }) id: number) {
        return this.communityBoardService.findOne(id);
    }

    @Mutation(() => BasicResponse)
    async createCommunityBoard(
        @Args('createCommunityBoardInput') createCommunityBoardDto: CreateCommunityBoardDto) {
        return await this.communityBoardService.create(createCommunityBoardDto);
    }

    @Mutation(() => ResponseCommunityBoardDto)
    async updateCommunity(
        @Args('id', { type: () => Int }) id: number,
        @Args('updateCommunityInput') updateCommunityBoardDto: UpdateCommunityBoardDto) {
        return await this.communityBoardService.update(id, updateCommunityBoardDto);
    }

    @Mutation(() => BasicResponse)
    async removeCommunity(@Args('id', { type: () => Int }) id: number) {
        return await this.communityBoardService.remove(id);
    }
}