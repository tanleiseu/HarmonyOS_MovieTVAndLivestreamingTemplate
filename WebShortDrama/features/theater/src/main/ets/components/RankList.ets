import { DramaCoverVM } from '../viewmodels/DramaCoverVM'
import { DramaCover } from './DramaCover'

@ComponentV2
export struct RankList {
  @Param @Require dramaList: Array<DramaCoverVM>
  @Event onDramaClick: Function
  @Param @Require scroller: Scroller | undefined
  @Event loadNextPage: Function
  @Param @Require isVertical: boolean

  build() {
    List({ space: this.isVertical ? 16 : 0 }) {
      ForEach(
        this.dramaList,
        (drama: DramaCoverVM, index: number) => {
          ListItem() {
            DramaCover({ drama: drama, index: index + 1, isVertical: this.isVertical })
          }
          .margin({
            top: this.isVertical ? 0 : 12,
            // 水平排列时：让后两个元素的右侧加6个像素
            right: this.isVertical ? 0 :
              ([this.dramaList.length - 1, this.dramaList.length].indexOf(index + 1) !== -1 ? 12 : 6),
            bottom: this.isVertical ? 0 : 12,
            // 水平排列时：让前两个元素的左侧加6个像素
            left: this.isVertical ? 0 : ([1, 2].indexOf(index + 1) !== -1 ? 12 : 6)
          })
          .onClick(() => {
            if (this.onDramaClick) {
              this.onDramaClick(drama)
            }
          })
        },
        (drama: DramaCoverVM, index: number) => drama.dramaId + index
      )
    }
    .width('100%')
    .height(this.isVertical ? 'auto' : 176)
    .listDirection(this.isVertical ? Axis.Vertical : Axis.Horizontal)
    .lanes(this.isVertical ? 1 : 2)
    .scrollBar(BarState.Off)
    .onScrollIndex((start: number, end: number) => {
      if (end >= this.dramaList.length - 1) {
        this.loadNextPage()
      }
    })
  }
}