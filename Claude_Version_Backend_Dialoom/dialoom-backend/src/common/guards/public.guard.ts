import { ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AuthGuard } from '@nestjs/passport';

export const IS_PUBLIC_KEY = 'isPublic';
export const Public = () => {
  return (target: any, key: string, descriptor: PropertyDescriptor) => {
    const reflector = new Reflector();
    reflector.defineMetadata(IS_PUBLIC_KEY, true, descriptor.value);
    return descriptor;
  };
};

@Injectable()
export class PublicGuard extends AuthGuard('jwt') {
  constructor(private reflector: Reflector) {
    super();
  }

  canActivate(context: ExecutionContext) {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    
    if (isPublic) {
      return true;
    }
    
    return super.canActivate(context);
  }
}
