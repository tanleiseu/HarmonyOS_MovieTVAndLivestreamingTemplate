import { DramaInfo } from '@agctemplate/server'
import { VideoPlayData } from '@agctemplate/video_swiper'

export class DramaItemVM implements VideoPlayData {
  dramaInfo: DramaInfo

  getUrl(): string {
    return this.dramaInfo.promotionalUrl
  }

  getPlayTime(): number {
    return 0
  }

  getPic(): ResourceStr {
    return this.dramaInfo.coverUrl
  }


  constructor(dramaInfo: DramaInfo) {
    this.dramaInfo = dramaInfo
  }
}