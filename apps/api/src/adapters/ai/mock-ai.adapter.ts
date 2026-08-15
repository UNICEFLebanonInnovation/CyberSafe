import { Injectable } from '@nestjs/common';

@Injectable()
export class MockAiAdapter {
  async analyzeContent(content: string) {
    return {
      riskLevel: 'LOW_CONCERN',
      confidence: 'HIGH',
      summary: 'Mock analysis complete.',
    };
  }
}
