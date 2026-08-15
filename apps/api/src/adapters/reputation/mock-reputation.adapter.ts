import { Injectable } from '@nestjs/common';

@Injectable()
export class MockReputationAdapter {
  async checkUrl(url: string) {
    return {
      isMalicious: false,
      score: 0,
    };
  }
}
