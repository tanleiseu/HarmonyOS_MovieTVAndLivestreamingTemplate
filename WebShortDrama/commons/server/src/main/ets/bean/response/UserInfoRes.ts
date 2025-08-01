import { RetBean } from '../common/RetBean';

export class UserInfoRes {
  ret: RetBean;
  id: string;
  name: string;
  image: string;
  phone: string;

  constructor(userInfoRes?: UserInfoRes) {
    this.ret = new RetBean(userInfoRes?.ret);
    this.id = userInfoRes?.id || '';
    this.name = userInfoRes?.name || '';
    this.image = userInfoRes?.image || '';
    this.phone = userInfoRes?.phone || '';
  }
}
