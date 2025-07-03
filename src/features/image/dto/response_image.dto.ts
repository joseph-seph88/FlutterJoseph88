import { Field, Int, ObjectType } from "@nestjs/graphql";
import { IsNumber, IsObject, IsString } from "class-validator";
import { ApiNumber, ApiObject, ApiString } from "src/common/swagger/dto.decorator";

@ObjectType()
export class ResponseImageDto {
    @ApiNumber(200)
    @IsNumber()
    @Field(() => Int)
    statusCode: number;

    @ApiString('요청이 성공적으로 처리되었습니다.')
    @IsString()
    @Field()
    message: string;

    @ApiNumber(1)
    @IsNumber()
    @Field(() => Int)
    id: number;

    @ApiNumber(1)
    @IsNumber()
    @Field(() => Int)
    userId: number;

    @ApiNumber(1)
    @IsNumber()
    @Field(() => Int)
    targetId: number;

    @ApiString('게시판')
    @IsString()
    @Field()
    targetType: string;

    @ApiString('DE-FE.jpg')
    @IsString()
    @Field()
    fileName: string;

    @ApiString('hastDE-FE.jpg')
    @IsString()
    @Field()
    originalFileName: string;

    @ApiString('http://hastDE-FE.jpg')
    @IsString()
    @Field(() => [String])
    fileUrl: string[];

    @ApiString('2025-01-01')
    @IsString()
    @Field()
    createdAt: string;

    // @ApiObject({
    //     "id": 1,
    //     "userId": 1,
    //     "targetId": 1,
    //     "targetType": "게시판",
    //     "fileName": "hashsaltfish.jpg",
    //     "originalName": "fish.jpg",
    //     "fileUrl": ["http://localhost:3000/u/i/hashsaltfish.jpg"],
    //     "createdAt": "2025-07-02",
    // })
    // @IsObject()
    // @Field(() => [ResponseImageDto])
    // data: {
    //     id: number;
    //     userId: number;
    //     targetId: number;
    //     targetType: string;
    //     fileName: string;
    //     originalFileName: string;
    //     fileUrl: string[];
    //     createdAt: string;
    // };
}