import { IsNumber, IsObject, IsString } from "class-validator";
import { ApiNumber, ApiObject, ApiString } from "src/common/swagger/dto.decorator";
import { HairDataDto } from "./hair-data.dto";

export class HairResponseDto {
    @ApiNumber(200)
    @IsNumber()
    statusCode: number;

    @ApiString('요청이 성공적으로 처리되었습니다.')
    @IsString()
    message: string;

    @ApiObject(HairDataDto)
    @IsObject()
    data: HairDataDto;
}
