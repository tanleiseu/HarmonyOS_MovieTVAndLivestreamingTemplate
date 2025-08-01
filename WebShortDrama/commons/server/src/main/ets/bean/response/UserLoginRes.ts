import { RetBean } from '../common/RetBean';

export class UserLoginRes {
  ret: RetBean;
  loginToken: string;
  id: string;
  avatar: string;
  nickname: string;
  cellphone: string;
  bonusPoint: number;

  constructor(userLoginRes?: UserLoginRes) {
    this.ret = new RetBean(userLoginRes?.ret);
    this.id = userLoginRes?.id || '';
    this.loginToken = userLoginRes?.loginToken || '';
    this.avatar = userLoginRes?.avatar || '';
    this.nickname = userLoginRes?.nickname || '';
    this.cellphone = userLoginRes?.cellphone || '';
    this.bonusPoint = userLoginRes?.bonusPoint || 0;
  }
}
