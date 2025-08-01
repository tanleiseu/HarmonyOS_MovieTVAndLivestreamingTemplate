import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { AccountModel, UserInfoModel } from './models';
import { UserInfo } from './models';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { Logger } from '@agctemplate/utils/src/main/ets/logger/AppLogger';
import { RequestAPI } from '@agctemplate/server';
import { container } from '@agctemplate/utils';

const TAG = '[AccountUtil]';

export class AccountUtil {
  // 用户信息
  private static _userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, 'userInfo', () => new UserInfoModel())!;
  // 账号信息
  private static _accountInfo: AccountModel =
    PersistenceV2.connect(AccountModel, 'accountInfo', () => new AccountModel())!;

  public static async silentLogin() {
    if (AccountUtil._accountInfo.unionID) {
      return;
    }
    const loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
    loginRequest.forceLogin = false;
    loginRequest.state = util.generateRandomUUID();
    try {
      const controller = new authentication.AuthenticationController();
      controller.executeRequest(loginRequest).then((response: authentication.LoginWithHuaweiIDResponse) => {
        const loginWithHuaweiIDResponse = response as authentication.LoginWithHuaweiIDResponse;
        const state = loginWithHuaweiIDResponse.state;
        if (state && loginRequest.state !== state) {
          Logger.error(TAG, `Failed to login. The state is different, response state: ${state}`);
          return;
        }
        Logger.info(TAG, 'Succeeded in logging in.');
        const loginWithHuaweiIDCredential = loginWithHuaweiIDResponse.data!;
        AccountUtil._accountInfo.idToken = loginWithHuaweiIDCredential.idToken ?? '';
        AccountUtil._accountInfo.openID = loginWithHuaweiIDCredential.openID;
        AccountUtil._accountInfo.unionID = loginWithHuaweiIDCredential.unionID;
        AccountUtil._accountInfo.authCode = loginWithHuaweiIDCredential.authorizationCode ?? '';
      })
        .catch((error: BusinessError) => {
          AccountUtil._dealAllError(error);
        });
    } catch (error) {
      AccountUtil._dealAllError(error);
    }
  }

  public static getAccountInfo() {
    return AccountUtil._accountInfo;
  }

  public static getId() {
    return AccountUtil.getAccountInfo().unionID;
  }

  public static async getUserInfo(id: string) {
    const info = await container.resolve(RequestAPI).getUserInfo(id);
    let item = info.getBody().userInfo
    try {
      AccountUtil._userInfo.id = item.id;
      AccountUtil._userInfo.avatar = item.avatar;
      AccountUtil._userInfo.nickname = item.nickname;
      AccountUtil._userInfo.isPhoneAssociated = item.isPhoneAssociated;
      AccountUtil._userInfo.isMock = item.isMock;
      AccountUtil._userInfo.cellphone = item.cellphone;
    } catch (error) {
      console.error(error);
    }
    return AccountUtil._userInfo;
  }

  public static _getUserInfo() {
    return AccountUtil._userInfo;
  }

  public static getAuthorization() {
    return AccountUtil._accountInfo.loginToken ?? AccountUtil._accountInfo.authCode;
  }

  public static updateUserInfo(data: UserInfo) {
    AccountUtil._userInfo.isPhoneAssociated = data.isPhoneAssociated ?? AccountUtil._userInfo.isPhoneAssociated;
    AccountUtil._userInfo.avatar = data.avatar ?? AccountUtil._userInfo.avatar;
    AccountUtil._userInfo.nickname = data.nickname ?? AccountUtil._userInfo.nickname;
    AccountUtil._userInfo.cellphone = data.cellphone ?? AccountUtil._userInfo.cellphone;
  }

  private static _dealAllError(error: BusinessError): void {
    Logger.error(TAG, `Failed to login, errorCode: ${error.code}, errorMsg: ${error.message}`);
  }
}

export * from './models'