import { Controller, Post, UploadedFiles, UseInterceptors, HttpCode, HttpStatus, Get, Query, Body, Patch, Delete } from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { ApiCreateResponse, ApiDeleteResponse, ApiGetResponse, ApiIdParam, ApiThreeParam, ApiUpdateResponse } from '../../common/swagger/swagger.decorators';
import { ImageService } from './image.service';
import { ImageDto } from './dto/image.dto';
import { ImageResponseDto } from './dto/image-response.dto';
import { createMemoryUploadConfig } from './image-upload.config';
import { CommonResponse } from 'src/common/response-dto/common-response.dto';

@Controller('image')
export class ImageController {
    constructor(private readonly imageService: ImageService) { }

    @Post('uploadImages')
    @HttpCode(HttpStatus.CREATED)
    @ApiCreateResponse('이미지 업로드')
    @ApiThreeParam('userId', 'targetId', 'targetType', '유저 ID', '게시글/댓글 등의 ID', '게시글/댓글/피드 등')
    @UseInterceptors(FilesInterceptor('file', 10, createMemoryUploadConfig()))
    async uploadImages(
        @UploadedFiles() files: Express.Multer.File[],
        @Body() imageDto: ImageDto,
    ): Promise<ImageResponseDto> {
        return await this.imageService.uploadImages(files, imageDto);
    }

    @Get('getImages')
    @HttpCode(HttpStatus.OK)
    @ApiGetResponse('이미지 조회', ImageResponseDto)
    async getUrlImages(
        @Query('userId') userId: number,
        @Query('targetType') targetType: string,
        @Query('targetId') targetId: number,
    ): Promise<ImageResponseDto> {
        return await this.imageService.getImages(userId, targetType, targetId);
    }

    @Patch('updateImages')
    @HttpCode(HttpStatus.OK)
    @ApiUpdateResponse('이미지 수정', ImageResponseDto)
    @ApiThreeParam('userId', 'targetId', 'targetType', '유저 ID', '게시글/댓글 등의 ID', '게시글/댓글/피드 등')
    @UseInterceptors(FilesInterceptor('file', 10, createMemoryUploadConfig()))
    async updateImages(
        @UploadedFiles() files: Express.Multer.File[],
        @Body() imageDto: ImageDto,
    ): Promise<ImageResponseDto> {
        return await this.imageService.updateImages(files, imageDto);
    }

    @Delete('deleteImages')
    @HttpCode(HttpStatus.OK)
    @ApiDeleteResponse('이미지 삭제')
    @ApiIdParam('imageIds', '이미지 ID')
    async deleteImages(@Body() body: { imageIds: number[] },
    ): Promise<CommonResponse> {
        return await this.imageService.deleteImages(body.imageIds);
    }

}