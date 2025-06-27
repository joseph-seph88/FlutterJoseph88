import { InputType, Field, Int } from '@nestjs/graphql';
import { IsOptional, IsString, IsInt, Length } from 'class-validator';

@InputType()
export class UpdateCommentDto {
    @IsOptional()
    @IsString()
    @Length(1, 1000, { message: '길이 제한 : 1000' })
    @Field({ nullable: true })
    content?: string;

    @IsOptional()
    @IsString()
    @Field({ nullable: true })
    image?: string;
}
