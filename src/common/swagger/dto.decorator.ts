import { ApiProperty } from '@nestjs/swagger';

// 문자열 필드용 데코레이터
export const ApiString = (example: string, required = true) => {
    return ApiProperty({ example, required });
};

// 숫자 필드용 데코레이터
export const ApiNumber = (example: number, required = true) => {
    return ApiProperty({ example, required });
};

// 선택적 문자열 필드용 데코레이터
export const ApiOptionalString = (example: string) => {
    return ApiProperty({ example, required: false });
};

// 선택적 숫자 필드용 데코레이터
export const ApiOptionalNumber = (example: number) => {
    return ApiProperty({ example, required: false });
};

// 배열 필드용 데코레이터
export const ApiArray = (example: any[], type?: any, required = true) => {
    return ApiProperty({ example, type, required });
};

// 선택적 배열 필드용 데코레이터
export const ApiOptionalArray = (example: any[], type?: any) => {
    return ApiProperty({ example, type, required: false });
};

// 열거형 필드용 데코레이터
export const ApiEnum = (example: string, enumValues: string[], required = true) => {
    return ApiProperty({ example, enum: enumValues, required });
};

export const ApiObject = (example: object, required = true, description?: string) => {
    return ApiProperty({ example, required, description });
};