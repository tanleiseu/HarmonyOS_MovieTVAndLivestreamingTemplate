export abstract class LoginChainHandler {
  protected handlerName: string;
  private nextHandler: LoginChainHandler = null;

  public setNextHandler(loginChainHandler: LoginChainHandler): void {
    this.nextHandler = loginChainHandler;
  }

  public getNextHandler(): LoginChainHandler {
    return this.nextHandler;
  }

  public getName(): string {
    return this.handlerName;
  }

  public async handleChain(): Promise<boolean> {
    if (await this.handle()) {
      return this.nextHandler ? await this.nextHandler.handleChain() : true;
    }
    return false;
  }

  protected abstract handle(): Promise<boolean>;
}