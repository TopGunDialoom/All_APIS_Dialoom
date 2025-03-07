import { AuthGuard } from '@nestjs/passport';
import { Injectable } from '@nestjs/common';

@Injectable()
export class GoogleAuthGuard extends AuthGuard('google') {}

@Injectable()
export class FacebookAuthGuard extends AuthGuard('facebook') {}

@Injectable()
export class MicrosoftAuthGuard extends AuthGuard('microsoft') {}

@Injectable()
export class AppleAuthGuard extends AuthGuard('apple') {}
