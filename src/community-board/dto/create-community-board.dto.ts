import { IsOptional, IsString, IsInt, IsArray, IsDateString, Length, ArrayMaxSize } from "class-validator";
import { CreateCommentDto } from "./create-comment.dto";

export class CreateCommunityBoardDto {
    @IsString()
    @Length(1, 100, {
        message: "길이 제한 : 100"
    })
    title: string;

    @IsString()
    @Length(1, 10000, {
        message: "길이 제한 : 10000"
    })
    content: string;

    @IsString()
    category: string;

    @IsOptional()
    @IsArray()
    @ArrayMaxSize(5, {
        message: "사이즈 제한 : 5"
    })
    images?: string[];

    @IsInt()
    writerId: number;

    @IsString()
    writerName: string;

    @IsOptional()
    @IsString()
    writerProfileImage?: string;

    @IsOptional()
    @IsArray()
    comments?: CreateCommentDto[];
}
