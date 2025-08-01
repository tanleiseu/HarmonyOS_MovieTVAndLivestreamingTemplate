import { RetBean } from '../common/RetBean';

export class BannerRes {
  ret: RetBean;
  data: string[];
  total: number;

  constructor(bannerRes?: BannerRes) {
    this.ret = new RetBean(bannerRes?.ret);
    this.data = (bannerRes?.data || []);
    this.total = bannerRes?.total || 0;
  }
}
