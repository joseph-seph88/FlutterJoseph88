import { applyDecorators } from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiParam } from '@nestjs/swagger';

// 공통 응답 데코레이터
export const ApiCommonResponses = (summary: string, successStatus = 200, responseType?: any) => {
    return applyDecorators(
        ApiOperation({ summary }),
        ApiResponse({
            status: successStatus,
            description: '요청이 성공적으로 처리되었습니다.',
            type: responseType,
        }),
        ApiResponse({ status: 400, description: '잘못된 요청 데이터입니다.' }),
        ApiResponse({ status: 404, description: '리소스를 찾을 수 없습니다.' }),
        ApiResponse({ status: 500, description: '서버 내부 오류가 발생했습니다.' })
    );
};


// 생성 응답 데코레이터
export const ApiCreateResponse = (summary: string, responseType?: any) => {
    return applyDecorators(
        ApiOperation({ summary }),
        ApiResponse({
            status: 201,
            description: '리소스가 성공적으로 생성되었습니다.',
            type: responseType,
        }),
        ApiResponse({ status: 400, description: '잘못된 요청 데이터입니다.' }),
        ApiResponse({ status: 404, description: '리소스를 찾을 수 없습니다.' }),
        ApiResponse({ status: 500, description: '서버 내부 오류가 발생했습니다.' })
    );
};

// 조회 응답 데코레이터
export const ApiGetResponse = (summary: string, responseType?: any) => {
    return applyDecorators(
        ApiOperation({ summary }),
        ApiResponse({
            status: 200,
            description: '데이터를 성공적으로 조회했습니다.',
            type: responseType,
        }),
        ApiResponse({ status: 400, description: '잘못된 요청 데이터입니다.' }),
        ApiResponse({ status: 404, description: '리소스를 찾을 수 없습니다.' }),
        ApiResponse({ status: 500, description: '서버 내부 오류가 발생했습니다.' })
    );
};

// 수정 응답 데코레이터
export const ApiUpdateResponse = (summary: string, responseType?: any) => {
    return applyDecorators(
        ApiOperation({ summary }),
        ApiResponse({
            status: 200,
            description: '리소스가 성공적으로 수정되었습니다.',
            type: responseType,
        }),
        ApiResponse({ status: 400, description: '잘못된 요청 데이터입니다.' }),
        ApiResponse({ status: 404, description: '리소스를 찾을 수 없습니다.' }),
        ApiResponse({ status: 500, description: '서버 내부 오류가 발생했습니다.' })
    );
};

// 삭제 응답 데코레이터
export const ApiDeleteResponse = (summary: string) => {
    return applyDecorators(
        ApiOperation({ summary }),
        ApiResponse({ status: 204, description: '리소스가 성공적으로 삭제되었습니다.' }),
        ApiResponse({ status: 400, description: '잘못된 요청 데이터입니다.' }),
        ApiResponse({ status: 404, description: '리소스를 찾을 수 없습니다.' }),
        ApiResponse({ status: 500, description: '서버 내부 오류가 발생했습니다.' })
    );
};

// ID 파라미터 데코레이터
export const ApiIdParam = (name = 'id', description = '리소스 ID') => {
    return ApiParam({ name, description, example: 1 });
};

// 3개 파라미터 데코레이터
export const ApiThreeParam = (name1st, name2st, name3st, desc1st, desc2st, desc3st) => {
    return applyDecorators(
        ApiParam({ name: name1st, description: desc1st, example: 1 }),
        ApiParam({ name: name2st, description: desc2st, example: 1 }),
        ApiParam({ name: name3st, description: desc3st, example: "게시판" }),
    );
};