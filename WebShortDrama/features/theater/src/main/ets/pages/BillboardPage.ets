import { CategoryButton } from '../components/CategoryButton';
import { getRankList } from '../mapper/DramaCoverMapper';
import { AiBarHeight, AppStorageKeys, StatusBarHeight } from '@agctemplate/widgets';
import { AppStorageV2, LengthMetrics } from '@kit.ArkUI';
import { getColor, getString, NAV_PAGE_NAME } from '@agctemplate/resources';
import { appRouter } from '@agctemplate/utils';
import { DramaInfo } from '@agctemplate/server';
import { getCategoryButtonList } from '../mapper/CategoryButtonMapper';
import { CategoryButtonVM } from '../viewmodels/CategoryButtonVM';
import { DramaCoverVM } from '../viewmodels/DramaCoverVM';
import { RankList } from '../components/RankList';

@ComponentV2
struct BillboardPage {
  @Local aiBarHeight: AiBarHeight = AppStorageV2.connect(AiBarHeight, AppStorageKeys.AI_BAR_HEIGHT,
    () => new AiBarHeight())!;
  @Local statusBarHeight: StatusBarHeight = AppStorageV2.connect(StatusBarHeight, AppStorageKeys.STATUS_BAR_HEIGHT,
    () => new StatusBarHeight())!;
  @Local categoryButtonList: Array<CategoryButtonVM> = []
  @Local dramaList: Array<DramaCoverVM> = []
  @Local selectedCategory: string = ''
  @Local currentPageNum: number = 1
  @Local scroller: Scroller = new Scroller()

  @Monitor('selectedCategory')
  async onSelectedCategoryChanged() {
    this.currentPageNum = 1
    this.dramaList = [] // 需要要设置为空，否则显示会异常
    this.scroller.scrollTo({
      xOffset: 0, yOffset: 0
    })
    this.dramaList = await getRankList(this.selectedCategory, this.currentPageNum)
    this.categoryButtonList.forEach(btn => {
      btn.isSelected = btn.text === this.selectedCategory
    })
  }

  async aboutToAppear() {
    this.categoryButtonList = await getCategoryButtonList()
    if (this.categoryButtonList && this.categoryButtonList.length > 0) {
      this.selectedCategory = this.categoryButtonList[0].text
    }
  }

  @Builder
  titleBuilder() {
    Text(getString('app.string.billboard_title'))
      .height('100%')
      .margin({
        left: 8
      })
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .fontColor(getColor('app.color.bold_font_color'))
  }

  build() {
    NavDestination() {
      Flex({
        direction: FlexDirection.Column,
        space: {
          main: LengthMetrics.vp(8)
        }
      }) {
        Row({ space: 8 }) {
          ForEach(this.categoryButtonList, (btn: CategoryButtonVM) => {
            CategoryButton({
              options: btn, onClickCallback: (btn: CategoryButtonVM) => {
                ((text: string) => { this.selectedCategory = text })?.(btn.text)
              }
            })
          }, (btn: CategoryButtonVM, index: number) => btn.text + index)
        }
        .width('100%')
        .height(60)

        Column() {
          RankList({dramaList:this.dramaList, onDramaClick: this.onDramaClick, scroller: this.scroller,
            loadNextPage: async () => {
              let arr = await getRankList(this.selectedCategory, ++this.currentPageNum)
              this.dramaList = this.dramaList.concat(arr)
            },
            isVertical: true
          })
        }
        .width('100%')
        .padding({ top: 8 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding({
        left: 16, right: 16
      })
    }
    .title(this.titleBuilder())
    .backgroundColor(getColor('app.color.normal_background_color'))
    .padding({ top: `${px2vp(this.statusBarHeight.value)}vp`, bottom: `${px2vp(this.aiBarHeight.value)}vp` })
  }

  onDramaClick(option: DramaCoverVM) {
    appRouter.push({
      builderName: NAV_PAGE_NAME.ShortDramaDetailPage.name,
      params: {
        dramaInfo: new DramaInfo({ id: option.dramaId }),
      },
    })
  }
}

@Builder
export function BillboardPageBuilder(index: number) {
  BillboardPage()
}
