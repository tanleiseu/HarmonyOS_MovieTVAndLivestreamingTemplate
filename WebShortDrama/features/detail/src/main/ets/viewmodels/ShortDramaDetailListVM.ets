import { mapEpisodeInfo } from '../mapper/DramaDetailMapper';
import { VideoPlayDataSource } from '@agctemplate/video_swiper';
import { EpisodeInfo, DramaInfo, RequestAPI } from '@agctemplate/server';
import { DetailVideoData } from '../models/DetailVideoData';
import { BaseResponse, container, Logger } from '@agctemplate/utils';
import { EpisodeListRes } from '@agctemplate/server';
import { DramaSocialInfo } from './ShortDramaDetailItemVM';

const TAG = 'ShortDramaDetailListVM'

export interface ContinueVideoData {
  currentIndex?: number,
  playTime?: number,
  dramaInfo: DramaInfo
}

@ObservedV2
export class ShortDramaDetailListVM {
  @Trace ready: boolean = false
  // 短剧列表
  data: VideoPlayDataSource = new VideoPlayDataSource();
  private static _instance: ShortDramaDetailListVM;
  dramaInfo: DramaInfo = new DramaInfo('')
  playTime: number = 0

  public static get instance() {
    if (!ShortDramaDetailListVM._instance) {
      ShortDramaDetailListVM._instance = new ShortDramaDetailListVM();
    }
    return ShortDramaDetailListVM._instance;
  }

  async init(continueVideoData: ContinueVideoData) {
    try {
      let res: BaseResponse<EpisodeListRes> =
        await container.resolve(RequestAPI).getEpisodeList(continueVideoData.dramaInfo.id)
      let dramaListRes: EpisodeListRes = res.getBody();
      this.dramaInfo = dramaListRes.dramaInfo
      let dramaSocialInfo: DramaSocialInfo =
        new DramaSocialInfo(this.dramaInfo.id, this.dramaInfo.isFavorite, this.dramaInfo.favoriteCount)
      dramaListRes.episodeList?.map((episodeInfo: EpisodeInfo) => {
        let videoData: DetailVideoData = mapEpisodeInfo(episodeInfo)
        videoData.videoMask.dramaInfo = this.dramaInfo
        videoData.videoMask.dramaSocialInfo = dramaSocialInfo
        this.data.pushData(videoData);
      })
      this.ready = true
    } catch (e) {
      Logger.error(TAG, 'fetch episodeList failed')
    }
    if (continueVideoData?.currentIndex && continueVideoData?.playTime && continueVideoData?.playTime > 0) {
      this.setContinuePlayTime(continueVideoData.currentIndex, continueVideoData.playTime)
    }
  }

  private setContinuePlayTime(index: number, playTime: number) {
    (this.data.videoList[index] as DetailVideoData).videoMask.playTime = playTime
  }
}