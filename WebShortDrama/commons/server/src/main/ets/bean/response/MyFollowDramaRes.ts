import { DramaInfo } from '../common/DramaInfo'
import { RetBean } from '../common/RetBean'

export class MyFollowDramaData extends DramaInfo {
  currentWatch: number; //当前正在看的集数

  constructor(data: MyFollowDramaData) {
    super(data);
    this.currentWatch = data?.curIndex;
  }
}

export class MyFollowDramaRes {
  ret: RetBean;
  myFollowDramas: MyFollowDramaData[];
  total: number;

  constructor(myFollowDramaRes?: MyFollowDramaRes) {
    this.ret = new RetBean(myFollowDramaRes?.ret);
    this.myFollowDramas = (myFollowDramaRes?.myFollowDramas || []).map((item) => new MyFollowDramaData(item));
    this.total = myFollowDramaRes?.total || 0;
  }
}
