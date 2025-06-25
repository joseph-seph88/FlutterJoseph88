import { Test, TestingModule } from '@nestjs/testing';
import { CommunityBoardController } from './community-board.controller';
import { CommunityBoardService } from './community-board.service';

describe('CommunityBoardController', () => {
  let controller: CommunityBoardController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [CommunityBoardController],
      providers: [CommunityBoardService],
    }).compile();

    controller = module.get<CommunityBoardController>(CommunityBoardController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
