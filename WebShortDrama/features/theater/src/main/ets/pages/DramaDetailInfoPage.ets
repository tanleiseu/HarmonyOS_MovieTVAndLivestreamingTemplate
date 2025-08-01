import { getColor, getMedia, getString } from '@agctemplate/resources';
import { AiBarHeight, AppStorageKeys, StatusBarHeight } from '@agctemplate/widgets';
import { AppStorageV2 } from '@kit.ArkUI';
import { NavParams } from '@agctemplate/utils';
import { DramaInfo } from '@agctemplate/server';
import { DramaCoverVM } from '../viewmodels/DramaCoverVM';
import { ActorInfo, DramaDetailVM } from '../viewmodels/DramaDetailVM';
import { DramaRecommendInfo } from '../components/DramaRecommendInfo';

@ComponentV2
export struct DramaDetailInfoPage {
  @Local aiBarHeight: AiBarHeight = AppStorageV2.connect(AiBarHeight, AppStorageKeys.AI_BAR_HEIGHT,
    () => new AiBarHeight())!;
  @Local statusBarHeight: StatusBarHeight = AppStorageV2.connect(StatusBarHeight, AppStorageKeys.STATUS_BAR_HEIGHT,
    () => new StatusBarHeight())!;
  @Param @Require vm: DramaDetailVM;

  async aboutToAppear(): Promise<void> {
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          InfoView({
            detailInfo: this.vm.detailInfo,
            onPlayClick: () => {
              this.vm.playDrama()
            }
          })
          ActorsView({ actorInfo: this.vm.detailInfo.actorInfo })
          RecommendView({
            recommendList: this.vm.recommendList, gutter: 21, onItemClick: (options: DramaCoverVM) => {
              this.vm.jumpDetailPage(options)
            }
          })
        }
        .margin({ top: 12 })
        .padding({ left: 16, right: 16 })
        .width('100%')
        .height(651)
      }
      .scrollBar(BarState.Off)
    }
    .backgroundColor(getColor('app.color.normal_background_color'))
    .padding({
      top: `${px2vp(this.statusBarHeight.value)}vp`,
      bottom: `${px2vp(this.aiBarHeight.value)}vp`
    })
  }
}

@ComponentV2
struct InfoView {
  @Param @Require detailInfo: DramaInfo;
  @Event onPlayClick: Function

  build() {
    Column() {
      Row({ space: 16 }) {
        Image(this.detailInfo.coverUrl)
          .width(68)
          .height(90)
          .borderRadius(8)
          .margin({ top: 1 })
          .border({ width: 1, color: '#0d000000', style: BorderStyle.Solid })

        Column() {
          Text(this.detailInfo.name)
            .fontSize($r('sys.float.Subtitle_M'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
            .maxLines(1)
            .width('100%')
            .height(21)
            .textAlign(TextAlign.Start)
            .textOverflow({
              overflow: TextOverflow.Ellipsis
            })
            .margin({ top: 5, left: 5 })

          Text(`${this.detailInfo.category} · ${this.detailInfo.popular}`)
            .height(19)
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_secondary'))
            .fontWeight(FontWeight.Regular)
            .margin({ top: 2 })
            .width('100%')

          Row() {
            Button() {
              Row() {
                Image(getMedia('app.media.info_play'))
                  .width(16)
                  .height(16)
                  .margin({ right: 4 })
                Text(getString('app.string.play'))
                  .textAlign(TextAlign.Start)
                  .fontSize($r('sys.float.Subtitle_M'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('sys.color.font_primary'))
              }
            }
            .width(96)
            .height(36)
            .borderRadius(21)
            .margin({ top: 13 })
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .onClick(() => this.onPlayClick())
          }
          .width('100%')
        }
      }
      .width('100%')

      Text(getString('app.string.synopsis_desc'))
        .width('100%')
        .height(24)
        .fontSize($r('sys.float.Subtitle_L'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))
        .margin({ top: 36 })

      Text(this.detailInfo.description)
        .width('100%')
        .height(114)
        .maxLines(6)
        .margin({ top: 12 })
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
        .fontColor($r('sys.color.font_primary'))
        .align(Alignment.TopStart)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
  }
}

@ComponentV2
struct ActorsView {
  @Param @Require actorInfo: ActorInfo[];

  build() {
    Column() {
      Text(getString('app.string.actor'))
        .width('100%')
        .height(24)
        .fontSize($r('sys.float.Subtitle_L'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))
        .margin({ top: 24, bottom: 12 })

      List() {
        ForEach(this.actorInfo, (item: ActorInfo) => {
          ListItem() {
            Column() {
              Image(item.avatar)
                .borderRadius(24)
                .width(48)
                .height(48)
                .margin({ bottom: 8 })

              Text(item.name)
                .height(19)
                .fontSize($r('sys.float.Body_M'))
                .fontColor($r('sys.color.font_primary'))
                .fontWeight(FontWeight.Regular)
            }
            .margin({ right: 16 })
          }
        }, (item: ActorInfo) => JSON.stringify(item))
      }
      .listDirection(Axis.Horizontal)
      .width('100%')
      .height(75)
    }
    .width('100%')
    .margin({ bottom: 24 })
  }
}

@ComponentV2
struct RecommendView {
  @Param @Require recommendList: Array<DramaCoverVM>
  @Param @Require gutter: number
  @Event onItemClick: Function

  build() {
    Column() {
      Text(getString('app.string.related_recommned'))
        .width('100%')
        .height(24)
        .fontSize($r('sys.float.Subtitle_L'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))
        .margin({ bottom: 12 })

      List() {
        ForEach(this.recommendList, (recommend: DramaCoverVM) => {
          ListItem() {
            DramaRecommendInfo({ drama: recommend, onItemClick: this.onItemClick })
          }
          .margin({ right: 9.5 })
        }, (item: DramaCoverVM) => item.dramaId + item.title)
      }
      .height('100%')
      .width('100%')
      .listDirection(Axis.Horizontal)
      .scrollBar(BarState.Off)
    }
    .width('100%')
  }
}

@Builder
export function dramaInfoPageBuilder() {
  DramaDetailInfoPage({ vm: new DramaDetailVM(NavParams.getParams()?.dramaInfo) });
}