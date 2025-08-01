import { LoginChainClient } from './LoginChainClient';

// 拦截器，作用于登录前后
export function loginInterceptor(target: any, propertyKey: string, descriptor: PropertyDescriptor): PropertyDescriptor {
  const originalMethod = descriptor.value;

  descriptor.value = async function (...args: any[]): Promise<boolean> {
    const result = await LoginChainClient.getInstance().beforeLogin() ? await originalMethod.apply(this, args) : false;
    if (result) {
      return await LoginChainClient.getInstance().afterLogin();
    }
    return result;
  };
  return descriptor;
}

