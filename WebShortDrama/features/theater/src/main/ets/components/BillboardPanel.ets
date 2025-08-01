import { getColor, getMedia, getString, NAV_PAGE_NAME } from '@agctemplate/resources'
import { appRouter } from '@agctemplate/utils'
import { CategoryButtonVM } from '../viewmodels/CategoryButtonVM'
import { DramaCoverVM } from '../viewmodels/DramaCoverVM'
import { CategoryButton } from './CategoryButton'
import { RankList } from './RankList'

@ComponentV2
export struct BillboardPanel {

  @Consumer('categoryButtonList') categoryButtonList: Array<CategoryButtonVM> = []
  @Consumer('categoryButtonChanged') categoryButtonChanged: Function | undefined
  @Consumer('billboardDramaList') dramaList: Array<DramaCoverVM> = []
  @Event onDramaClick: (option: DramaCoverVM) => void

  build() {
    Row() {
      Column() {
        // 顶部的类型切换
        Row() {
          Scroll() {
            Row({ space: 8 }) {
              ForEach(this.categoryButtonList, (btn: CategoryButtonVM) => {
                CategoryButton({
                  options: btn, onClickCallback: async (btn: CategoryButtonVM) => {
                    this.categoryButtonChanged?.(btn)
                  }
                })
              }, (btn: CategoryButtonVM, index: number) => btn.text + index)
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
          .layoutWeight(5)

          Column() {
            Row() {
              Column() {
                Text(getString('app.string.billboard_category_all'))
                  .fontSize(12)
                  .fontColor(getColor('app.color.normal_font_color'))
              }

              Column() {
                Image(getMedia('app.media.arrow_right'))
                  .width(12)
                  .height(12)
              }
            }
            .height('100%')
            .onClick(() => {
              appRouter.push({
                builderName: NAV_PAGE_NAME.BillboardPage.name
              })
            })
          }
          .alignItems(HorizontalAlign.End)
          .layoutWeight(1)
        }
        .height(56)
        .width('100%')

        // 榜单的列表
        Row() {
          RankList({dramaList: this.dramaList, onDramaClick: this.onDramaClick, scroller: undefined,
            isVertical: false})
        }
        .borderRadius(16)
        .backgroundColor(Color.White)
      }
    }
    .width('100%')
    .margin({
      top: 12,
      bottom: 0
    })
    .alignItems(VerticalAlign.Top)
  }
}