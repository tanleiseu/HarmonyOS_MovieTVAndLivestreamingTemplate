import { SpeedSegmentButton } from './SpeedSegmentButton'
import { promptAction } from '@kit.ArkUI';
import { getString } from '@agctemplate/resources';

@Preview
@ComponentV2
export struct PlaySetting {
  @Event speedSet: Function = (speed: number) => {};
  speedArr: Array<number> = [5, 1, 2, 6, 4]; //['0.5x', '1.0x', '1.25x', '1.5x', '2.0x']对应的数字

  onIndexSelect: (index: number) => void = (index: number) => {
    if (index > this.speedArr.length) {
      return;
    }
    let speed: number = this.speedArr[index]
    this.speedSet(speed)
  };

  build() {
    Column({ space: 12 }) {
      // speed
      Row() {
        Row() {
          Text(getString('app.string.play_speed_setting'))
            .textStyle(14, FontWeight.Regular)
            .width(56)
            .height(19)
          Column() {
            SpeedSegmentButton({ onIndexSelect: this.onIndexSelect })
              .width(270)
          }
          .margin({ left:12 })
          .height('100%')
        }
        .width('100%')
        .height(36)
      }
      .width('100%')
      .height(48)

      // clear screen
      Row() {
        Text(getString('app.string.clear_screen_switch'))
          .textStyle()
        Toggle({ type: ToggleType.Switch, isOn: false })
          .width(36)
          .height(20)
          .selectedColor('#F17F31')
          .onChange((isOn: boolean) => {
            // 调用Toast显示提示：此样式仅为案例演示
            promptAction.showToast({ message: getString('app.string.demo_toast_tips') });
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(48)

      // danmu
      Row() {
        Text(getString('app.string.danmaku_switch'))
          .textStyle()
        Toggle({ type: ToggleType.Switch, isOn: true })
          .width(36)
          .height(20)
          .selectedColor('#F17F31')
          .onChange((isOn: boolean) => {
            // 调用Toast显示提示：此样式仅为案例演示
            promptAction.showToast({ message: getString('app.string.demo_toast_tips') });
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(48)

      // set danmu
      Row() {
        Text(getString('app.string.danmaku_setting'))
          .textStyle()

        SymbolGlyph($r('sys.symbol.chevron_right'))
          .scale({ x:2, y:2 })
          .fontColor(['#3000'])
          .onClick(() => {
            // 调用Toast显示提示：此样式仅为案例演示
            promptAction.showToast({ message: getString('app.string.demo_toast_tips') });
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(48)
    }
    .width('100%')
    .height(252)
    .padding('16px 18px 12px 16px')
  }
}

@Extend(Text) function textStyle(size: number = 16, weight: FontWeight = FontWeight.Medium){
  .fontSize(size)
  .fontWeight(weight)
  .fontColor('#e6000000')
}