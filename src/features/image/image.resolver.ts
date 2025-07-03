import { Resolver, Query, Mutation, Args, Int } from '@nestjs/graphql';
import { ImageEntity } from './entities/image.entity';
import { ImageDto } from './dto/image.dto';
import { ImageService } from './image.service';
import { ImageResponseDto } from './dto/image-response.dto';
import { CommonResponse } from 'src/common/response-dto/common-response.dto';

@Resolver(() => ImageEntity)
export class ImageResolver {
    constructor(private readonly imageService: ImageService) { }

    @Mutation(() => CommonResponse)
    async uploadImage(
        @Args('file', { type: () => 'Upload' }) file: any,
        @Args('imageDto') imageDto: ImageDto
    ) {
        const { createReadStream, filename, mimetype } = await file;
        const stream = createReadStream();
        const chunks: Buffer[] = [];
        for await (const chunk of stream) {
            chunks.push(chunk as Buffer);
        }
        const buffer = Buffer.concat(chunks);
        const multerFile = {
            fieldname: 'file',
            originalname: filename,
            encoding: '7bit',
            mimetype,
            size: buffer.length,
            buffer,
            destination: '',
            filename,
            path: '',
            stream,
        } as unknown as Express.Multer.File;

        // 서비스 메서드가 배열을 기대하므로 단일 파일을 배열로 변환
        const files: Express.Multer.File[] = [multerFile];
        return await this.imageService.uploadImages(files, imageDto);
    }
}
