import { GlobalContext, Logger, SafeJson } from '@agctemplate/utils';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';

/**
 * 华为登录服务接口封装类,使用时通过HmsAccountManager调用
 * [app非必要不调用此类内部方法]
 */
const TAG = 'HmsAccountSdkWrapper'

export class HmsAccountSdkWrapper {
  private static _instance: HmsAccountSdkWrapper;

  private constructor() {
  }

  public static getInstance(): HmsAccountSdkWrapper {
    if (!HmsAccountSdkWrapper._instance) {
      HmsAccountSdkWrapper._instance = new HmsAccountSdkWrapper();
    }
    return HmsAccountSdkWrapper._instance;
  }

  /**
   * 手动登录账号（显示登录有登录操作界面）
   * @returns 登录成功返回数据
   */
  public async displaySignIn(): Promise<authentication.LoginWithHuaweiIDResponse | null> {
    try {
      // 创建登录请求，并设置参数
      let loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
      // 当用户未登录华为账号时，是否强制拉起华为账号登录界面
      loginRequest.forceLogin = true;
      loginRequest.state = util.generateRandomUUID();
      let controller = new authentication.AuthenticationController(GlobalContext.getContext());
      let resp = await controller.executeRequest(loginRequest);
      if (resp) {
        let loginWithHuaweiIDResponse = resp as authentication.LoginWithHuaweiIDResponse;
        let checkResult = this.responseStateValidate(loginRequest.state, loginWithHuaweiIDResponse.state);
        if (checkResult) {
          Logger.info(TAG, 'displaySignIn successful');
          // 开发者处理authCode, idToken, openID, unionID
          return Promise.resolve(loginWithHuaweiIDResponse);
        }
        Logger.warn(TAG, 'displaySignIn fail,responseStateValidate check fail.');
      }
    } catch (error) {
      Logger.error(TAG, `displaySignIn error: ${SafeJson.ohAegJsonStringify(error)}`);
    }
    return Promise.resolve(null);
  }

  /**
   * 静默登录，不会拉起授权页面(不显示登录操作界面)
   * @return Promise<authentication.AuthenticationResponse> 返回授权账号信息
   */
  public async silentSignIn(): Promise<authentication.LoginWithHuaweiIDResponse | null> {
    try {
      let loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
      // 当用户未登录华为账号时，是否强制拉起华为账号登录界面
      loginRequest.forceLogin = false;
      loginRequest.state = util.generateRandomUUID();
      let controller = new authentication.AuthenticationController();
      let resp = await controller.executeRequest(loginRequest);
      if (resp) {
        let loginWithHuaweiIDResponse = resp as authentication.LoginWithHuaweiIDResponse;
        let checkResult = this.responseStateValidate(loginRequest.state, loginWithHuaweiIDResponse.state);
        if (checkResult) {
          Logger.info(TAG, 'silentSignIn successful');
          return Promise.resolve(loginWithHuaweiIDResponse);
        }
        Logger.warn(TAG, 'silentSignIn fail,responseStateValidate check fail.');
      }
    } catch (error) {
      Logger.error(TAG, `silentSignIn error: ${SafeJson.ohAegJsonStringify(error)}`);
    }
    return Promise.resolve(null);
  }

  /**
   * 登录授权接口，用于获取用户信息，验证等信息
   *
   * AuthorizationWithHuaweiIDRequest必须在ArkUI页面上下文中执行，否则会抛出异常
   * @param scopes scope列表，用于获取用户数据。
   * @param permissions permission列表。与scopes属性不能同时为空，否则会返回1001502003 无效参数错误码。
   * @param forceAuthorization 用户是否需要登录授权，默认为true。
   * @returns 登录数据
   */
  public async accountAuthorization(scopes: string[],
    permissions: string[],
    forceAuthorization: boolean = true,
  ):
    Promise<authentication.AuthorizationWithHuaweiIDResponse | null> {
    try {
      // 创建授权请求，并设置参数
      let authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
      // 获取头像昵称需要传如下scope
      authRequest.scopes = scopes;
      // 若开发者需要进行服务端开发，则需传如下permission获取authorizationCode
      authRequest.permissions = permissions;
      // 用户是否需要登录授权，该值为true且用户未登录或未授权时，会拉起用户登录或授权页面
      authRequest.forceAuthorization = forceAuthorization;
      authRequest.state = util.generateRandomUUID();
      let controller = new authentication.AuthenticationController(GlobalContext.getContext());
      let resp = await controller.executeRequest(authRequest);
      if (resp) {
        let authorizationResponse = resp as authentication.AuthorizationWithHuaweiIDResponse;
        let checkResult = this.responseStateValidate(authRequest.state, authorizationResponse.state);
        if (checkResult) {
          Logger.info(TAG, 'accountAuthorization successful');
          return Promise.resolve(authorizationResponse);
        }
        Logger.warn(TAG, 'accountAuthorization fail,responseStateValidate check fail.');
      }
    } catch (error) {
      Logger.error(TAG, `accountAuthorization error: ${SafeJson.ohAegJsonStringify(error)}`);
    }
    return Promise.resolve(null);
  }

  /**
   * 取消授权,重新登录会重新拉起授权页面
   * @returns
   */
  public async cancelLoginRequest(): Promise<boolean> {
    try {
      // 创建取消授权请求，并设置参数
      let cancelRequest = new authentication.HuaweiIDProvider().createCancelAuthorizationRequest();
      cancelRequest.state = util.generateRandomUUID();
      // 执行登录请求
      let controller = new authentication.AuthenticationController(GlobalContext.getContext());
      let data = await controller.executeRequest(cancelRequest);
      let cancelAuthorizationResponse = data as authentication.CancelAuthorizationResponse;
      let checkResult = this.responseStateValidate(cancelRequest.state, cancelAuthorizationResponse.state);
      if (checkResult) {
        return Promise.resolve(true);
      }
      Logger.warn(TAG, 'cancelLoginRequest fail,responseStateValidate fail');
    } catch (error) {
      Logger.error(TAG, `cancelLoginRequest error: ${SafeJson.ohAegJsonStringify(error)}`);
    }
    return Promise.resolve(false);
  }


  /**
   * 请求State值与响应State值校验
   * @param reqState
   * @param respState
   * @returns
   */
  private responseStateValidate(reqState: string, respState?: string): boolean {
    return reqState !== undefined && respState !== undefined && reqState === respState;
  }
}