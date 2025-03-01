import { Injectable } from '@nestjs/common';
import { RtcTokenBuilder, RtcRole } from 'agora-access-token';

@Injectable()
export class CallsService {
  generateToken(channel: string, uid: number) {
    const appId = process.env.AGORA_APP_ID;
    const appCert = process.env.AGORA_APP_CERT;
    if (!appId || !appCert) {
      throw new Error('Agora credentials missing');
    }
    const expirationInSeconds = 3600; // 1 hora
    const now = Math.floor(Date.now() / 1000);
    const privilegeExpiredTs = now + expirationInSeconds;
    const token = RtcTokenBuilder.buildTokenWithUid(
      appId,
      appCert,
      channel,
      uid,
      RtcRole.PUBLISHER,
      privilegeExpiredTs
    );
    return { token };
  }
}
