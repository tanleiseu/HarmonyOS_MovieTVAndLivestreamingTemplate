import { jumpDetailPage } from '@agctemplate/detail';
import { getColor, getString } from '@agctemplate/resources';
import { DramaInfo } from '@agctemplate/server';

@ComponentV2
export struct VideoSeries {
  @Param @Require title: string;
  @Param @Require currentEpisode: number;
  @Param @Require episodesDes: string;
  @Param @Require cover: string; // 封面
  @Event onContinueWatch: () => void

  build() {
    Row() {
      Image(this.cover).width(68).height(90).margin({ right: 16 })
      Column() {
        Text(this.title)
          .fontSize($r('sys.float.Subtitle_M'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .maxLines(1)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .margin({ top: 8 })

        Text(getString('app.string.have_watch', `${this.currentEpisode}`))
          .fontSize($r('sys.float.Body_S'))
          .fontWeight(FontWeight.Regular)
          .fontColor(getColor('app.color.orange'))
          .maxLines(1)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .margin({ top: 2 })

        Text(this.episodesDes)
          .fontSize($r('sys.float.Body_S'))
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.font_secondary'))
          .maxLines(1)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .margin({ top: 12 })

      }
      .alignItems(HorizontalAlign.Start)
      .height('100%')
      .layoutWeight(1)

      Text(getString('app.string.continue_watch'))
        .borderRadius(16)
        .fontSize($r('sys.float.Body_M'))
        .fontWeight(FontWeight.Medium)
        .fontColor(getColor('app.color.orange'))
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .height(28)
        .padding({ left: 8, right: 8 })
        .width('auto')
        .onClick(() => {
          if (this.onContinueWatch) {
            this.onContinueWatch()
          }
        })
    }.width('100%')
    .height(90)
    .margin({ top: 8, bottom: 8 })
  }
}