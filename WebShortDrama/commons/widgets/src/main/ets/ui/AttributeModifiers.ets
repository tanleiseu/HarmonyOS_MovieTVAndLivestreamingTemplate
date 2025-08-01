import { AiBarHeight, StatusBarHeight } from './avoid_area/AvoidArea';
import { AppStorageV2 } from '@kit.ArkUI';
import { AppStorageKeys } from '../const/AppStorageKeys';

export class MainTitleModifier implements AttributeModifier<TextAttribute> {
  applyNormalAttribute(instance: TextAttribute): void {
    instance.fontSize($r('sys.float.Title_M'))
      .fontWeight(FontWeight.Bold)
      .fontColor($r('sys.color.font_primary'))
      .maxLines(1)
      .textOverflow({
        overflow: TextOverflow.Ellipsis
      })
  }
}

export class RowModifier implements AttributeModifier<RowAttribute> {
  applyNormalAttribute(instance: RowAttribute): void {
    instance
      .borderWidth(0)
      .borderColor(Color.Transparent)
      .opacity(1)
  }

  applyDisabledAttribute(instance: RowAttribute): void {
    instance
      .borderWidth(0)
      .borderColor(Color.Transparent)
      .backgroundColor(Color.Transparent)
      .opacity($r('sys.float.alpha_tertiary'))
  }

  applyPressedAttribute(instance: RowAttribute): void {
    instance
      .borderWidth(0)
      .borderColor(Color.Transparent)
      .backgroundColor($r('sys.color.interactive_pressed'))
      .opacity(1)
  }
}

@ObservedV2
export class NavDestinationModifier implements AttributeModifier<NavDestinationAttribute> {
  @Trace aiBarHeight: AiBarHeight = AppStorageV2.connect(AiBarHeight, AppStorageKeys.AI_BAR_HEIGHT,
    () => new AiBarHeight())!;
  @Trace statusBarHeight: StatusBarHeight = AppStorageV2.connect(StatusBarHeight, AppStorageKeys.STATUS_BAR_HEIGHT,
    () => new StatusBarHeight())!;

  applyNormalAttribute(instance: NavDestinationAttribute): void {
    instance
      .padding({ top: `${px2vp(this.statusBarHeight.value)}vp`, bottom: `${px2vp(this.aiBarHeight.value)}vp` })
  }
}