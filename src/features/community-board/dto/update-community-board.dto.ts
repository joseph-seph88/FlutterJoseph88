import { IsOptional, IsString, IsInt, IsArray, Length, ArrayMaxSize } from "class-validator";
import { InputType, Field, Int } from '@nestjs/graphql';
import { ApiString, ApiNumber, ApiOptionalString, ApiOptionalArray, ApiEnum } from "../../../common/swagger/dto.decorator";

@InputType()
export class UpdateCommunityBoardDto {
    @IsString()
    @Length(1, 100, {
        message: "길이 제한 : 100"
    })
    @ApiString('안녕하세요! 첫 번째 게시글입니다.')
    @Field({ nullable: true })
    title: string;

    @IsString()
    @ApiString('이것은 게시글의 내용입니다.')
    @Length(1, 10000, {
        message: "길이 제한 : 10000"
    })
    @Field({ nullable: true })
    content: string;

    @IsString()
    @ApiEnum('일반', ['일반', '질문', '정보', '후기'])
    @Field({ nullable: true })
    category: string;

    @IsOptional()
    @IsArray()
    @ArrayMaxSize(5, {
        message: "사이즈 제한 : 5"
    })
    @ApiOptionalArray(['https://example.com/image1.jpg'])
    @Field(() => [String], { nullable: true })
    images?: string[];

}
