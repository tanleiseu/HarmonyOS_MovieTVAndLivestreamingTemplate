import { VideoPlayData } from '@agctemplate/video_swiper';
import { ShortDramaDetailItemVM } from '../viewmodels/ShortDramaDetailItemVM';

// 详情数据结构
export class DetailVideoData implements VideoPlayData {
  videoMask: ShortDramaDetailItemVM;

  constructor(videoMask: ShortDramaDetailItemVM) {
    this.videoMask = videoMask
  }

  getUrl(): string {
    return this.videoMask.url
  }

  getPlayTime(): number {
    return this.videoMask.playTime
  }

  getPic(): string {
    return this.videoMask.dramaInfo.coverUrl
  }
}