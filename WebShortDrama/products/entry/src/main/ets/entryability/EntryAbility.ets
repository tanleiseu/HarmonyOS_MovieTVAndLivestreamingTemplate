import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { AppStorageV2, display, window } from '@kit.ArkUI';
import { GlobalContext, Logger, WindowManager } from '@agctemplate/utils';
import {
  AiBarHeight,
  AppStorageKeys,
  BreakPoint,
  BreakPointValue,
  DEFAULT_STATUS_BAR_HEIGHT,
  StatusBarHeight
} from '@agctemplate/widgets';

const TAG = 'EntryAbility'

export default class EntryAbility extends UIAbility {
  private curBp: BreakPointValue = BreakPointValue.SM;
  private breakPoint = AppStorageV2.connect(BreakPoint, AppStorageKeys.CURRENT_BREAK_POINT,
    () => new BreakPoint(this.curBp))!;
  private statusBarHeight = AppStorageV2.connect(StatusBarHeight, AppStorageKeys.STATUS_BAR_HEIGHT,
    () => new StatusBarHeight(DEFAULT_STATUS_BAR_HEIGHT))!;
  private aiBarHeight = AppStorageV2.connect(AiBarHeight, AppStorageKeys.AI_BAR_HEIGHT,
    () => new AiBarHeight(0))!;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(TAG, 'Ability onCreate');
    this.contextInit();
  }

  onDestroy(): void {
    Logger.info(TAG, 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'Ability onWindowStageCreate');
    WindowManager.initWindowStage(windowStage);
    let windowClass = windowStage.getMainWindowSync();
    // 获取应用启动时的窗口尺寸
    this.updateBreakpoint(windowClass.getWindowProperties().windowRect.width);
    this.updateAvoidArea(windowClass);
    this.windowClassListenEvent(windowClass);
    await WindowManager.setWindowLayoutFullScreen(true)
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err) ?? ''}`);
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info(TAG, 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info(TAG, 'Ability onBackground');
  }

  private contextInit() {
    GlobalContext.initContext(this.context);
  }

  private updateAvoidArea(windowClass: window.Window) {
    const avoidArea: window.AvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    const navAvoidArea: window.AvoidArea =
      windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    this.aiBarHeight.value = navAvoidArea?.bottomRect?.height ?? 0
    this.statusBarHeight.value = avoidArea?.topRect?.height || DEFAULT_STATUS_BAR_HEIGHT;
  }

  private windowClassListenEvent(windowClass: window.Window) {
    // 注册回调函数，监听窗口尺寸变化
    windowClass.on('windowSizeChange', (windowSize) => {
      this.updateBreakpoint(windowSize.width)
    })
    // 注册回调函数，监听状态栏和底部AI bar的高度
    windowClass.on('avoidAreaChange', (data) => {
      if (window.AvoidAreaType.TYPE_SYSTEM === data.type) {
        this.statusBarHeight.value = data?.area?.topRect?.height || DEFAULT_STATUS_BAR_HEIGHT;
      } else if (window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR === data.type) {
        this.aiBarHeight.value = data?.area?.bottomRect?.height ?? 0
      }
    });
  }

  private updateBreakpoint(windowWidth: number): void {
    // 将长度的单位由px换算为vp
    let windowWidthVp = windowWidth / display.getDefaultDisplaySync().densityPixels;
    let newBp: BreakPointValue;
    if (windowWidthVp < 600) {
      newBp = BreakPointValue.SM;
    } else if (windowWidthVp < 840) {
      newBp = BreakPointValue.MD;
    } else {
      newBp = BreakPointValue.LG;
    }
    if (this.curBp !== newBp) {
      this.curBp = newBp;
      // 使用状态变量记录当前断点值
      this.breakPoint.value = this.curBp
    }
  }
}
