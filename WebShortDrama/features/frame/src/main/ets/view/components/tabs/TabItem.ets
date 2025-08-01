import { getColor } from '@agctemplate/resources';

/**
 * 单个Tab
 */
@ComponentV2
export struct Tab {
  @Param isFirstTimeIn: boolean = false; // 优化首次进入无弹跳效果
  @Param isSelected: boolean = false;
  @Param isDark: boolean = false;
  @Param tabHeaderInfo: TabHeaderInfo = new TabHeaderInfo(undefined!, false, undefined!, undefined!, undefined!);

  @Builder
  SymbolIcon() {
    Image(this.isSelected ? this.tabHeaderInfo.iconOn : (!this.isDark ? this.tabHeaderInfo.iconOff :
    this.tabHeaderInfo.iconDarkOff))
      .animation({
        duration: this.isSelected ? 500 : 0,
        curve: Curve.EaseOut,
        iterations: 1,
        playMode: PlayMode.Normal,
      })
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      Stack() {
        this.SymbolIcon()
        // 切换选中状态时，中间态叠加颜色处理
        this.SymbolIcon()
      }.height(24).width(24)

      Text(this.tabHeaderInfo.name)
        .fontColor(this.isSelected ? this.tabHeaderInfo.textColor[0] : (!this.isDark ? this.tabHeaderInfo.textColor[1] :
        this.tabHeaderInfo.textColor[2]))
        .fontSize($r('sys.float.Caption_M'))
        .height(14)
        .textAlign(TextAlign.Center)
        .margin({ top: 2 })
    }
    .width('100%').height('100%')
  }
}

export class TabHeaderInfo {
  index: number = 0;
  name: Resource;
  showSearch: boolean = false;
  textColor: Array<Resource> =
    [getColor('app.color.orange'), $r('sys.color.font_secondary'),
      $r('sys.color.font_on_secondary')];
  iconOn: Resource
  iconOff: Resource
  iconDarkOn?: Resource
  iconDarkOff: Resource

  constructor(name: Resource, showSearch: boolean, iconOn: Resource, iconOff: Resource, iconDarkOff: Resource,
    index?: number) {
    this.name = name;
    this.showSearch = showSearch;
    this.iconOn = iconOn;
    this.iconOff = iconOff;
    this.iconDarkOff = iconDarkOff
    if (index) {
      this.index = index
    }
  }
}

