import { IsOptional, IsString, IsInt, IsArray, Length, ArrayMaxSize } from "class-validator";
import { InputType, Field, Int } from '@nestjs/graphql';

@InputType()
export class UpdateCommunityBoardDto {
    @IsOptional()
    @IsString()
    @Length(1, 100, {
        message: "길이 제한 : 100"
    })
    @Field({ nullable: true })
    title?: string;

    @IsOptional()
    @IsString()
    @Length(1, 10000, {
        message: "길이 제한 : 10000"
    })
    @Field({ nullable: true })
    content?: string;

    @IsOptional()
    @IsString()
    @Field({ nullable: true })
    category?: string;

    @IsOptional()
    @IsArray()
    @ArrayMaxSize(5, {
        message: "사이즈 제한 : 5"
    })
    @Field(() => [String], { nullable: true })
    images?: string[];

}
