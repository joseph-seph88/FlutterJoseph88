import { Field, InputType, Int } from "@nestjs/graphql";
import { Type } from "class-transformer";
import { IsNumber, IsString } from "class-validator";
import { ApiNumber, ApiString } from "src/common/swagger/dto.decorator";

@InputType()
export class ImageDto {
    @ApiNumber(1)
    @Type(() => Number)
    @IsNumber()
    @Field(() => Int)
    userId: number;

    @ApiNumber(1)
    @Type(() => Number)
    @IsNumber()
    @Field(() => Int)
    targetId: number;

    @ApiString('게시판')
    @IsString()
    @Field()
    targetType: string;
}