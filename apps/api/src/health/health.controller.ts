import { Controller, Get } from '@nestjs/common';

@Controller('health')
export class HealthController {
  @Get('live')
  checkLive() {
    return { status: 'up' };
  }

  @Get('ready')
  checkReady() {
    return { status: 'up' };
  }
}
