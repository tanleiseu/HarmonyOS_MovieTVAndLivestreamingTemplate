import { RequestAPI } from '@agctemplate/server';
import { DramaInfo } from '@agctemplate/server';
import { FeedDramaListRes } from '@agctemplate/server';
import { BaseResponse, container, Logger } from '@agctemplate/utils';
import { VideoPlayDataSource } from '@agctemplate/video_swiper';
import { mapDramaItem } from '../mapper/DramaInfoMapper';

const TAG = 'DramaListVM'

@ObservedV2
export class DramaListVM {
  @Trace ready: boolean = false
  data: VideoPlayDataSource = new VideoPlayDataSource()

  async init() {
    try {
      let res: BaseResponse<FeedDramaListRes> = await container.resolve(RequestAPI).getFeedDramaList({
        pageSize: 1,
        pageNum: 20
      })
      let dramaListRes: FeedDramaListRes = new FeedDramaListRes(res.getBody());
      dramaListRes.feedDramaList?.map((dramaInfo: DramaInfo) => {
        this.data.pushData(mapDramaItem(dramaInfo));
      })
      this.ready = true
    } catch (e) {
      Logger.error(TAG, 'fetch dramaList failed')
    }
  }
}