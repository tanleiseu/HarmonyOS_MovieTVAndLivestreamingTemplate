import { getString } from '@agctemplate/resources';
import { Logger } from '@agctemplate/utils';
import { VideoSwiper, PlayController } from '@agctemplate/video_swiper';
import { DramaDesComponent } from '../components/DramaDes';
import { DramaListVM } from '../viewmodel/DramaListVM';

const TAG = 'HomeMainPage'

@ComponentV2
export struct HomeMainPage {
  @Param @Require index: number;
  @Consumer('curTabIndex') curTabIndex: number = 0;

  @Monitor('curTabIndex')
  onIndexChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      console.log(`${path} change from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`);
      let curIndex = monitor.value(path)?.now as number
      if (this.index === curIndex) {
        this.playController.play();
      } else {
        this.playController.pause()
      }
    })
  }

  @Local vm: DramaListVM = new DramaListVM()
  playController: PlayController = new PlayController()

  aboutToAppear(): void {
    this.vm.init()
    this.playController.autoPlay = true
  }

  build() {
    if (this.vm.ready) {
      Stack({ alignContent: Alignment.Bottom }) {
        // 视频切换组件
        VideoSwiper({
          playController: this.playController,
          videoPlayDataSource: this.vm.data,
          contentBuilder: wrapBuilder(DramaDesComponent),
        })
          .width('100%')
          .height('100%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
    } else {
      Stack({ alignContent: Alignment.Center }) {
        Column() {
          Text(getString('app.string.tips_net_err'))
            .fontColor($r('sys.color.white'))
          Button(getString('app.string.refresh'))
            .onClick(() => {
              this.vm.init()
            })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
    }
  }
}

@Builder
export function HomeMainPageBuilder(index: number) {
  HomeMainPage({ index: index })
}