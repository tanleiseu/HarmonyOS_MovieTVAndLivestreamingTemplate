import { loginInterceptor } from './chain/LoginInterceptor';
import { LoginAPI, AppNotice, UserInfo } from '@agctemplate/common';
import { container, EventHubUtil, GlobalContext, Logger } from '@agctemplate/utils';
import { HmsAccountSdkWrapper } from './HmsAccountSdkWrapper';
import { UserInfoKeeper } from './user/UserInfoKeeper';
import { RequestAPI } from "@agctemplate/server";
import { TokenInfo } from './user/TokenInfo';

const accountConstants = {
  UID: 'uid',
  OPENID: 'openid',
  QUICK_LOGIN_ANONYMOUS_PHONE: 'quickLoginAnonymousPhone',
  PROFILE: 'profile',
  COUNTRY: 'country',
  SERVICE_AUTH_CODE: 'serviceauthcode',
  USER_NAME: 'userName', // 用户名
  EMAIL: 'email', // 邮箱
  REALNAME_STATE: 'https://www.huawei.com/auth/account/realname/state', // 实名认证状态
  IDENTITY: 'identity', // 证件号和姓名
  CTF_TYPE: 'https://www.huawei.com/auth/account/realname/ctf.type' // 实名证件类型和认证类型
};
const TAG = 'LoginManager';

export class LoginManager implements LoginAPI {
  private userInfoKeeper: UserInfoKeeper = new UserInfoKeeper();

  public getAccessToken(): string | undefined {
    return this.userLogined() ? this.userInfoKeeper.getTokenInfo()?.accessToken : undefined;
  }

  // 是否存在用户已登录
  public userLogined(): boolean {
    return this.userInfoKeeper.getTokenInfo()?.isValid() ? true : false;
  }

  // 登录，已登录则不检查协议发送广播等
  public async login(): Promise<boolean> {
    Logger.info(TAG, `login start`);
    if (await this.checkLoginStatus()) {
      Logger.info(TAG, `user already login`);
      return true;
    }
    let loginRes = await this.doRealLogin();
    if (!loginRes) {
      await this.logout();
    }
    return loginRes;
  }

  // 登录，不论有无登录，都会走一遍协议检查和广播通知等
  @loginInterceptor
  public async doRealLogin(): Promise<boolean> {
    // 如果已登录
    if (await this.checkLoginStatus()) {
      Logger.info(TAG, `user already login`);
      return Promise.resolve(true);
    }
    if (await this.requestUserInfo()) {
      return Promise.resolve(true);
    }
    Logger.info(TAG, 'login failed');
    return Promise.resolve(false);
  }

  public getUserInfo(): UserInfo | undefined {
    return this.userInfoKeeper.getUserInfo();
  }

  /**
   * 检查用户token是否有效（支持强制刷新token）
   */
  public async checkLoginStatus(): Promise<boolean> {
    let tokenInfo = this.userInfoKeeper.getTokenInfo();
    if (tokenInfo?.isValid()) {
      if (!tokenInfo.isExpired()) {
        return true;
      }
    }
    return await this.refreshToken();
  }

  /**
   * 主动刷新token（支持强制刷新token）
   */
  public async refreshToken(force?: boolean): Promise<boolean> {
    Logger.info(TAG, `refreshToken start`);
    return false;
  }

  /**
   * 退出登录
   */
  public async logout(): Promise<void> {
    Logger.info(TAG, `user logout`);
    this.userInfoKeeper.clear();
    // 发送登出通知
    EventHubUtil.emit(GlobalContext.getContext(), AppNotice.LOGOUT);
  }

  private async requestUserInfo(): Promise<boolean> {
    let authorizationCode = await this.getAuthorizationCode();
    if (authorizationCode) {
      let token = await container.resolve(RequestAPI).getAccessToken({
        authorizeCode: authorizationCode
      });
      if (token.getBody()) {
        this.userInfoKeeper.updateTokenInfo(new TokenInfo(token.getBody()));
        this.userInfoKeeper.updateUserInfo(new UserInfo((await container.resolve(RequestAPI).userInfo()).getBody()));
        return true;
      }
    }
    return false;
  }

  private async getAuthorizationCode(): Promise<string | undefined> {
    Logger.info(TAG, 'hw account silentSignIn start');
    // 调用华为账号服务显示登录
    let hmsSignInState = await HmsAccountSdkWrapper.getInstance().silentSignIn();
    if (!hmsSignInState) {
      Logger.info(TAG, 'hw account displayLogin start');
      // 进行手动登录
      hmsSignInState = await HmsAccountSdkWrapper.getInstance().displaySignIn();
    }
    if (hmsSignInState) {
      let hmsAuthRes = await HmsAccountSdkWrapper.getInstance().accountAuthorization([],
        [accountConstants.SERVICE_AUTH_CODE, accountConstants.UID], true);
      if (hmsAuthRes) {
        return hmsAuthRes.data?.authorizationCode;
      }
    }
    return undefined;
  }
}