import { ActorInfo } from "./ActorInfo";
import { EpisodeInfo } from "./EpisodeInfo";

export class DramaInfo {
  id: string; // 短剧id
  coverUrl: string; // 短剧封面链接
  promotionalUrl: string; // 剧集宣传片
  name: string; // 短剧名称
  description: string; // 短剧描述
  totalCount: number; //总集数
  curIndex: number; // 当前播放集(剧集推荐流使用作为详情页接续播放, 从0开始递增)
  latestUpdate: number; //最新更新集数
  category: string; //分类
  popular: string; //热度
  actorInfo: ActorInfo[]; //演员表
  episodeList: EpisodeInfo[]; //剧集列表
  isFavorite:boolean; // 是否追剧
  favoriteCount:number; // 追剧人数

  constructor(dramaInfo: any) {
    this.id = dramaInfo?.id;
    this.coverUrl = dramaInfo?.coverUrl;
    this.name = dramaInfo?.name;
    this.description = dramaInfo?.description;
    this.totalCount = dramaInfo?.totalCount;
    this.latestUpdate = dramaInfo?.latestUpdate;
    this.category = dramaInfo?.category;
    this.promotionalUrl = dramaInfo?.promotionalUrl;
    this.actorInfo = dramaInfo?.actorInfo;
    this.popular = dramaInfo?.popular;
    this.episodeList = dramaInfo?.episodeList;
    this.curIndex = dramaInfo?.curIndex;
    this.favoriteCount = dramaInfo?.favoriteCount;
    this.isFavorite = dramaInfo?.isFavorite;
  }
}
