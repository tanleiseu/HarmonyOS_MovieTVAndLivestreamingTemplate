import { LoginChainHandler } from '../ChainHandlerInterface';

export enum SignStatus {
  SIGN_LATEST_VERSION,
  SIGN_OLD_VERSION,
  NOT_SIGN_YET,
  NOT_LOGIN
}

const TAG = "AgreementChainHandler"

/**
 * 协议查询
 */
export class AgreementChainHandler extends LoginChainHandler {
  protected handlerName: string = "Agreement";

  public async handle(): Promise<boolean> {
    return true;
  }
}