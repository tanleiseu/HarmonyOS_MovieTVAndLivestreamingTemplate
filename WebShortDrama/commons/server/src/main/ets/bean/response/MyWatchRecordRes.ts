import { DramaInfo } from '../common/DramaInfo'
import { RetBean } from '../common/RetBean'

export class MyWatchRecordData extends DramaInfo {
  currentWatch: number; //当前正在看的集数

  constructor(data: MyWatchRecordData) {
    super(data);
    this.currentWatch = data?.curIndex;
  }
}

export class MyWatchRecordRes {
  ret: RetBean;
  myWatchRecord: MyWatchRecordData[];
  total: number;

  constructor(myFollowDramaRes?: MyWatchRecordRes) {
    this.ret = new RetBean(myFollowDramaRes?.ret);
    this.myWatchRecord = (myFollowDramaRes?.myWatchRecord || []).map((item) => new MyWatchRecordData(item));
    this.total = myFollowDramaRes?.total || 0;
  }
}
