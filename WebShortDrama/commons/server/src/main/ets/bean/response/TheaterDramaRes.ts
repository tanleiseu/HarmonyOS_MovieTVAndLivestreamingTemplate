import { DramaInfo } from '../common/DramaInfo'
import { RetBean } from '../common/RetBean'

export class TheaterDramaRes {
  ret: RetBean;
  data: DramaInfo[];
  total: number;

  constructor(theaterDramaRes?: TheaterDramaRes) {
    this.ret = new RetBean(theaterDramaRes?.ret);
    this.data = (theaterDramaRes?.data || []).map((item) => new DramaInfo(item));
    this.total = theaterDramaRes?.total || 0;
  }
}
