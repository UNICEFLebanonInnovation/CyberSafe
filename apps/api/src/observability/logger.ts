import { ConsoleLogger, Injectable, Scope } from '@nestjs/common';

@Injectable({ scope: Scope.TRANSIENT })
export class AppLogger extends ConsoleLogger {
  customLog(message: string, context?: string) {
    // Basic mock implementation for structured logging logic
    this.log(JSON.stringify({ message, context, timestamp: new Date().toISOString() }));
  }
}
