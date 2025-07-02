import { Field, InputType, Int } from "@nestjs/graphql";
import { Expose } from "class-transformer";
import { ArrayMaxSize, IsArray, IsNumber, IsObject, IsString } from "class-validator";
import { ApiArray, ApiNumber, ApiObject, ApiOptionalArray, ApiString } from "src/common/swagger/dto.decorator";

@InputType()
export class ImageResponseDto {
    @Expose()
    @Field(() => Int)
    @ApiNumber(200)
    @IsNumber()
    statusCode: number;

    @Expose()
    @Field()
    @ApiString('요청이 성공적으로 처리되었습니다.')
    @IsString()
    message: string;

    @ApiObject({
    })
    @IsObject()
    data: {
        id: number;
        userId: number;
        targetId: number;
        targetType: string;
        sortedNumber: number;
        fileName: string;
        fileUrl: string[];
        createdAt: string;
    };
}