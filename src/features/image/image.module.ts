import { Module } from '@nestjs/common';
import { MulterModule } from '@nestjs/platform-express';
import { ImageController } from './image.controller';
import { ImageService } from './image.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ImageEntity } from './entities/image.entity';

@Module({
    imports: [TypeOrmModule.forFeature([ImageEntity])],
    controllers: [ImageController],
    providers: [ImageService],
})
export class ImageModule { }
