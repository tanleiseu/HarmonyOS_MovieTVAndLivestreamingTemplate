import { Logger } from '@agctemplate/utils';
import { getString } from '@agctemplate/resources';
import { DramaItemVM } from '../viewmodel/DramaItemVM';
import { ProcessBar, VideoPlayData, PlayController, PlaySession } from '@agctemplate/video_swiper';
import { DramaInfo } from '@agctemplate/server';
import { jumpDetailPage } from '@agctemplate/detail';

const TAG = '[DramaDes]'

/**
 * 功能描述：
 * 1. Home剧集信息流上层独立绘制页面，视频描述信息，海报，看全集。
 *
 */
@Preview
@ComponentV2
export struct HomeDramaDes {
  @Param @Once @Require dramaInfo: DramaInfo //剧集信息
  @Param @Require playControl: PlayController;
  @Param @Require playerSession: PlaySession

  aboutToAppear(): void {
    this.playerSession.onStateChange('stateChange', (state: string) => {
      // 进入详情播放页播放下一集
      if (state === 'completed') {
        jumpDetailPage(this.dramaInfo, this.dramaInfo.curIndex + 1, 0, (data: PopInfo) => {
          this.onReEnter()
        })
      }
    })
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Stack({ alignContent: Alignment.Bottom }) {
        // 海报与简介
        Row({ space: 16 }) {
          // 剧集海报
          Image(this.dramaInfo.coverUrl)
            .width(48)
            .height('100%')
            .borderRadius(8)
            .id('headButton')

          // 简介
          Column() {
            Text(this.dramaInfo.name)
              .width('100%')
              .height(22)
              .fontColor(Color.White)
              .fontSize($r('sys.float.Subtitle_M'))
              .fontColor($r('sys.color.font_on_primary'))
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
              .textAlign(TextAlign.Start)

            Text(getString('app.string.drama_desc', this.dramaInfo.totalCount.toString(), this.dramaInfo.description))
              .fontSize($r('sys.float.Body_S'))
              .fontColor($r('sys.color.font_on_secondary'))
              .width('100%')
              .height(38)
              .fontSize(12)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(2)
              .textAlign(TextAlign.Start)
          }
          .layoutWeight(1)

          // 看全集
          Button(getString('app.string.watch_full_drama'))
            .onClick(() => {
              Logger.debug(TAG, `currentPlayTime:${this.playerSession.avPlayer?.currentTime}`)
              // 进入详情页，接续播放
              jumpDetailPage(this.dramaInfo, this.dramaInfo.curIndex, this.playerSession.avPlayer?.currentTime,
                (data: PopInfo) => {
                  this.onReEnter()
                })
            })
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_on_primary'))
            .backgroundColor($r('sys.color.icon_on_tertiary'))
            .borderRadius(14)
            .id('watchFullDrama')
            .height(28)
            .zIndex(4)

        }
        .height(64)
        .width('100%')
        .margin({ bottom:10 })
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .height(64)

      ProcessBar({ playerSession: this.playerSession })

    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16 })
  }

  onReEnter() {
    this.playControl.play()
  }
}

@Builder
export function DramaDesComponent(videoData: VideoPlayData, playControl: PlayController, playerSession: PlaySession) {
  HomeDramaDes({
    dramaInfo: (videoData as DramaItemVM).dramaInfo,
    playControl: playControl,
    playerSession: playerSession
  })
}
