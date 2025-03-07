import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from '@nestjs/common';
import { Observable } from 'rxjs';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const userId = request.user?.id || 'anonymous';
    const method = request.method;
    const originalUrl = request.url;

    const logMessage = `User ${userId} -> [${method}] ${originalUrl}`;
    console.log(logMessage);

    return next.handle();
  }
}
