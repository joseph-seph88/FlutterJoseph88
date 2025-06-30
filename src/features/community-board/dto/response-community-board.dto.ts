import { ApiString, ApiNumber, ApiOptionalString, ApiOptionalArray } from "../../../common/swagger/dto.decorator";
import { ObjectType, Field, Int } from '@nestjs/graphql';
import { Comment } from '../../comment/entities/comment.entity';
import { Expose } from "class-transformer";

@ObjectType()
export class ResponseCommunityBoardDto {
    @Expose()
    @ApiNumber(1)
    @Field(() => Int)
    id: number;

    @Expose()
    @ApiString('안녕하세요! 첫 번째 게시글입니다.')
    @Field()
    title: string;

    @Expose()
    @ApiString('이것은 게시글의 내용입니다.')
    @Field()
    content: string;

    @Expose()
    @ApiString('일반')
    @Field()
    category: string;

    @Expose()
    @ApiOptionalArray(['https://example.com/image1.jpg'])
    @Field(() => [String], { nullable: true })
    images?: string[];

    @Expose()
    @ApiNumber(1)
    @Field(() => Int)
    writerId: number;

    @Expose()
    @ApiString('조셉')
    @Field()
    writerName: string;

    @Expose()
    @ApiOptionalString('https://example.com/profile.jpg')
    @Field({ nullable: true })
    writerProfileImage?: string;

    @Expose()
    @ApiNumber(0)
    @Field(() => Int)
    viewCount: number;

    @Expose()
    @ApiNumber(0)
    @Field(() => Int)
    likeCount: number;

    @Expose()
    @ApiString('2024-01-01T00:00:00.000Z')
    @Field()
    createdAt: Date;

    @Expose()
    @ApiString('2024-01-01T00:00:00.000Z')
    @Field()
    updatedAt: Date;

    @Expose()
    @ApiOptionalArray([])
    @Field(() => [Comment], { nullable: true })
    comments?: Comment[];
}