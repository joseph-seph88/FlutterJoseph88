import { Test, TestingModule } from '@nestjs/testing';
import { CommunityBoardService } from './community-board.service';

describe('CommunityBoardService', () => {
  let service: CommunityBoardService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [CommunityBoardService],
    }).compile();

    service = module.get<CommunityBoardService>(CommunityBoardService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
