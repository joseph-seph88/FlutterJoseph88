import { BadRequestException, Injectable } from '@nestjs/common';
import { HairRequestDto } from './dto/hair-request.dto';
import { ImageUtils } from 'src/common/utils/image.utils';
import * as path from 'path';
import * as fs from 'fs';
import * as FormData from 'form-data';
import axios from 'axios';
import { HairResponseDto } from './dto/hair-response.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Hair } from './entities/hair.entity';
import { Repository } from 'typeorm';
import OpenAI, { toFile } from "openai";
import { ConfigService } from '@nestjs/config';


@Injectable()
export class HairService {
  private openai: OpenAI;

  constructor(
    private configService: ConfigService,
    @InjectRepository(Hair)
    private readonly hairRepository: Repository<Hair>
  ) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('OPENAI_API_KEY'),
      organization: this.configService.get<string>('ORGANIZATION_ID'),
    });
  }

  async recommandImage(file: Express.Multer.File, hairRequestDto: HairRequestDto): Promise<HairResponseDto> {
    if (!file) {
      throw new BadRequestException('file이 서버로 전달되지 않았습니다. 필드명과 전송방식을 확인하세요.');
    }
    const colorId = hairRequestDto.colorId;
    const userId = hairRequestDto.userId;
    const [userImagePath, userImageName] = await this.resizeAndSaveImagesWithRecommand(file);
    const b64Image = await this.sendToAiServerWithRecommand(userImagePath, userImageName);

    const resultImageName = ImageUtils.generateUniqueFilename('result-image', 'png');
    const resultImagePath = path.join(ImageUtils.createImageDir(), resultImageName);
    fs.writeFileSync(resultImagePath, Buffer.from(b64Image, 'base64'));

    const resultImageUrl = `http://localhost:3000/uploads/images/${resultImageName}`;
    const saved = await this.saveHairResultWithRecommand(userId, {
      resultImageName,
      resultImageUrl,
    });

    // const testResult = {
    //   resultImageName: '카리나',
    //   resultImageUrl: 'http://localhost:3000/uploads/images/k-1.png',
    // }
    // const saved = await this.saveHairResultWithRecommand(userId, testResult);

    return this.makeResponseWithRecommand(saved);
  }



  async manipulationImage(files: Express.Multer.File[], hairRequestDto: HairRequestDto): Promise<HairResponseDto> {
    if (!files || files.length < 2) {
      throw new BadRequestException('files가 서버로 전달되지 않았거나 2개 미만입니다. 필드명과 전송방식을 확인하세요.');
    }
    const colorId = hairRequestDto.colorId;
    const userId = hairRequestDto.userId;
    const [userImagePath, otherImagePath, userImageName, otherImageName] = await this.resizeAndSaveImages(files);
    // const aiResult = await this.sendToAiServer(userImagePath, otherImagePath, String(colorId), userImageName, otherImageName);
    const testResult = {
      resultImageName: '임우일',
      resultImageUrl: 'http://localhost:3000/uploads/images/k-123.png',
    }

    const saved = await this.saveHairResult(userId, testResult);
    return this.makeResponse(saved);
  }

  private async resizeAndSaveImages(files: Express.Multer.File[]): Promise<[string, string, string, string]> {
    const userFile = files[0];
    const otherFile = files[1];
    const userImageName = ImageUtils.generateUniqueFilename(userFile.originalname, 'png');
    const otherImageName = ImageUtils.generateUniqueFilename(otherFile.originalname, 'png');
    const userImagePath = path.join(ImageUtils.createImageDir(), userImageName);
    const otherImagePath = path.join(ImageUtils.createImageDir(), otherImageName);
    await ImageUtils.resizeImage(userFile.buffer, userImagePath);
    await ImageUtils.resizeImage(otherFile.buffer, otherImagePath);
    return [userImagePath, otherImagePath, userImageName, otherImageName];
  }

  // private async sendToAiServer(userImagePath: string, otherImagePath: string, colorId: string, userImageName: string, otherImageName: string): Promise<any> {
  //   const form = new FormData();
  //   form.append('userImage', fs.createReadStream(userImagePath), userImageName);
  //   form.append('otherImage', fs.createReadStream(otherImagePath), otherImageName);
  //   form.append('colorId', colorId);
  //   const response = await axios.post(
  //     `http://${process.env.AI_SERVER_IP}:${process.env.AI_SERVER_PORT}/upload`,
  //     form,
  //     { headers: form.getHeaders() }
  //   );
  //   if (!response.data) {
  //     throw new BadRequestException('AI 서버로부터 유효한 응답을 받지 못했습니다.');
  //   }
  //   return response.data;
  // }

  private async saveHairResult(userId: number, aiResult: any): Promise<Hair> {
    const imageData = this.hairRepository.create({
      userId: userId,
      resultImageName: aiResult.resultImageName || '',
      resultImageUrl: aiResult.resultImageUrl || '',
    });
    return await this.hairRepository.save(imageData);
  }

  private makeResponse(saved: Hair): HairResponseDto {
    return {
      statusCode: 201,
      message: '요청이 성공적으로 처리되었습니다.',
      data: {
        id: saved.id,
        userId: saved.userId,
        resultImageName: saved.resultImageName || '',
        resultImageUrl: saved.resultImageUrl || '',
        createdAt: saved.createdAt ? saved.createdAt.toISOString() : '',
      }
    };
  }

  private async resizeAndSaveImagesWithRecommand(file: Express.Multer.File): Promise<[string, string]> {
    const userImageName = ImageUtils.generateUniqueFilename(file.originalname, 'png');
    const userImagePath = path.join(ImageUtils.createImageDir(), userImageName);
    await ImageUtils.resizeImage(file.buffer, userImagePath);
    return [userImagePath, userImageName];
  }

  private async sendToAiServerWithRecommand(userImagePath: string, userImageName: string): Promise<any> {
    const prompt = ImageUtils.editPrompt();
    const image = await toFile(fs.createReadStream(userImagePath), null, { type: 'image/png' });
    const response = await this.openai.images.edit({
      model: 'gpt-image-1',
      image: [image],
      prompt,
      n: 1,
    });

    if (!response.data || !response.data[0]?.b64_json) {
      throw new Error('OpenAI 응답에 이미지 데이터가 없습니다.');
    }
    return response.data[0].b64_json;
  }

  private async saveHairResultWithRecommand(userId: number, aiResult: any): Promise<Hair> {
    const imageData = this.hairRepository.create({
      userId: userId,
      resultImageName: aiResult.resultImageName || '',
      resultImageUrl: aiResult.resultImageUrl || '',
    });
    return await this.hairRepository.save(imageData);
  }

  private makeResponseWithRecommand(saved: Hair): HairResponseDto {
    return {
      statusCode: 201,
      message: '요청이 성공적으로 처리되었습니다.',
      data: {
        id: saved.id,
        userId: saved.userId,
        resultImageName: saved.resultImageName || '',
        resultImageUrl: saved.resultImageUrl || '',
        createdAt: saved.createdAt ? saved.createdAt.toISOString() : '',
      }
    };
  }
}
