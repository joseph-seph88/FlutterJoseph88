import { Controller, Post, Body, HttpCode, HttpStatus, UseInterceptors, UploadedFiles, UploadedFile } from '@nestjs/common';
import { HairService } from './hair.service';
import { ApiCreateResponse, ApiThreeParam } from 'src/common/swagger/swagger.decorators';
import { FileInterceptor, FilesInterceptor } from '@nestjs/platform-express';
import { HairRequestDto } from './dto/hair-request.dto';
import { HairResponseDto } from './dto/hair-response.dto';
import { createMemoryUploadConfig } from 'src/config/image-upload.config';

@Controller('hair')
export class HairController {
  constructor(private readonly hairService: HairService) { }

  @Post('manipulation-image')
  @ApiCreateResponse('이미지 업로드', HairResponseDto)
  @UseInterceptors(FilesInterceptor('files', 5, createMemoryUploadConfig()))
  async manipulationImages(
    @UploadedFiles() files: Express.Multer.File[],
    @Body() hairRequestDto: HairRequestDto,
  ): Promise<HairResponseDto> {
    return await this.hairService.manipulationImage(files, hairRequestDto);
  }

  @Post('recommand-image')
  @ApiCreateResponse('이미지 업로드')
  @UseInterceptors(FileInterceptor('file', createMemoryUploadConfig()))
  async recommandImages(
    @UploadedFile() file: Express.Multer.File,
    @Body() hairRequestDto: HairRequestDto,
  ): Promise<HairResponseDto> {
    return await this.hairService.recommandImage(file, hairRequestDto);
  }
}
