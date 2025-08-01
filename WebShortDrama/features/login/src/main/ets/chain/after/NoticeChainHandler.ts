import { EventHubUtil, GlobalContext } from '@agctemplate/utils';
import { AppNotice } from '@agctemplate/common/src/main/ets/notice/AppNotice';
import { LoginChainHandler } from '../ChainHandlerInterface';

/**
 * 登录广播
 */
export class NoticeChainHandler extends LoginChainHandler {
  protected handlerName: string = "Notice";

  public async handle(): Promise<boolean> {
    EventHubUtil.emit(GlobalContext.getContext(), AppNotice.LOGIN_OK);
    return true;
  }
}