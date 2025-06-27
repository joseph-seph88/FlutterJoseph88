import { IsOptional, IsString, IsInt, IsArray, IsDateString, Length, ArrayMaxSize } from "class-validator";
import { CreateCommentDto } from "../../comment/dto/create-comment.dto";
import { ApiString, ApiNumber, ApiOptionalString, ApiOptionalArray, ApiEnum } from "../../../common/swagger/dto.decorator";
import { InputType, Field, Int } from '@nestjs/graphql';

@InputType()
export class CreateCommunityBoardDto {
    @ApiString('안녕하세요! 첫 번째 게시글입니다.')
    @IsString()
    @Length(1, 100, {
        message: "길이 제한 : 100"
    })
    @Field()
    title: string;

    @ApiString('이것은 게시글의 내용입니다.')
    @IsString()
    @Length(1, 10000, {
        message: "길이 제한 : 10000"
    })
    @Field()
    content: string;

    @ApiEnum('일반', ['일반', '질문', '정보', '후기'])
    @IsString()
    @Field()
    category: string;

    @ApiOptionalArray(['https://example.com/image1.jpg'])
    @IsOptional()
    @IsArray()
    @ArrayMaxSize(5, {
        message: "사이즈 제한 : 5"
    })
    @Field(() => [String], { nullable: true })
    images?: string[];

    @ApiNumber(1)
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

    @ApiOptionalArray([
        {
            content: "정말 좋은 게시글이네요!",
            postId: 1,
            writerId: 2,
            writerName: "조셉",
            writerProfileImage: "https://example.com/profile.jpg",
            parentCommentId: 5,
        }
    ], CreateCommentDto)
    @IsOptional()
    @IsArray()
    comments?: CreateCommentDto[];
}
