import { Module } from '@nestjs/common';
import { ImageController } from './image.controller';
import { ImageService } from './image.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ImageEntity } from './entities/image.entity';
import { ImageResolver } from './image.resolver';

@Module({
    imports: [TypeOrmModule.forFeature([ImageEntity])],
    controllers: [ImageController],
    providers: [ImageService, ImageResolver],
})
export class ImageModule { }
