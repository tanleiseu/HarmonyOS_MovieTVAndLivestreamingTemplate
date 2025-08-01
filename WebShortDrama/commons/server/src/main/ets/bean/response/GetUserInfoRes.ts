import { RetBean } from "../common/RetBean";

export interface GetUserInfoRes {
  ret: RetBean;
  userInfo: UserInfoModel;
}

class UserInfoModel  {
  id: string = '';
  isPhoneAssociated: boolean = false;
  isMock: boolean = false;
  avatar: string = '';
  nickname: string = '';
  cellphone: string = '';
}