import { SocialInfo } from "./SocialInfo";

export class EpisodeInfo {
  id: number; // 剧集id
  url: string; //播放地址
  desc: string; //剧集描述
  dramaId:string // 剧目id
  socialInfo: SocialInfo; //社交信息
  totalCount:number; //剧集总数

  constructor(episodeInfo: any) {
    this.id = episodeInfo?.id
    this.url = episodeInfo?.url
    this.desc = episodeInfo?.desc
    this.dramaId = episodeInfo?.dramaId
    this.socialInfo = episodeInfo?.socialInfo
  }
}