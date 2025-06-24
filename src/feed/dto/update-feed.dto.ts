/// 데이터 전송 객체(Data Transfer Object) 데이터의 유효성 검사 및 타입 정의
/// :: 피드 수정 시 필요한 데이터 구조

import { PartialType } from '@nestjs/mapped-types';
import { CreateFeedDto } from './create-feed.dto';

export class UpdateFeedDto extends PartialType(CreateFeedDto) { }
