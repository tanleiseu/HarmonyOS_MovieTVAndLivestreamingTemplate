import { NAV_PAGE_NAME } from '@agctemplate/resources';
import { DramaInfo } from '@agctemplate/server';
import { appRouter } from '@agctemplate/utils';
import { getRecommendList } from '../../../../Index';
import { DramaCoverVM } from './DramaCoverVM';

@ObservedV2
export class DramaDetailVM {
  @Trace recommendList: Array<DramaCoverVM> = []
  detailInfo: DramaInfo;
  currentIndex: number = 0;

  constructor(detailInfo: DramaInfo, currentIndex?: number) {
    this.detailInfo = detailInfo
    this.currentIndex = currentIndex ?? 0
    getRecommendList(-1).then((data) => {
      this.recommendList = data;
    })
  }

  playDrama() {
    appRouter.back(true)
  }

  jumpDetailPage(options: DramaCoverVM) {
    appRouter.push({
      builderName: NAV_PAGE_NAME.ShortDramaDetailPage.name,
      params: {
        dramaInfo: {
          id: options.dramaId
        } as DramaInfo,
      },
    })
  }
}

export class ActorInfo {
  avatar: ResourceStr | string = ''
  name: string = ''
}