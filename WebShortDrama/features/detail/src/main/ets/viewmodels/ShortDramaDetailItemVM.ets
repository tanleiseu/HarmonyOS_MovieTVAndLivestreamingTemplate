import { DramaInfo, RequestAPI } from '@agctemplate/server';
import { container } from '@agctemplate/utils';

// 剧集社交交互
@ObservedV2
export class DramaSocialInfo {
  @Trace isFavorite: boolean = false;
  @Trace favoriteCount: number = 315;
  dramaId: string

  constructor(dramaId: string, isFavorite: boolean, favoriteCount: number) {
    this.isFavorite = isFavorite
    this.dramaId = dramaId
    this.favoriteCount = favoriteCount
  }

  setFavor() {
    this.favoriteCount++;
    this.isFavorite = true
    container.resolve(RequestAPI).setFavorite(this.dramaId)
  }

  unsetFavor() {
    this.favoriteCount--;
    this.isFavorite = false
    container.resolve(RequestAPI).unsetFavorite(this.dramaId)
  }
}

// 视频遮罩层数据
@ObservedV2
export class ShortDramaDetailItemVM {
  dramaInfo: DramaInfo = new DramaInfo('');
  @Trace dramaSocialInfo: DramaSocialInfo = new DramaSocialInfo('', false, 0)
  url: string = ''
  currentSerial: number = 0; // 当前剧集
  time: string = ''; // 剧集频日期
  playTime: number = 0; // 播放进度
  @Trace likeCount: string = ''; // 点赞数量
  @Trace favoriteCount: string = ''; // 收藏数量
  @Trace shareCount: string = ''; // 分享次数
  @Trace commentCount: string = ''; // 评论数量

  setFavorite() {

  }

  unsetFavorite() {

  }
}