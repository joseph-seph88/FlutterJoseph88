import { PartialType } from '@nestjs/mapped-types';
import { CreateCommentDto } from '../../comment/dto/create-comment.dto';

export class UpdateCommentDto extends PartialType(CreateCommentDto) { }
