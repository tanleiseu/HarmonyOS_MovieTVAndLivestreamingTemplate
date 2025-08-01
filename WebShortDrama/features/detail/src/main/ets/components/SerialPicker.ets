import { getColor } from '@agctemplate/resources'
import { DramaInfo } from '@agctemplate/server'
import { util } from '@kit.ArkTS'

export class ActorInfo {
  id: string = ''
  avatar: ResourceStr = ''
  name: string = ''

  constructor(name: string, avatar: ResourceStr) {
    this.name = name
    this.avatar = avatar
  }
}

@ComponentV2
export struct DramaDesc {
  @Param @Require @Once dramaInfo: DramaInfo

  build() {
    Column() {
      Row() {
        Image(this.dramaInfo.coverUrl)
          .width(48)
          .height(64)

        Column() {
          Flex({ alignItems: ItemAlign.Center }) {
            Text(this.dramaInfo.name)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .flexBasis('auto')
              .height(21)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            Row() {
              SymbolGlyph($r('sys.symbol.chevron_right'))
                .height(16)
                .width(16)
            }.height(21)
            .width(16)
            .margin({ left: 2 })
          }
          .align(Alignment.Start)

          Text(this.dramaInfo.description)
            .fontSize(12)
            .fontWeight(FontWeight.Regular)
            .opacity(0.6)
            .height(16)
            .maxLines(1)
            .textAlign(TextAlign.Start)
            .margin({ top: 2, bottom: 8 })
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          List({ space: 16 }) {
            ForEach(this.dramaInfo.actorInfo, (item: ActorInfo, index: number) => {
              ListItem() {
                Row() {
                  Image(item.avatar)
                    .width(16)
                    .height(16)
                  Text(item.name)
                    .fontSize(12)
                    .fontWeight(FontWeight.Regular)
                    .opacity(0.6)
                    .height(16)
                    .margin({ left: 8 })
                }
              }
            }, (item: ActorInfo) => item.toString())
          }.height(16)
          .listDirection(Axis.Horizontal)
        }.width('calc(100% - 64vp)')
        .alignItems(HorizontalAlign.Start)
      }.justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
  }
}

@ComponentV2
export struct SerialPicker {
  @Param @Require dramaInfo: DramaInfo
  @Param @Once spliceNum: number = 30
  @Param @Once currentIndex: number = 5
  @Local currentTabIndex: number = 0
  @Event onIndexSelect: (index: number) => void = (index: number) => {
  };
  pageStack: NavPathStack = new NavPathStack();
  totalTabIndex: number = 0
  leftIndex: number = 0
  tabArray: Array<string> = [];
  fullIndexArray: Array<number> = [];
  tailIndexArray: Array<number> = []
  private controller: TabsController = new TabsController()

  aboutToAppear(): void {
    this.currentTabIndex = Math.floor(this.currentIndex / this.spliceNum)
    this.totalTabIndex = Math.floor(this.dramaInfo.totalCount / this.spliceNum) + 1
    for (let i = 0; i < this.totalTabIndex; i++) {
      if (i === this.totalTabIndex - 1) {
        this.tabArray.push(`${i * this.spliceNum + 1}-${this.dramaInfo.totalCount}`)
      } else {
        this.tabArray.push(`${i * this.spliceNum + 1}-${i * this.spliceNum + this.spliceNum}`)
      }
    }
    this.leftIndex = this.dramaInfo.totalCount % this.spliceNum
    for (let i = 0; i < this.spliceNum; i++) {
      this.fullIndexArray.push(i)
    }
    for (let i = 0; i < this.leftIndex; i++) {
      this.tailIndexArray.push(i)
    }
  }

  build() {
    Stack() {
      Column() {
        DramaDesc({
          dramaInfo: this.dramaInfo
        })

        List({ space: 24 }) {
          ForEach(this.tabArray, (item: string, index: number) => {
            ListItem() {
              Text(item)
                .fontColor(this.currentTabIndex === index ? $r('sys.color.font_primary') :
                $r('sys.color.font_secondary'))
                .fontSize($r('sys.float.Body_M'))
                .height(19)
            }.onClick(() => {
              this.currentTabIndex = index
            })
          }, (item: string, index: number) => item + index)
        }.width('100%')
        .listDirection(Axis.Horizontal)
        .height(19)
        .margin({ top: 32, bottom: 16 })

        Tabs({ index: this.currentTabIndex, controller: this.controller }) {
          ForEach(this.tabArray, (item: string, index: number) => {
            TabContent() {
              Grid() {
                if (index === this.totalTabIndex - 1) {
                  ForEach(this.tailIndexArray, (item: number, indexIndex: number) => {
                    GridItem() {
                      Text(`${(index) * this.spliceNum + indexIndex + 1}`)
                        .textAlign(TextAlign.Center)
                        .width(48)
                        .height(48)
                        .onClick(() => {
                          this.onIndexSelect(index * this.spliceNum + indexIndex)
                        })
                        .fontColor($r('sys.color.font_primary'))
                        .fontSize($r('sys.float.Body_M'))
                        .backgroundColor(this.currentIndex === (index * this.spliceNum + indexIndex) ?
                        getColor('app.color.orange') :
                        $r('sys.color.background_secondary'))
                    }
                  }, (item: number) => item.toString())
                } else {
                  ForEach(this.fullIndexArray, (item: number, indexIndex: number) => {
                    GridItem() {
                      Text(`${(index) * this.spliceNum + indexIndex + 1}`)
                        .textAlign(TextAlign.Center)
                        .width(48)
                        .height(48)
                        .onClick(() => {
                          this.currentIndex = (index * this.spliceNum + indexIndex)
                          this.onIndexSelect(index * this.spliceNum + indexIndex)
                        })
                        .fontColor($r('sys.color.font_primary'))
                        .fontSize($r('sys.float.Body_M'))
                        .backgroundColor(this.currentIndex === (index * this.spliceNum + indexIndex) ?
                        getColor('app.color.orange') :
                        $r('sys.color.background_secondary'))
                    }
                  }, (item: number) => item.toString())
                }

              }
              .maxCount(6)
              .columnsGap(8)
              .rowsGap(8)
            }
            .align(Alignment.Top)

          }, (item: string) => item + util.generateRandomUUID())
        }
        .onChange((index: number) => {
          this.currentTabIndex = index
        })
        .barHeight(0)
      }.width('100%')
      .padding({ top: 34, left: 16, right: 16 })
    }
    .alignContent(Alignment.BottomEnd)
    .height(487)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}