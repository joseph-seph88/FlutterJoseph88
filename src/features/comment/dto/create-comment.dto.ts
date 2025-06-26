import { IsOptional, IsString, IsInt, Length } from "class-validator";
import { ApiString, ApiNumber, ApiOptionalString, ApiOptionalNumber } from "../../../common/swagger/dto.decorator";

export class CreateCommentDto {
    @ApiString('정말 좋은 게시글이네요!')
    @IsString()
    @Length(1, 1000, {
        message: "길이 제한 : 1000"
    })
    content: string;

    @ApiNumber(1)
    @IsInt()
    postId: number;

    @ApiNumber(2)
    @IsInt()
    writerId: number;

    @ApiString('조셉')
    @IsString()
    writerName: string;

    @ApiOptionalString('https://example.com/profile.jpg')
    @IsOptional()
    @IsString()
    writerProfileImage?: string;

    @ApiOptionalString('https://example.com/comment-image.jpg')
    @IsOptional()
    @IsString()
    image?: string;

    @ApiOptionalNumber(5)
    @IsOptional()
    @IsInt()
    parentCommentId?: number;
}
