import { InputType, Field, Int } from '@nestjs/graphql';
import { IsOptional, IsString, IsInt, Length } from 'class-validator';
import { ApiOptionalString } from "../../../common/swagger/dto.decorator";

@InputType()
export class UpdateCommentDto {
    @IsOptional()
    @IsString()
    @Length(1, 1000, { message: '길이 제한 : 1000' })
    @ApiOptionalString('안녕하세요! 첫 번째 게시글입니다.')
    @Field({ nullable: true })
    content?: string;

    @IsOptional()
    @IsString()
    @ApiOptionalString('https://example.com/image1.jpg')
    @Field({ nullable: true })
    image?: string;
}
