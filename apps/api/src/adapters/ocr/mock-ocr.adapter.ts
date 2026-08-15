import { Injectable } from '@nestjs/common';

@Injectable()
export class MockOcrAdapter {
  async extractText(imageUrl: string) {
    return "Mock extracted text from image";
  }
}
