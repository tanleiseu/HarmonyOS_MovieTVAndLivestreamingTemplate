import { getColor, NAV_PAGE_NAME } from '@agctemplate/resources'
import { appRouter } from '@agctemplate/utils'
import { AppStorageV2, window } from '@kit.ArkUI'
import { AppStorageKeys, StatusBarHeight } from '@agctemplate/widgets'
import { DramaCoverVM } from '../viewmodels/DramaCoverVM'
import { CategoryButtonVM } from '../viewmodels/CategoryButtonVM'
import { getRankList, getRecommendList } from '../mapper/DramaCoverMapper'
import { getCategoryButtonList } from '../mapper/CategoryButtonMapper'
import { getBannerList } from '../mapper/BannerMapper'
import { DramaInfo } from '@agctemplate/server'
import { SearchPanel } from '../components/SearchPanel'
import { BannerPanel } from '../components/BannerPanel'
import { BillboardPanel } from '../components/BillboardPanel'
import { RecommendPanel } from '../components/RecommendPanel'
import { Context } from '@kit.AbilityKit'

@ComponentV2
struct TheaterMainPage {
  @Local statusBarHeight: StatusBarHeight = AppStorageV2.connect(StatusBarHeight, AppStorageKeys.STATUS_BAR_HEIGHT,
    () => new StatusBarHeight())!;
  @Local recommendList: Array<DramaCoverVM> = []
  @Local currentRecommendPageNum: number = 1
  @Local bannerList: Array<string> = []
  @Local gutter: number = 21
  @Provider('categoryButtonList') categoryButtonList: Array<CategoryButtonVM> = []
  @Provider('billboardDramaList') billboardDramaList: Array<DramaCoverVM> = []
  @Provider('categoryButtonChanged') categoryButtonChanged: Function = async (selectedBtn: CategoryButtonVM) => {
    this.categoryButtonList.forEach(btn => {
      btn.isSelected = btn.text === selectedBtn.text
    })
    this.billboardDramaList = await getRankList(selectedBtn.text)
  }

  async initViewData(): Promise<void> {
    // 分类按钮的显示
    this.categoryButtonList = await getCategoryButtonList()
    const selected = this.categoryButtonList.find(btn => btn.isSelected)
    if (selected) {
      // 根据选中的分类按钮请求服务端榜单数据
      this.billboardDramaList = await getRankList(selected.text)
    }
    // 刷新短剧推荐数据
    this.recommendList = await getRecommendList(1)
    // 刷新轮播图图片信息
    this.bannerList = await getBannerList()
  }

  @Builder
  titleBuilder() {
    Text(getColor('app.string.theater'))
      .height('100%')
      .margin({
        left: 16
      })
      .fontSize(24)
      .fontWeight(FontWeight.Bold)
      .fontColor(getColor('app.color.bold_font_color'))
  }

  async aboutToAppear() {
    // 初始化界面数据
    this.initViewData()
    // 计算优选短剧的间距
    this.gutter = await this.calcRecommendGutter(getContext(this))
  }

  async calcRecommendGutter(context: Context): Promise<number> {
    const padding = 32, coverWidth = 104
    let windowClass = await window.getLastWindow(context)
    let properties = windowClass.getWindowProperties()
    let width = px2vp(properties.windowRect.width)
    let num = Math.floor((width - padding) / coverWidth)
    return (width - padding - num * coverWidth) / (num - 1)
  }

  onDramaClick(option: DramaCoverVM) {
    appRouter.push({
      builderName: NAV_PAGE_NAME.ShortDramaDetailPage.name,
      params: {
        dramaInfo: new DramaInfo({ id: option.dramaId }),
      },
    })
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          SearchPanel({
            textController: undefined,
            searchText: '',
            searchResult: undefined,
            isEdit: false,
            isInput: false
          })
          BannerPanel({
            bannerList: this.bannerList
          })
          BillboardPanel({ onDramaClick: this.onDramaClick })
          RecommendPanel({
            recommendList: this.recommendList, onDramaClick: this.onDramaClick, gutter: this.gutter
          })
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .padding({
        left: 16, right: 16
      })
      .scrollBar(BarState.Off)
      .align(Alignment.TopStart)
      .onReachEnd(async () => {
        const list = await getRecommendList(++this.currentRecommendPageNum)
        this.recommendList = this.recommendList.concat(list)
      })
    }
    .title(this.titleBuilder())
    .backgroundColor(getColor('app.color.common_background_color'))
    .padding({ top: `${px2vp(this.statusBarHeight.value)}vp` })
  }
}

@Builder
export function TheaterMainPageBuilder(index: number) {
  TheaterMainPage()
}