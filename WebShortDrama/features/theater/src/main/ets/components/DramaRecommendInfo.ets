import { DramaCoverVM } from '../viewmodels/DramaCoverVM'
import { getCoverEpisodeShowText } from './DramaCover'

@ComponentV2
export struct DramaRecommendInfo {

  @Param @Require drama: DramaCoverVM
  @Param @Require onItemClick: Function

  @Builder
  episodeInfoBuilder(latestUpdate: number, episodes: number) {
    Column() {
      Text(getCoverEpisodeShowText(latestUpdate === episodes, episodes, latestUpdate))
        .padding({
          top: 1,
          right: 8,
          bottom: 1,
          left: 8
        })
        .borderRadius(14)
        .fontSize(10)
        .fontColor(Color.White)
        .backgroundColor($r('sys.color.mask_tertiary'))
        .height(16)
    }
    .padding({
      right: 2, bottom: 2,
    })
    .height(18)
    .alignItems(HorizontalAlign.End)
  }

  build() {
    Column() {
      Image(this.drama.imagePath)
        .height(140)
        .width(104)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)
        .overlay(this.episodeInfoBuilder(this.drama.episodes, this.drama.latestUpdate), { align: Alignment.BottomEnd })
      Text(this.drama.title)
        .width(104)
        .maxLines(1)
        .fontSize(14)
        .margin({ top: 8 })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      this.onItemClick(this.drama)
    })
  }
}