import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable, tap } from 'rxjs';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    const { method, originalUrl } = request;
    const userId = user ? user.id : 'Anonymous';
    const logMessage = \`User \${userId} -> [\${method}] \${originalUrl}\`;
    console.log(logMessage);

    return next.handle().pipe(
      tap(() => console.log(\`Completed: \${logMessage}\`))
    );
  }
}
