import { AppStorageV2, window } from '@kit.ArkUI';
import { ShortDramaDetailListVM, ContinueVideoData } from '../viewmodels/ShortDramaDetailListVM';
import { VideoDetailComponent as VideoDetailComponent } from '../components/VideoDetailMask';
import {
  AiBarHeight,
  AppStorageKeys,
  BreakPoint,
  BreakPointValue,
  StatusBarHeight
} from '@agctemplate/widgets';
import { VideoSwiper, PlayerLayoutSize, PlayController } from '@agctemplate/video_swiper';
import { NAV_PAGE_NAME } from '@agctemplate/resources';
import { appRouter, Logger, NavParams } from '@agctemplate/utils';
import { DramaInfo } from '@agctemplate/server';

const TAG: string = 'ShortVideo';


@ComponentV2
export struct ShortDramaDetailPage {
  @Local currentBreakpoint: BreakPoint = AppStorageV2.connect(BreakPoint, AppStorageKeys.CURRENT_BREAK_POINT,
    () => new BreakPoint(BreakPointValue.SM))!;
  @Local aiBarHeight: AiBarHeight = AppStorageV2.connect(AiBarHeight, AppStorageKeys.AI_BAR_HEIGHT,
    () => new AiBarHeight())!;
  @Local statusBarHeight: StatusBarHeight = AppStorageV2.connect(StatusBarHeight, AppStorageKeys.STATUS_BAR_HEIGHT,
    () => new StatusBarHeight())!;
  // 初始化当前视频的下标
  @Local currentVideoIndex: number = 0;
  // 首视频标志
  @Local firstFlag: boolean = true;
  // 当前播放视频的索引
  @Local isPageShow: boolean = false;
  @Local layoutSize: PlayerLayoutSize = new PlayerLayoutSize()
  @Param @Require continueVideoData: ContinueVideoData;
  // 短视频数据
  @Local vm: ShortDramaDetailListVM = new ShortDramaDetailListVM;
  windowClass?: window.Window;
  playController: PlayController = new PlayController()

  listenBackPress() {

  }

  // 视频数据初始化
  aboutToAppear() {
    this.playController.autoPlay = true
    this.currentVideoIndex = this.continueVideoData.currentIndex || 0
    this.vm.init(this.continueVideoData)

    // 注册事件监听
    this.listenBackPress();
    Logger.info(TAG, 'aboutToAppear')
  }

  aboutToDisappear(): void {
    let sysBarProps: window.SystemBarProperties = {
      statusBarContentColor: '#000000'
    };
    this.windowClass?.setWindowSystemBarProperties(sysBarProps);
  }

  build() {
    NavDestination() {
      if (this.vm.ready) {
        Stack({ alignContent: Alignment.Bottom }) {
          // 视频切换组件
          VideoSwiper({
            playController: this.playController,
            videoPlayDataSource: this.vm.data,
            contentBuilder: wrapBuilder(VideoDetailComponent),
            currentVideoIndex: this.currentVideoIndex
          })
            .width('100%')
            .height('100%')
        }
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Black)
        .padding({
          top: 0,
          bottom: this.currentBreakpoint.value === BreakPointValue.LG ? 0 : `${px2vp(this.aiBarHeight.value)}vp`
        })
      }
    }
    .hideTitleBar(true)
    .onBackPressed(() => {
      appRouter.back(true, {
        params: {}
      })
      return true
    })
  }
}

@Builder
export function shortDramaDetailPageBuilder() {
  ShortDramaDetailPage({
    continueVideoData: {
      currentIndex: NavParams.getParams()?.currentIndex,
      playTime: NavParams.getParams()?.playTime,
      dramaInfo: NavParams.getParams()?.dramaInfo
    }
  });
}

export function jumpDetailPage(dramaInfo: DramaInfo, currentIndex?: number, playTime?: number,
  callback?: (popInfo: PopInfo) => void) {
  appRouter.push({
    builderName: NAV_PAGE_NAME.ShortDramaDetailPage.name,
    params: {
      dramaInfo: dramaInfo,
      currentIndex: currentIndex,
      playTime: playTime
    },
    popCallback: callback
  })
}