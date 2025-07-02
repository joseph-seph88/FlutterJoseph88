import { Controller, Post, UploadedFile, UseInterceptors, HttpCode, HttpStatus, Get, Query, Body } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiCreateResponse, ApiGetResponse } from '../../common/swagger/swagger.decorators';
import { ImageService } from './image.service';
import { createMemoryUploadConfig } from '../../config/multer.config';
import { ImageDto } from './dto/image.dto';

@Controller('image')
export class ImageController {
    constructor(private readonly imageService: ImageService) { }

    @Post('upload')
    @HttpCode(HttpStatus.CREATED)
    @ApiCreateResponse('이미지 업로드')
    @UseInterceptors(FileInterceptor('file', createMemoryUploadConfig()))
    async uploadImages(
        @UploadedFile() file: Express.Multer.File,
        @Body() imageDto: ImageDto
    ) {
        return await this.imageService.uploadImage(file, imageDto);
    }

    @Get('getUrl')
    @HttpCode(HttpStatus.OK)
    @ApiGetResponse('이미지 URL 조회')
    async getUrlImage(
        @Query('userId') userId: number,
        @Query('targetType') targetType: string,
        @Query('targetId') targetId: number) {
        return await this.imageService.getImage(userId, targetType, targetId);
    }


}




//     @Post('upload-memory')
//     @HttpCode(HttpStatus.CREATED)
//     @ApiCreateResponse('메모리에 이미지 업로드')
//     // @UseInterceptors(FileInterceptor('image', getSingleImageUploadInterceptorConfig()))
//     async uploadImageToMemory(@UploadedFile() file: Express.Multer.File) {
//         if (!file) {
//             return { error: 'No file uploaded' };
//         }

//         try {
//             // 메모리에서 이미지 처리
//             const imageInfo = await this.imageService.processImageFromMemory(file);

//             // 메타데이터 추출
//             const metadata = this.imageService.getImageMetadata(imageInfo);

//             // Base64 인코딩 (선택사항)
//             const base64Data = this.imageService.getImageAsBase64(imageInfo);

//             return {
//                 success: true,
//                 metadata,
//                 base64Data: base64Data.substring(0, 100) + '...', // 미리보기용
//                 message: '이미지가 메모리에 성공적으로 저장되었습니다.'
//             };
//         } catch (error) {
//             return {
//                 success: false,
//                 error: error.message
//             };
//         }
//     }

//     @Post('upload-memory-save')
//     @HttpCode(HttpStatus.CREATED)
//     @ApiCreateResponse('메모리에 업로드 후 파일로 저장')
//     // @UseInterceptors(FileInterceptor('image', getSingleImageUploadInterceptorConfig()))
//     async uploadImageToMemoryAndSave(@UploadedFile() file: Express.Multer.File) {
//         if (!file) {
//             return { error: 'No file uploaded' };
//         }

//         try {
//             // 메모리에서 이미지 처리
//             const imageInfo = await this.imageService.processImageFromMemory(file);

//             // 파일로 저장
//             const filename = await this.imageService.saveImageToFile(imageInfo);

//             // URL 생성
//             const url = this.imageService.getImageUrl(filename);

//             return {
//                 success: true,
//                 filename,
//                 url,
//                 metadata: this.imageService.getImageMetadata(imageInfo),
//                 message: '이미지가 메모리에 저장된 후 파일로 저장되었습니다.'
//             };
//         } catch (error) {
//             return {
//                 success: false,
//                 error: error.message
//             };
//         }
//     }

// }
