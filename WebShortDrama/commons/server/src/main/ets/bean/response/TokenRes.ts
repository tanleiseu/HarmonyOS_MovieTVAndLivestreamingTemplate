import { RetBean } from '../common/RetBean';

export class TokenRes {
  ret: RetBean;
  accessToken: string;
  refreshToken: string;
  expireTime: string;

  constructor(tokenRes?: TokenRes) {
    this.ret = new RetBean(tokenRes?.ret);
    this.accessToken = tokenRes?.accessToken || '';
    this.refreshToken = tokenRes?.refreshToken || '';
    this.expireTime = tokenRes?.expireTime || '';
  }
}
