import { Field, InputType, Int } from "@nestjs/graphql";
import { IsNumber, IsObject, IsString } from "class-validator";
import { ApiNumber, ApiObject, ApiString } from "src/common/swagger/dto.decorator";

@InputType()
export class ImageResponseDto {
    @ApiNumber(200)
    @IsNumber()
    @Field(() => Int)
    statusCode: number;

    @ApiString('요청이 성공적으로 처리되었습니다.')
    @IsString()
    @Field()
    message: string;

    @ApiObject({
        "id": 1,
        "userId": 1,
        "targetId": 1,
        "targetType": "게시판",
        "sortedNumber": 1,
        "fileName": "hashsaltfish.jpg",
        "originalName": "fish.jpg",
        "fileUrl": "http://localhost:3000/u/i/hashsaltfish.jpg",
        "createdAt": "2025-07-02",
    })
    @IsObject()
    data: {
        id: number;
        userId: number;
        targetId: number;
        targetType: string;
        fileName: string;
        originalFileName: string;
        fileUrl: string[];
        createdAt: string;
    };
}