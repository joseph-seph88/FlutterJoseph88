// import { IsNumber, IsObject, IsString } from "class-validator";
// import { ApiNumber, ApiObject, ApiString } from "src/common/swagger/dto.decorator";

// export class ResponseImageDto {
//     @ApiNumber(200)
//     @IsNumber()
//     statusCode: number;

//     @ApiString('요청이 성공적으로 처리되었습니다.')
//     @IsString()
//     message: string;

//     @ApiNumber(1)
//     @IsNumber()
//     id: number;

//     @ApiNumber(1)
//     @IsNumber()
//     userId: number;

//     @ApiNumber(1)
//     @IsNumber()
//     targetId: number;

//     @ApiString('게시판')
//     @IsString()
//     targetType: string;

//     @ApiString('DE-FE.jpg')
//     @IsString()
//     fileName: string;

//     @ApiString('hastDE-FE.jpg')
//     @IsString()
//     originalFileName: string;

//     @ApiString('http://hastDE-FE.jpg')
//     @IsString()
//     fileUrl: string[];

//     @ApiString('2025-01-01')
//     @IsString()
//     createdAt: string;
// }