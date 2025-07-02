import { Field, InputType, Int } from "@nestjs/graphql";
import { Expose, Type } from "class-transformer";
import { ArrayMaxSize, IsOptional, IsNumber, IsString } from "class-validator";
import { ApiNumber, ApiOptionalArray, ApiString } from "src/common/swagger/dto.decorator";

@InputType()
export class ImageDto {
    @Expose()
    @ApiNumber(1)
    @Field(() => Int)
    @Type(() => Number)
    @IsNumber()
    userId: number;

    @Expose()
    @ApiNumber(1)
    @Field(() => Int)
    @Type(() => Number)
    @IsNumber()
    targetId: number;

    @Expose()
    @ApiString('게시판')
    @Field()
    @IsString()
    targetType: string;

    @Expose()
    @ApiNumber(1)
    @Field(() => Int)
    @Type(() => Number)
    @IsNumber()
    sortedNumber: number;
}