import { Resolver, Query, Mutation, Args, Int } from '@nestjs/graphql';
import { CommunityBoard } from './entities/community-board.entity';
import { CommunityBoardService } from './community-board.service';
import { CreateCommunityBoardDto } from './dto/create-community-board.dto';
import { UpdateCommunityBoardDto } from './dto/update-community-board.dto';

@Resolver(() => CommunityBoard)
export class CommunityBoardResolver {
    constructor(private readonly communityBoardService: CommunityBoardService) { }

    @Query(() => [CommunityBoard])
    async getCommunityList(): Promise<CommunityBoard[]> {
        return this.communityBoardService.findAll();
    }

    @Query(() => CommunityBoard, { nullable: true })
    async getCommunity(@Args('id', { type: () => Int }) id: number): Promise<CommunityBoard> {
        return this.communityBoardService.findOne(id);
    }

    @Mutation(() => CommunityBoard)
    async createCommunityBoard(
        @Args('createCommunityBoardInput') createCommunityBoardDto: CreateCommunityBoardDto,
    ): Promise<CommunityBoard> {
        return this.communityBoardService.create(createCommunityBoardDto);
    }

    @Mutation(() => CommunityBoard)
    async updateCommunity(
        @Args('id', { type: () => Int }) id: number,
        @Args('updateCommunityInput') updateCommunityBoardDto: UpdateCommunityBoardDto,
    ): Promise<CommunityBoard> {
        return this.communityBoardService.update(id, updateCommunityBoardDto);
    }

    @Mutation(() => CommunityBoard)
    async removeCommunity(@Args('id', { type: () => Int }) id: number): Promise<CommunityBoard> {
        const post = await this.communityBoardService.findOne(id);
        await this.communityBoardService.remove(id);
        return post;
    }
}