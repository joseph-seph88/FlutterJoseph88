import { IsNumber, IsString } from "class-validator";
import { ApiNumber, ApiString } from "src/common/swagger/dto.decorator";

export class HairDataDto {
    @ApiNumber(1)
    @IsNumber()
    id: number;

    @ApiNumber(1)
    @IsNumber()
    userId: number;

    @ApiString('result.jpg')
    @IsString()
    resultImageName: string;

    @ApiString('http://example.com/result-image.jpg')
    @IsString()
    resultImageUrl: string;

    @ApiString('2025-01-01T00:00:00.000Z')
    @IsString()
    createdAt: string;
}