import { Controller, Post, UploadedFiles, UseInterceptors, HttpCode, HttpStatus, Get, Query, Body } from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { ApiCreateResponse, ApiGetResponse } from '../../common/swagger/swagger.decorators';
import { ImageService } from './image.service';
import { ImageDto } from './dto/image.dto';
import { ImageResponseDto } from './dto/image-response.dto';
import { createMemoryUploadConfig } from './image-upload.config';

@Controller('image')
export class ImageController {
    constructor(private readonly imageService: ImageService) { }

    @Post('upload')
    @HttpCode(HttpStatus.CREATED)
    @ApiCreateResponse('이미지 업로드')
    @UseInterceptors(FilesInterceptor('file', 10, createMemoryUploadConfig()))
    async uploadImage(
        @UploadedFiles() files: Express.Multer.File[],
        @Body() imageDto: ImageDto,
    ) {
        return await this.imageService.uploadImages(files, imageDto);
    }

    @Get('getUrl')
    @HttpCode(HttpStatus.OK)
    @ApiGetResponse('이미지 URL 조회')
    async getUrlImage(
        @Query('userId') userId: number,
        @Query('targetType') targetType: string,
        @Query('targetId') targetId: number,
    ): Promise<ImageResponseDto> {
        return await this.imageService.getImages(userId, targetType, targetId);
    }
}