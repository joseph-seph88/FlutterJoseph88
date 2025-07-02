import { Field, InputType, Int } from "@nestjs/graphql";
import { Expose } from "class-transformer";
import { ArrayMaxSize, IsOptional } from "class-validator";
import { ApiNumber, ApiOptionalArray, ApiString } from "src/common/swagger/dto.decorator";

@InputType()
export class ImageDto {
    @Expose()
    @ApiNumber(1)
    @Field(() => Int)
    userId: number;

    @Expose()
    @ApiNumber(1)
    @Field(() => Int)
    targetId: number;

    @Expose()
    @ApiString('게시판')
    @Field()
    targetType: string;

    @Expose()
    @ApiNumber(1)
    @Field(() => Int)
    sortedNumber: number;
}