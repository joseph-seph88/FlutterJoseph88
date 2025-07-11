// import { Type, Transform } from "class-transformer";
// import { IsNumber, IsOptional, IsString } from "class-validator";
// import { ApiArray, ApiNumber, ApiString } from "src/common/swagger/dto.decorator";

// export class ImageDto {
//     @ApiNumber(1)
//     @Type(() => Number)
//     @IsNumber()
//     userId: number;

//     @ApiNumber(1)
//     @Type(() => Number)
//     @IsNumber()
//     targetId: number;

//     @ApiString('게시판')
//     @IsString()
//     targetType: string;

//     @ApiArray([1, 2])
//     @IsOptional()
//     imageIds?: number[];
// }