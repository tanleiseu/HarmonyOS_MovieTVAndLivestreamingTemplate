import { Tab, TabHeaderInfo } from '../components/tabs/TabItem';
import { TabInfoRegister } from '../../../../../Index';
import {
  AiBarHeight,
  AppStorageKeys,
  BreakPoint,
  BreakPointType,
  BreakPointValue,
  StatusBarHeight,
} from '@agctemplate/widgets';
import { appRouter } from '@agctemplate/utils';
import { AppStorageV2 } from '@kit.ArkUI';

export interface TabInfo {
  tabHeaderInfo: TabHeaderInfo;
  tabContentBuilder: WrappedBuilder<[number]>;
}

@ComponentV2
export struct MainTabPage {
  @Local currentBreakpoint: BreakPoint = AppStorageV2.connect(BreakPoint, AppStorageKeys.CURRENT_BREAK_POINT,
    () => new BreakPoint(BreakPointValue.SM))!;
  @Local aiBarHeight: AiBarHeight = AppStorageV2.connect(AiBarHeight, AppStorageKeys.AI_BAR_HEIGHT,
    () => new AiBarHeight())!;
  @Local statusBarHeight: StatusBarHeight = AppStorageV2.connect(StatusBarHeight, AppStorageKeys.STATUS_BAR_HEIGHT,
    () => new StatusBarHeight())!;
  @Provider('curTabIndex') currentIndex: number = 0;
  @Local isDarkEnable: boolean = true; // 默认主页为深色tab
  private controller: TabsController = new TabsController();
  private isFirstTimeIn: boolean = true; // 优化首次进入无弹跳效果

  aboutToAppear(): void {
  }

  @Builder
  TabBuilder(item: TabHeaderInfo) {
    Tab({
      isFirstTimeIn: this.isFirstTimeIn,
      tabHeaderInfo: item,
      isSelected: item.index === this.currentIndex,
      isDark: this.isDarkEnable
    })
  }

  build() {
    NavDestination() {
      Tabs({
        barPosition: new BreakPointType<BarPosition>({
          sm: BarPosition.End,
          md: BarPosition.End,
          lg: BarPosition.Start
        }).getValue(this.currentBreakpoint.value),
        controller: this.controller
      }) {
        ForEach(TabInfoRegister.tabInfos, (tabInfo: TabInfo, index: number) => {
          TabContent() {
            tabInfo.tabContentBuilder.builder(index)
          }
          .tabBar(this.TabBuilder(new TabHeaderInfo(tabInfo.tabHeaderInfo.name, tabInfo.tabHeaderInfo.showSearch,
            tabInfo.tabHeaderInfo.iconOn, tabInfo.tabHeaderInfo.iconOff, tabInfo.tabHeaderInfo.iconDarkOff, index)))
        }, (tabInfo: TabInfo, index: number) => {
          return index + '_' + JSON.stringify(tabInfo.tabHeaderInfo.name);
        })
      }
      .flexShrink(1)
      .flexGrow(1)
      .vertical(new BreakPointType<boolean>({ sm: false, md: false, lg: true }).getValue(this.currentBreakpoint.value))
      .barWidth(new BreakPointType<number | string>({
        sm: '100%',
        md: '100%',
        lg: 96
      }).getValue(this.currentBreakpoint.value))
      .barHeight(new BreakPointType<number | string>({
        sm: 48,
        md: 48,
        lg: 400
      }).getValue(this.currentBreakpoint.value))
      .onTabBarClick((index: number) => {
        this.isFirstTimeIn = false;
        this.currentIndex = index;
        this.isDarkEnable = this.currentIndex === 0 ? true : false
      })
      .scrollable(false)
      .animationDuration(0)
      .backgroundColor(this.isDarkEnable ? $r('sys.color.black') :
      $r('sys.color.ohos_id_background_secondary'))
      .padding({
        top: 0,
        bottom: this.currentBreakpoint.value === BreakPointValue.LG ? 0 : `${px2vp(this.aiBarHeight.value)}vp`
      })
    }.onBackPressed(() => {
      appRouter.back(true)
      return true;
    }).hideTitleBar(true)
  }
}

@Builder
export function MainTabPageBuilder() {
  MainTabPage();
}
