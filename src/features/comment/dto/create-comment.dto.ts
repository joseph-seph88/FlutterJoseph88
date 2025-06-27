import { IsOptional, IsString, IsInt, Length } from "class-validator";
import { ApiString, ApiNumber, ApiOptionalString, ApiOptionalNumber } from "../../../common/swagger/dto.decorator";
import { InputType, Field, Int } from '@nestjs/graphql';

@InputType()
export class CreateCommentDto {
    @ApiString('정말 좋은 게시글이네요!')
    @IsString()
    @Length(1, 1000, {
        message: "길이 제한 : 1000"
    })
    @Field()
    content: string;

    @ApiNumber(1)
    @IsInt()
    @Field(() => Int)
    postId: number;

    @ApiNumber(2)
    @IsInt()
    @Field(() => Int)
    writerId: number;

    @ApiString('조셉')
    @IsString()
    @Field()
    writerName: string;

    @ApiOptionalString('https://example.com/profile.jpg')
    @IsOptional()
    @IsString()
    @Field({ nullable: true })
    writerProfileImage?: string;

    @ApiOptionalString('https://example.com/comment-image.jpg')
    @IsOptional()
    @IsString()
    @Field({ nullable: true })
    image?: string;

    @ApiOptionalNumber(5)
    @IsOptional()
    @IsInt()
    @Field(() => Int, { nullable: true })
    parentCommentId?: number;
}
