import { DramaCoverVM } from '../viewmodels/DramaCoverVM'
import { LengthMetrics } from '@kit.ArkUI'
import { getMedia, getString } from '@agctemplate/resources'
import { DramaRecommendInfo } from './DramaRecommendInfo'

@ComponentV2
export struct RecommendPanel {

  @Param @Require recommendList: Array<DramaCoverVM>
  @Param @Require gutter: number
  @Event onDramaClick: (options: DramaCoverVM) => void

  build() {
    Row() {
      Column() {
        Row() {
          Column() {
            Image(getMedia('app.media.tv'))
              .width(24)
              .height(24)
          }

          Column() {
            Text(getString('app.string.drama_recommend_title'))
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
          }
          .margin({
            left: 4
          })
        }
        .margin({
          top: 12,
          bottom: 12
        })

        Row() {
          Flex({
            wrap: FlexWrap.Wrap,
            space: { cross: LengthMetrics.vp(16), main: LengthMetrics.vp(this.gutter) },
            justifyContent: FlexAlign.Start
          }) {
            ForEach(this.recommendList, (recommend: DramaCoverVM) => {
              DramaRecommendInfo({ drama: recommend, onItemClick: (options: DramaCoverVM) => {
                if (this.onDramaClick) {
                  this.onDramaClick(options)
                }
              }})
            }, (recommend: DramaCoverVM, index: number) => recommend.dramaId + index)
          }
        }
        .alignItems(VerticalAlign.Top)
      }
      .alignItems(HorizontalAlign.Start)
      .margin({
        bottom: 16
      })

    }
    .width('100%')
    .margin({
      top: 12,
      bottom: 0,
    })
    .alignItems(VerticalAlign.Top)
  }
}