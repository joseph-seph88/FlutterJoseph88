import * as fs from 'fs';
import { v4 as uuidv4 } from 'uuid';
import * as path from 'path';
import * as sharp from 'sharp';

export class ImageUtils {
    static createImageDir(): string {
        const saveDir = path.join(process.cwd(), 'uploads', 'images');
        if (!fs.existsSync(saveDir)) {
            fs.mkdirSync(saveDir, { recursive: true });
        }
        return saveDir;
    }

    static deleteImageDir(imageName: string) {
        if (imageName) {
            const filePath = path.join(__dirname, '../../../uploads/images', imageName);
            if (fs.existsSync(filePath)) {
                fs.unlinkSync(filePath);
            }
        }

    }

    static generateUniqueFilename(originalFileName: string, extension: string): string {
        const uuid = uuidv4();
        return `${uuid}.${extension}`;
    }

    static getSharpFormat(ext: string): 'jpg' | 'jpeg' | 'png' | 'webp' | 'heif' {
        switch (ext) {
            case '.png': return 'png';
            case '.webp': return 'webp';
            case '.heic': return 'heif';
            default: return 'jpeg';
        }
    }

    static generateFileUrl(fileName: string): string {
        return `http://${process.env.HOST || 'localhost'}:${process.env.PORT || 3000}/uploads/images/${fileName}`;
    }

    static async resizeImage(
        buffer: Buffer,
        outputPath: string,
    ): Promise<void> {
        await sharp(buffer)
            .rotate()
            .resize(1024, 1024, {
                fit: 'contain', withoutEnlargement: true,
                background: { r: 255, g: 255, b: 255, alpha: 0 }
            })
            .toFormat('png', { compressionLevel: 6 })
            .toFile(outputPath);
    }

    static async resizeImageToBuffer(
        buffer: Buffer,
    ): Promise<Buffer> {
        return await sharp(buffer)
            .rotate()
            .resize(1024, 1024, {
                fit: 'contain', withoutEnlargement: true,
                background: { r: 255, g: 255, b: 255, alpha: 0 }
            })
            .toFormat('png', { compressionLevel: 6 })
            .toBuffer();
    }

    static editPrompt() {
        return [
          "사진을 분석해서 가장 잘 어울릴 헤어스타일 1가지를 추천해줘(현실적으로!!).",
        ].join('\n');
      }
}