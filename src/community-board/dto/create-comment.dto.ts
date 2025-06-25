import { IsOptional, IsString, IsInt, IsArray, Length } from "class-validator";

export class CreateCommentDto {
    @IsString()
    @Length(1, 1000, {
        message: "길이 제한 : 1000"
    })
    content: string;

    @IsInt()
    postId: number;

    @IsInt()
    writerId: number;

    @IsString()
    writerName: string;

    @IsOptional()
    @IsString()
    writerProfileImage?: string;

    @IsOptional()
    @IsArray()
    images?: string[];

    @IsOptional()
    @IsInt()
    parentCommentId?: number;
}
