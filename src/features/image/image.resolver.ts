import { Resolver, Query, Mutation, Args, Int } from '@nestjs/graphql';
import { ImageEntity } from './entities/image.entity';
import { ImageDto } from './dto/image.dto';
import { BasicResponse } from 'src/common/response-dto/basic-response.dto';
import { ImageService } from './image.service';

interface FileUpload {
    filename: string;
    mimetype: string;
    encoding: string;
    createReadStream: () => NodeJS.ReadableStream;
}

@Resolver(() => ImageEntity)
export class ImageResolver {
    constructor(private readonly imageService: ImageService) { }

    @Mutation(() => BasicResponse)
    async uploadImage(
        @Args('file', { type: () => 'Upload' }) file: Promise<FileUpload>,
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
        return await this.imageService.uploadImage(multerFile, imageDto);
    }
}
