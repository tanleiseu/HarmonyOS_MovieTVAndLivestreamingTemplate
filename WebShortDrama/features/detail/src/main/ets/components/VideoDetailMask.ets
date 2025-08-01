import { Side } from './Side';
import { ShortDramaDetailItemVM } from '../viewmodels/ShortDramaDetailItemVM';
import { DetailVideoData } from '../models/DetailVideoData';
import { AppStorageKeys, StatusBarHeight } from '@agctemplate/widgets';
import { PlayController, ProcessBar, VideoPlayData, PlaySession } from '@agctemplate/video_swiper';
import { AppStorageV2, promptAction } from '@kit.ArkUI';
import { getColor, getMedia, getString } from '@agctemplate/resources';
import { SerialPicker } from './SerialPicker';
import { DramaInfo } from '@agctemplate/server';
import { PlaySetting } from './PlaySetting';
import { Logger } from '@agctemplate/utils';
import { NAV_PAGE_NAME } from '@agctemplate/resources';
import { appRouter } from '@agctemplate/utils';

/**
 * 功能描述：
 * 1. 视屏上层独立绘制页面，包含侧边控制栏，视频描述信息，弹幕设置，弹幕等。
 *
 */
const TAG = '[VideoDetailMask]'

@ComponentV2
export struct VideoDetailMask {
  // 短视频数据
  @Param @Require videoDetailMaskVM: ShortDramaDetailItemVM;
  @Param @Require playControl: PlayController;
  @Param @Require playerSession: PlaySession
  @Local statusBarHeight: StatusBarHeight = AppStorageV2.connect(StatusBarHeight, AppStorageKeys.STATUS_BAR_HEIGHT,
    () => new StatusBarHeight())!;
  @Local isShowPlaySettingSheet: boolean = false
  @Provider('speed') curIndex: number = 0
  onSpeedSet: Function = (speed: number) => {
    this.playControl.setSpeed(speed)
  }

  aboutToAppear(): void {
    this.playControl.setPlayerHeight(`calc(100% - 56vp)`)
    this.curIndex = this.videoDetailMaskVM.currentSerial
  }

  @Builder
  titleBuilder() {
    Row() {
      Image(getMedia('app.media.detail_back'))
        .height(40)
        .width(40)
    }
    .onClick(() => {
      appRouter.back(true, {
        params: {}
      })
      return true
    })
    .height(56)
    .width('100%')
    .margin({
      left: 16,
      top: `${px2vp(this.statusBarHeight.value)}vp`
    })

  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Stack({ alignContent: Alignment.TopStart }) {
        this.titleBuilder()
      }.width('100%')
      .height('100%')

      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          Stack() {
            Row({ space: 16 }) {
              Blank()
              Image(getMedia('app.media.danmaku_setting'))
                .width(24)
                .height(24)
                .onClick(() => {
                  // 调用Toast显示提示：此样式仅为案例演示
                  promptAction.showToast({ message: getString('app.string.demo_toast_tips') });
                })

              Image(getMedia('app.media.play_setting'))
                .width(24)
                .height(24)
                .onClick(() => {
                  this.isShowPlaySettingSheet = !this.isShowPlaySettingSheet
                })
                .bindSheet($$this.isShowPlaySettingSheet, this.playSettingSheetBuilder(this.onSpeedSet), {
                  height:352,
                  preferType: SheetType.BOTTOM,
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceEvenly)
            .padding({ left: 16, right: 16 })
            .margin({ bottom: 15 })
            .zIndex(4)

            ProcessBar({ playerSession: this.playerSession })
              .padding({ left: 16, right: 16 })
          }

          Row() {
            // 视频详情描述
            VideoDes({
              dramaInfo: this.videoDetailMaskVM.dramaInfo,
              curSerial: this.videoDetailMaskVM.currentSerial,
              playController: this.playControl
            })
            Blank()
            // 展示视频播放界面右侧用户头像、视频评论数量、收藏数量、分享数量等信息
            Side({
              videoDes: this.videoDetailMaskVM,
              playControl: this.playControl
            })
          }
          .width('100%')
          .height(56)
        }
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  playSettingSheetBuilder(onSpeedSet: Function) {
    Column(){
      Row(){
        Text(getString('app.string.play_settting'))
          .width(256)
          .height(27)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#e6000000')
          .textAlign(TextAlign.Start)
      }
      .height(56)
      .width(328)
      .margin({ top:14.5 })

      PlaySetting({ speedSet: onSpeedSet })
        .height(252)
    }
  }
}


@Builder
export function VideoDetailComponent(videoData: VideoPlayData, playControl: PlayController,
  playerSession: PlaySession) {

  VideoDetailMask({
    videoDetailMaskVM: (videoData as DetailVideoData).videoMask,
    playControl: playControl,
    playerSession: playerSession
  })
}

// 展示视频相关信息，比如视频作者的昵称、视频文案、搭配的音乐以及发布时间
@ComponentV2
export struct VideoDes {
  @Param @Once curSerial: number = 0; //当前集
  @Param @Require dramaInfo: DramaInfo;
  @Local isShowSerialPickerSheet: boolean = false; //是否展示选集
  @Param @Require playController: PlayController

  build() {
    // 海报与简介
    Row({ space: 16 }) {
      // 剧集海报
      Image(this.dramaInfo.coverUrl)
        .width(30)
        .height(40)
        .borderRadius(4)
        .onClick(() => {
          appRouter.push({
            builderName: NAV_PAGE_NAME.DramaDetailInfoPage.name, params: {
              dramaInfo: this.dramaInfo
            }
          })
        })
        .id('headButton')

      // 简介
      Column() {
        Text(this.dramaInfo.name)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.MARQUEE })
          .width(98)
          .height(19)
          .fontColor(Color.White)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)

        Row() {
          Text(`第${this.curSerial}集 共${this.dramaInfo.totalCount}集`)
            .height(16)
            .width(75)
            .fontColor($r('sys.color.font_on_secondary'))
            .fontSize(12)
            .fontWeight(FontWeight.Regular)
            .textOverflow({ overflow: TextOverflow.None })
            .maxLines(1)
          SymbolGlyph($r('sys.symbol.chevron_right'))
            .width(16)
            .height(16)
            .fontColor(['#99ffffff'])
        }.onClick(() => {
          this.isShowSerialPickerSheet = !this.isShowSerialPickerSheet
        })
        .bindSheet($$this.isShowSerialPickerSheet,
          this.serialPickerSheetBuilder(this.playController.curentIndex, (index: number) => {
            Logger.info(TAG, `onIndexSelect:${index}`)
            this.isShowSerialPickerSheet = !this.isShowSerialPickerSheet
            this.playController?.changeIndex(index)
          }), {
            detents: [SheetSize.MEDIUM, SheetSize.LARGE, 600],
            preferType: SheetType.BOTTOM,
            showClose: false,
            backgroundColor: Color.White
          })
      }
      .alignItems(HorizontalAlign.Start)
    }
    .padding({ left: 16, right: 10 })
    .height('100%')
    .width(170)
  }

  @Builder
  serialPickerSheetBuilder(curIndex: number, onIndexSelect: (index: number) => void) {
    Column() {
      SerialPicker({
        dramaInfo: this.dramaInfo,
        onIndexSelect: onIndexSelect,
        currentIndex: curIndex,
        spliceNum: 30
      })
    }
  }
}