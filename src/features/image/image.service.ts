import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ImageEntity } from './entities/image.entity';
import { Repository } from 'typeorm';
import * as sharp from 'sharp';
import * as path from 'path';
import { ImageDto } from './dto/image.dto';
import { CommonResponse } from 'src/common/response-dto/common-response.dto';
import * as fs from 'fs';
import { ResponseImageDto } from './dto/response_image.dto';
import { ImageUtils } from './\binternal/image.utils';


@Injectable()
export class ImageService {
    constructor(
        @InjectRepository(ImageEntity)
        private readonly imageRepository: Repository<ImageEntity>
    ) { }

    async uploadImages(files: Express.Multer.File[], imageDto: ImageDto): Promise<ResponseImageDto> {
        const results: ImageEntity[] = [];
        const imageUrls: string[] = [];
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
            imageUrls.push(fileUrl);
        }
        const firstImage = results[0];
        return {
            statusCode: 201,
            message: '리소스가 성공적으로 생성되었습니다.',
            // data: {
            id: firstImage.id,
            userId: firstImage.userId,
            targetId: firstImage.targetId,
            targetType: firstImage.targetType,
            fileName: firstImage.fileName,
            originalFileName: firstImage.originalFileName,
            fileUrl: imageUrls,
            createdAt: firstImage.createdAt.toISOString(),
            // }
        };
    }

    async getImages(userId: number, targetType: string, targetId: number): Promise<ResponseImageDto> {
        const images = await this.imageRepository.find({
            where: { userId, targetType, targetId },
            order: { createdAt: 'ASC' }
        });

        if (!images || images.length === 0) throw new NotFoundException('이미지를 찾을 수 없습니다.');
        const fileUrls = images.map(img => img.fileUrl);
        const firstImage = images[0];

        return {
            statusCode: 200,
            message: "요청이 성공적으로 처리되었습니다.",
            // data: {
            id: firstImage.id,
            userId: firstImage.userId,
            targetId: firstImage.targetId,
            targetType: firstImage.targetType,
            fileName: firstImage.fileName,
            originalFileName: firstImage.originalFileName,
            fileUrl: fileUrls,
            createdAt: firstImage.createdAt.toISOString(),
            // }
        }
    }

    async updateImages(files: Express.Multer.File[], imageDto: ImageDto): Promise<ResponseImageDto> {
        const results: ImageEntity[] = [];
        const imageUrls: string[] = [];
        const saveDir = ImageUtils.createImageDir();
        const userId = imageDto.userId;
        const targetId = imageDto.targetId;
        const targetType = imageDto.targetType;
        const imageIds = imageDto.imageIds ?? [];

        console.log(`이미지(id: ${imageIds});.`);

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
                userId,
                targetType,
                targetId,
                fileName: fileName,
                fileUrl: fileUrl,
                originalFileName: file.originalname,
            });
            const savedImage = await this.imageRepository.save(imageData);
            results.push(savedImage);
            imageUrls.push(fileUrl);
        }

        for (const imageId of imageIds) {
            const image = await this.imageRepository.findOne({ where: { id: imageId } });
            if (!image) {
                throw new NotFoundException(`이미지(id: ${imageIds})를 찾을 수 없습니다.`);
            }
            ImageUtils.deleteImageDir(image.fileName);
            await this.imageRepository.delete(imageId);
        }

        const firstImage = results[0];

        return {
            statusCode: 201,
            message: '리소스가 성공적으로 수정되었습니다.',
            // data: {
            id: firstImage.id,
            userId: firstImage.userId,
            targetId: firstImage.targetId,
            targetType: firstImage.targetType,
            fileName: firstImage.fileName,
            originalFileName: firstImage.originalFileName,
            fileUrl: imageUrls,
            createdAt: firstImage.createdAt.toISOString(),
            // }
        };
    }

    async deleteImages(imageIds: number[]): Promise<CommonResponse> {
        for (const id of imageIds) {
            const image = await this.imageRepository.findOne({ where: { id } });
            if (!image) {
                throw new NotFoundException(`이미지(id: ${id})를 찾을 수 없습니다.`);
            }
            ImageUtils.deleteImageDir(image.fileName);
            await this.imageRepository.delete(id);
        }
        return {
            statusCode: 204,
            message: '리소스가 성공적으로 삭제되었습니다.',
        }
    }
}
