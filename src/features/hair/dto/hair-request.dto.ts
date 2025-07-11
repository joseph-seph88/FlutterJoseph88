import { Type } from "class-transformer";
import { IsArray, IsNumber } from "class-validator";
import { ApiArray, ApiNumber } from "src/common/swagger/dto.decorator";

export class HairRequestDto {
    @ApiNumber(1)
    @Type(() => Number)
    @IsNumber()
    userId: number;

    // @ApiArray([1, 2], [Number])
    // @IsArray()
    // imageIds: number[];

    @ApiNumber(1)
    @Type(() => Number)
    @IsNumber()
    colorId: number;
}
