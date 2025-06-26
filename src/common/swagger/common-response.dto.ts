import { ApiProperty } from '@nestjs/swagger';

export class CommonResponseDto {
    @ApiProperty({ example: true })
    success: boolean;

    @ApiProperty({ example: '요청이 성공적으로 처리되었습니다.' })
    message: string;
}

export class ErrorResponseDto {
    @ApiProperty({ example: false })
    success: boolean;

    @ApiProperty({ example: '요청 처리 중 오류가 발생했습니다.' })
    message: string;

    @ApiProperty({ example: 'ERROR_CODE' })
    errorCode?: string;
}

export class PaginatedResponseDto<T> {
    @ApiProperty({ example: true })
    success: boolean;

    @ApiProperty({ example: '데이터를 성공적으로 조회했습니다.' })
    message: string;

    @ApiProperty()
    data: T[];

    @ApiProperty({ example: 1 })
    page: number;

    @ApiProperty({ example: 10 })
    limit: number;

    @ApiProperty({ example: 100 })
    total: number;
}