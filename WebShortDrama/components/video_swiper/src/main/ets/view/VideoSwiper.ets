import { VideoPlayView } from './VideoPlayView';
import { VideoPlayData, VideoPlayDataSource } from '../datasource/VideoPlayDataSource';
import { PlayController } from '../controller/PlayController';
import { PlaySession } from '../controller/PlaySession';
import { hilog } from '@kit.PerformanceAnalysisKit';

/**
 * 功能描述：
 * 1. 进入页面，播放第一个视频。上下滑动切换视频，点击视频可以控制视频的播放和暂停。
 *
 * 实现原理：
 * 1. 使用Swiper组件创建一个竖直的可上下滑动的框架
 * 2. Swiper组件结合LazyForEach使用，懒加载资源
 * 3. 在Swiper组件中使用Video组件承载视频
 *
 * @param videoPlayDataSource:视频播放数据,提供给lazy for each
 * @param contentBuilder：视频播放上面的图层内容
 *
 */
const TAG = '[VideoSwiper]'

// 视频划动组件
@ComponentV2
export struct VideoSwiper {
  // 短视频数据
  @Param @Require videoPlayDataSource: VideoPlayDataSource = new VideoPlayDataSource();
  // 初始化当前视频的下标
  @Param @Once currentVideoIndex: number = 0;
  // 外部view
  @Param @Require contentBuilder: WrappedBuilder<[VideoPlayData, PlayController, PlaySession]>;
  // 播放控制器
  @Param playController: PlayController = new PlayController()
  // 首视频标志
  @Local firstFlag: boolean = true;
  @Local isPageShow: boolean = false;
  // Swiper组件控制器
  private swiperController: SwiperController = new SwiperController();

  aboutToAppear(): void {
    hilog.debug(0x0000, TAG, `data size:${this.videoPlayDataSource.totalCount()}`)
    this.playController.setSwiperController(this.swiperController)
    this.playController.curentIndex = this.currentVideoIndex
  }

  onPageShow(): void {
    hilog.debug(0x0000, TAG, 'onPageShow!');
    this.isPageShow = true;
  }

  build() {
    Stack() {
      Swiper(this.swiperController) { // 使用Swiper组件实现滑动轮播显示的能力
        LazyForEach(this.videoPlayDataSource, (item: VideoPlayData, index: number) => {
          VideoPlayView({
            playController: this.playController,
            curIndex: this.currentVideoIndex,
            index: index,
            firstFlag: this.firstFlag,
            isPageShow: true,
            firstLoaded: () => {
              this.firstFlag = false;
            },
            videoData: item,
            contentBuilder: this.contentBuilder,
            previewUri: item.getPic(),
          })
        },
          (item: string, index: number) => JSON.stringify(item) + index
        )
      }
      .cachedCount(this.firstFlag ? 0 : 2)
      .width('100%')
      .height('100%')
      .vertical(true)
      .loop(false)
      .curve(Curve.Ease)
      .duration(300)
      .indicator(false)
      .backgroundColor(Color.Black)
      .index($$this.currentVideoIndex)
      .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
        hilog.debug(0x0000, TAG, `onGestureSwipe index: ${index}, extraInfo: ${extraInfo}.`);
      })
      .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
        hilog.debug(0x0000, TAG,
          `onAnimationStart index: ${index}, targetIndex: ${targetIndex}, extraInfo: ${extraInfo}.`);
        this.currentVideoIndex = targetIndex;
      })
      .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent) => {
        hilog.debug(0x0000, TAG, `onAnimationEnd index: ${index}, extraInfo: ${extraInfo}.`);
      })
      .onChange((index: number) => {
        hilog.debug(0x0000, TAG, `onChange index: ${index}.`);
        this.currentVideoIndex = index;
        this.playController.curentIndex = index
      })
    }
    .width('100%')
    .height('100%')

  }
}
