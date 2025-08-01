import { UserInfo } from '@agctemplate/common';
import { TokenInfo } from './TokenInfo';

export class UserInfoKeeper {
  private tokenInfo?: TokenInfo;
  private userInfo?: UserInfo;

  public updateUserInfo(userInfo: UserInfo): void {
    this.userInfo = userInfo;
  }

  public getUserInfo(): UserInfo | undefined {
    return this.userInfo;
  }

  public updateTokenInfo(tokenInfo: TokenInfo): void {
    this.tokenInfo = tokenInfo;
  }

  public getTokenInfo(): TokenInfo | undefined {
    return this.tokenInfo;
  }

  public clear(): void {
    this.tokenInfo = undefined;
    this.userInfo = undefined;
  }
}