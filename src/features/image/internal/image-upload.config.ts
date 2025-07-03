import * as multer from 'multer';

export const ALLOWED_IMAGE_MIME_TYPES = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/webp',
    'image/heif'
];
export const ALLOWED_IMAGE_EXTENSIONS = ['.jpg', '.jpeg', '.png', '.webp', '.heif'];

export const createMemoryStorage = () => multer.memoryStorage();

export const imageFileFilter = (
    req: Express.Request,
    file: Express.Multer.File,
    callback: (error: Error | null, acceptFile: boolean) => void
) => {
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

export const createMemoryUploadConfig = () => ({
    storage: createMemoryStorage(),
    limits: {
        fileSize: 5 * 1024 * 1024,
        files: 10,
    },
    fileFilter: imageFileFilter,
});