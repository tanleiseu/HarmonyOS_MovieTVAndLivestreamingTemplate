import { DramaInfo } from '../common/DramaInfo';
import { RetBean } from '../common/RetBean';

export class FeedDramaListRes {
  ret: RetBean;
  feedDramaList: DramaInfo[];
  total: number;

  constructor(dramaListRes?: FeedDramaListRes) {
    this.ret = new RetBean(dramaListRes?.ret);
    this.feedDramaList = (dramaListRes?.feedDramaList || []).map((item) => new DramaInfo(item));
    this.total = dramaListRes?.total || 0;
  }
}