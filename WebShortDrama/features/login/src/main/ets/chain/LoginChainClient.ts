import { AgreementChainHandler } from './after/AgreementChainHandler';
import type { LoginChainHandler } from './ChainHandlerInterface';
import { NoticeChainHandler } from './after/NoticeChainHandler';

export class LoginChainClient {
  private static INSTANCE: LoginChainClient;
  // token是否有效判断、清理老数据等
  private beforeLoginChainHandlers: LoginChainHandler[] = [];
  // 协议校验、团队选择、push初始化、用户登录打点、发送登录通知等
  private afterLoginChainHandlers: LoginChainHandler[] = [];

  public static getInstance(): LoginChainClient {
    if (!LoginChainClient.INSTANCE) {
      LoginChainClient.INSTANCE = new LoginChainClient();
    }
    return LoginChainClient.INSTANCE;
  }

  private constructor() {
    this.afterLoginChainHandlers.push(new AgreementChainHandler());
    this.afterLoginChainHandlers.push(new NoticeChainHandler());
  }

  public async beforeLogin(chain2Ignore?: string[]): Promise<boolean> {
    let filteredLoginChainHandlers = this.organizeHandlers(this.beforeLoginChainHandlers, chain2Ignore);
    if (filteredLoginChainHandlers.length > 0) {
      return await filteredLoginChainHandlers[0].handleChain();
    }
    return true;
  }

  public async afterLogin(chain2Ignore?: string[]): Promise<boolean> {
    let filteredLoginChainHandlers = this.organizeHandlers(this.afterLoginChainHandlers, chain2Ignore);
    if (filteredLoginChainHandlers.length > 0) {
      return await filteredLoginChainHandlers[0].handleChain();
    }
    return true;
  }

  private organizeHandlers(loginChainHandlers: LoginChainHandler[], chain2Ignore?: string[]): LoginChainHandler[] {
    let filteredLoginChainHandlers: LoginChainHandler[] = [];
    if (!chain2Ignore) {
      filteredLoginChainHandlers = loginChainHandlers;
    } else {
      for (let handler of loginChainHandlers) {
        if (!chain2Ignore.includes(handler.getName())) {
          filteredLoginChainHandlers.push(handler);
        }
      }
    }
    for (let i = 0; i < filteredLoginChainHandlers.length; i++) {
      if (i === filteredLoginChainHandlers.length - 1) {
        filteredLoginChainHandlers[i].setNextHandler(null);
      } else {
        filteredLoginChainHandlers[i].setNextHandler(filteredLoginChainHandlers[i+1]);
      }
    }
    return filteredLoginChainHandlers;
  }
}