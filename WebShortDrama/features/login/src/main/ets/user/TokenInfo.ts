import { Logger } from "@agctemplate/utils";

const REFRESH_TIME_AHEAD = 10 * 60 * 1000;

const TAG = 'TokenInfo';

export class TokenInfo {
  accessToken: string;
  refreshToken: string;
  expireTime: string;

  constructor(tokenInfo?: any) {
    this.accessToken = tokenInfo.accessToken || '';
    this.refreshToken = tokenInfo.refreshToken || '';
    this.expireTime = tokenInfo.expireTime || '';
  }

  isValid(): boolean {
    return !!this.accessToken && !!this.expireTime && this.expireTime.length >= 13 && !Number.isNaN(this.expireTime);
  }

  isExpired(): boolean {
    try {

      if (Date.now() < Number(this.expireTime) - REFRESH_TIME_AHEAD) {
        return false;
      }
    } catch (e) {
      Logger.error(TAG, 'get isExpired failed');
    }
    return true;
  }
}