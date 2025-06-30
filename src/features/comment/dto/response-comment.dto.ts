import { ApiString, ApiNumber, ApiOptionalNumber, ApiOptionalString, ApiOptionalArray } from "../../../common/swagger/dto.decorator";
import { ObjectType, Field, Int } from '@nestjs/graphql';
import { Comment } from '../../comment/entities/comment.entity';
import { Expose } from "class-transformer";

@ObjectType()
export class ResponseCommentDto {
    @Expose()
    @ApiNumber(1)
    @Field(() => Int)
    id: number;

    @Expose()
    @ApiString('이것은 댓글입니다.')
    @Field()
    content: string;

    @Expose()
    @ApiNumber(1)
    @Field(() => Int)
    postId: number;

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
    @ApiOptionalString('https://example.com/profile.jpg')
    @Field({ nullable: true })
    image?: string;

    @Expose()
    @ApiOptionalNumber(1)
    @Field(() => Int)
    parentCommentId?: number;

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
    replies?: Comment[];
}