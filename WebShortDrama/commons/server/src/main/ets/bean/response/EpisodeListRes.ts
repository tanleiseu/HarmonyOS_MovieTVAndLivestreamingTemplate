import { RetBean } from '../common/RetBean';
import { EpisodeInfo } from '../common/EpisodeInfo';
import { DramaInfo } from '../common/DramaInfo';

export class EpisodeListRes {
  ret: RetBean;
  dramaInfo: DramaInfo
  episodeList: EpisodeInfo[];

  constructor(dramaInfo: DramaInfo, episodeListRes?: EpisodeListRes) {
    this.ret = new RetBean(episodeListRes?.ret);
    this.dramaInfo = dramaInfo
    this.episodeList = (episodeListRes?.episodeList || []).map((item) => new EpisodeInfo(item));
  }
}