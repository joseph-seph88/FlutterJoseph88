import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ImageEntity } from './entities/image.entity';
import { Repository } from 'typeorm';
import * as sharp from 'sharp';
import * as path from 'path';
import { ImageDto } from './dto/image.dto';
import { ImageResponseDto } from './dto/image-response.dto';
import { ImageUtils } from './image.utils';


@Injectable()
export class ImageService {
    constructor(
        @InjectRepository(ImageEntity)
        private readonly imageRepository: Repository<ImageEntity>
    ) { }

    async uploadImages(files: Express.Multer.File[], imageDto: ImageDto) {
        const results: ImageEntity[] = [];
        const saveDir = ImageUtils.createImageDir();

        for (const file of files) {
            const extension = path.extname(file.originalname).toLowerCase();
            const fileName = ImageUtils.generateUniqueFilename(file.originalname, extension);
            const outputPath = path.join(saveDir, fileName);
            const format = ImageUtils.getSharpFormat(extension);
            const fileUrl = ImageUtils.generateFileUrl(fileName);

            await sharp(file.buffer)
                .rotate()
                .resize(300, 300, { fit: 'inside', withoutEnlargement: true })
                .toFormat(format, { quality: 80 })
                .toFile(outputPath);

            const imageData = this.imageRepository.create({
                ...imageDto,
                fileName: fileName,
                fileUrl: fileUrl,
                originalFileName: file.originalname,
            });
            const savedImage = await this.imageRepository.save(imageData);
            results.push(savedImage);
        }
        return {
            statusCode: 201,
            message: '리소스가 성공적으로 생성되었습니다.',
        }
    }

    async getImages(userId: number, targetType: string, targetId: number): Promise<ImageResponseDto> {
        const images = await this.imageRepository.find({
            where: { userId, targetType, targetId },
            order: { createdAt: 'ASC' }
        });

        if (!images || images.length === 0) throw new NotFoundException('이미지를 찾을 수 없습니다.');
        const fileUrls = images.map(img => img.fileUrl);

        return {
            statusCode: 200,
            message: "요청이 성공적으로 처리되었습니다.",
            data: {
                id: images[0].id,
                userId: images[0].userId,
                targetId: images[0].targetId,
                targetType: images[0].targetType,
                fileName: images[0].fileName,
                originalFileName: images[0].originalFileName,
                fileUrl: fileUrls,
                createdAt: images[0].createdAt.toISOString(),
            }
        }
    }
}
