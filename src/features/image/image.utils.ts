import * as fs from 'fs';
import { v4 as uuidv4 } from 'uuid';
import * as path from 'path';

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
        return `${uuid}-${extension}`;
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
}