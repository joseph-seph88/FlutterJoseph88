import { PartialType } from '@nestjs/mapped-types';
import { CreateCommunityBoardDto } from './create-community-board.dto';

export class UpdateCommunityBoardDto extends PartialType(CreateCommunityBoardDto) { }
