import * as multer from 'multer';
import { v4 as uuidv4 } from 'uuid';
import * as path from 'path';

export const ALLOWED_IMAGE_MIME_TYPES = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/webp',
    'image/heif'
];
export const ALLOWED_IMAGE_EXTENSIONS = ['.jpg', '.jpeg', '.png', '.webp', '.heif'];

export const createMemoryStorage = () => multer.memoryStorage();
export const createMemoryUploadConfig = () => ({
    storage: createMemoryStorage(),
    limits: {
        fileSize: 5 * 1024 * 1024,
        files: 5,
    },
    fileFilter: imageFileFilter,
});


/// tools..
export const imageFileFilter = (req: Express.Request, file: Express.Multer.File, callback: (error: Error | null, acceptFile: boolean) => void) => {
    if (!file) {
        return callback(new Error('파일이 존재하지 않습니다.'), false);
    }

    const isValidMimeType = ALLOWED_IMAGE_MIME_TYPES.includes(file.mimetype.toLowerCase());
    const fileExtension = file.originalname.toLowerCase().substring(file.originalname.lastIndexOf('.'));
    const isValidExtension = ALLOWED_IMAGE_EXTENSIONS.includes(fileExtension);

    if (!isValidMimeType && !isValidExtension) {
        return callback(new Error(`지원하지 않는 파일 형식입니다. 허용된 형식: ${ALLOWED_IMAGE_EXTENSIONS.join(', ')}`), false);
    }

    callback(null, true);
};

export const generateUniqueFilename = (originalname: string): string => {
    const uuid = uuidv4();
    const extension = path.extname(originalname);
    return `${uuid}-${extension}`;
};

export function getSharpFormat(ext: string): 'jpg' | 'jpeg' | 'png' | 'webp' | 'heif' {
    switch (ext) {
        case '.png': return 'png';
        case '.webp': return 'webp';
        case '.heic': return 'heif';
        default: return 'jpeg';
    }
}



// export const createDiskStorage = () => multer.diskStorage({
//     destination: (req, file, cb) => {
//         cb(null, 'uploads/images/');
//     },
//     filename: (req, file, cb) => {
//         cb(null, generateUniqueFilename(file.originalname));
//     },
// });
// export const createDiskUploadConfig = () => ({
//     storage: createDiskStorage(),
//     limits: {
//         fileSize: 5 * 1024 * 1024,
//         files: 5,
//     },
// });

// /// for Midleware
// export const createSingleImageUploadConfig = (fieldName: string = 'image') => {
//     const config = {
//         ...createMemoryUploadConfig(),
//         fileFilter: imageFileFilter,
//     };
//     return multer(config).single(fieldName);
// };

// export const createMultipleImageUploadConfig = (fieldName: string = 'images', maxCount: number = 10) => {
//     const config = {
//         ...createMemoryUploadConfig(),
//         fileFilter: imageFileFilter,
//         limits: {
//             ...createMemoryUploadConfig().limits,
//             files: maxCount,
//         },
//     };
//     return multer(config).array(fieldName, maxCount);
// };

// /// for Interceptor
// export const getSingleImageUploadInterceptorConfig = () => ({
//     storage: createDiskStorage,
//     fileFilter: imageFileFilter,
//     limits: {
//         fileSize: 5 * 1024 * 1024,
//         files: 1,
//     },
// });

// export const getMultipleImageUploadInterceptorConfig = (maxCount: number = 10) => ({
//     storage: createDiskStorage,
//     fileFilter: imageFileFilter,
//     limits: {
//         fileSize: 5 * 1024 * 1024,
//         files: maxCount,
//     },
// });