import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ImageEntity } from './entities/image.entity';
import { Repository } from 'typeorm';
import { ALLOWED_IMAGE_EXTENSIONS, ALLOWED_IMAGE_MIME_TYPES, generateUniqueFilename, getSharpFormat } from 'src/config/multer.config';
import { ResizeOptions } from 'sharp';
import * as sharp from 'sharp';
import * as multer from 'multer';
import * as fs from 'fs';
import * as path from 'path';
import { v4 as uuidv4 } from 'uuid';
import { ImageDto } from './dto/image.dto';


@Injectable()
export class ImageService {
    constructor(
        @InjectRepository(ImageEntity)
        private readonly imageRepository: Repository<ImageEntity>
    ) { }

    async uploadImage(file: Express.Multer.File, imageDto: ImageDto) {
        const saveDir = path.join(process.cwd(), 'uploads', 'images');
        if (!fs.existsSync(saveDir)) {
            fs.mkdirSync(saveDir, { recursive: true });
        }

        const fileName = generateUniqueFilename(file.originalname);
        const outputPath = path.join(saveDir, fileName);
        const ext = path.extname(file.originalname).toLowerCase();
        const format = getSharpFormat(ext);

        await sharp(file.buffer)
            .resize(300, 300, { fit: 'inside', withoutEnlargement: true })
            .toFormat(format, { quality: 80 })
            .toFile(outputPath);

        const fileUrl = `http://${process.env.HOST || 'localhost'}:${process.env.PORT || 3000}/uploads/images/${fileName}`;

        const imageData = this.imageRepository.create({
            ...imageDto,
            fileName: fileName,
            fileUrl: fileUrl,
            originalFileName: file.originalname,
        });

        const savedImage = await this.imageRepository.save(imageData);

        return {
            statusCode: 201,
            message: '이미지 업로드 완료',
            // data: {
            //     id: savedImage.id,
            //     fileName: savedImage.fileName,
            //     fileUrl: savedImage.fileUrl,
            //     originalName: file.originalname,
            //     mimeType: file.mimetype,
            //     size: file.size,
            //     createdAt: savedImage.createdAt
            // }
        };
    }

    async getImage(userId: number, targetType: string, targetId: number) {
        const image = await this.imageRepository.findOne({
            where: { userId, targetType, targetId },
        });

        if (!image) throw new NotFoundException('이미지를 찾을 수 없습니다.');


        return { url: image.fileUrl };
    }
}

// generateUniqueFilename = (originalname: string): string => {
//     const uuid = uuidv4();
//     const extension = path.extname(originalname);
//     return `${uuid}-${extension}`;
// };



// async saveImageToServer(file: Express.Multer.File, resizedBuffer: Buffer) {
//     const fileName = await this.saveImageToFile({ ...file, buffer: resizedBuffer });
//     // DB 저장
//     const image = this.imageRepository.create({
//         // userId, targetId, targetType 등 필요 정보
//         fileName,
//         filePath: 'uploads/images/', // 실제 경로
//         createdAt: new Date().toISOString(),
//     });


//     await this.imageRepository.save(image);

//     return { url: `http://${process.env.HOST || 'localhost'}:${process.env.PORT || 3000}/uploads/images/${fileName}` };

// }

// async saveImageToDB() { }




// const fileName = await this.saveImageToFile(file);





//     // 3. DB 저장
//     const image = this.imageRepository.create({
//         userId,
//         targetId,
//         targetType,
//         fileName,
//         filePath: 'uploads/images/', // 실제 경로에 맞게 조정
//         createdAt: new Date().toISOString(),
//     });
//     await this.imageRepository.save(image);
//     // 4. 결과 반환 (URL)
//     return { url: `http://${process.env.HOST || 'localhost'}:${process.env.PORT || 3000}/uploads/images/${fileName}` };
// }






//     async getImage(userId: number, targetType: string, targetId: number) {
//         const image = await this.imageRepository.findOne({
//             where: { userId, targetType, targetId },
//         });
//         if (!image) throw new NotFoundException('이미지를 찾을 수 없습니다.');
//         return { url: `http://${process.env.HOST || 'localhost'}:${process.env.PORT || 3000}/${image.filePath}${image.fileName}` };
//     }

//     // 메모리에 저장된 이미지를 파일로 저장
//     async saveImageToFile(file: Express.Multer.File, filename?: string): Promise<string> {
//         const fs = require('fs').promises;
//         const path = require('path');

//         const uploadDir = path.join(process.cwd(), 'uploads', 'images');

//         // 업로드 디렉토리가 없으면 생성
//         try {
//             await fs.access(uploadDir);
//         } catch {
//             await fs.mkdir(uploadDir, { recursive: true });
//         }

//         const finalFilename = filename || `${Date.now()}-${file.originalname}`;
//         const filePath = path.join(uploadDir, finalFilename);

//         await fs.writeFile(filePath, file.buffer);

//         return finalFilename;
//     }

//     // // 메모리에 저장된 이미지 처리
//     // async processImageFromMemory(file: Express.Multer.File): Promise<ImageFileInfo> {
//     //     const imageInfo = extractImageInfo(file);

//     //     // 여기서 이미지 처리를 할 수 있습니다 (리사이징, 압축 등)
//     //     // 예: 이미지 리사이징, 메타데이터 추출 등

//     //     return imageInfo;
//     // }

//     // // 메모리에 저장된 이미지를 파일로 저장
//     // async saveImageToFile(imageInfo: ImageFileInfo, filename?: string): Promise<string> {
//     //     const fs = require('fs').promises;
//     //     const path = require('path');

//     //     const uploadDir = path.join(process.cwd(), 'uploads', 'images');

//     //     // 업로드 디렉토리가 없으면 생성
//     //     try {
//     //         await fs.access(uploadDir);
//     //     } catch {
//     //         await fs.mkdir(uploadDir, { recursive: true });
//     //     }

//     //     const finalFilename = filename || `${Date.now()}-${imageInfo.originalname}`;
//     //     const filePath = path.join(uploadDir, finalFilename);

//     //     await fs.writeFile(filePath, imageInfo.buffer);

//     //     return finalFilename;
//     // }

//     // // 메모리에 저장된 이미지의 Base64 인코딩
//     // getImageAsBase64(imageInfo: ImageFileInfo): string {
//     //     return `data:${imageInfo.mimetype};base64,${imageInfo.buffer.toString('base64')}`;
//     // }

//     // // 이미지 버퍼에서 메타데이터 추출 (간단한 예시)
//     // getImageMetadata(imageInfo: ImageFileInfo) {
//     //     return {
//     //         filename: imageInfo.originalname,
//     //         size: imageInfo.size,
//     //         mimetype: imageInfo.mimetype,
//     //         uploadTime: new Date().toISOString(),
//     //     };
//     // }
// }
