import { ListItemModel } from '../../model/ListItemModel'
import { RowModifier } from '../../AttributeModifiers'

@Extend(Text)
function mainTextDescStyles() {
  .fontSize($r('sys.float.Subtitle_M'))
  .fontWeight(FontWeight.Medium)
  .fontColor($r('sys.color.font_primary'))
  .maxLines(1)
  .textOverflow({
    overflow: TextOverflow.Ellipsis
  })
}

@Extend(Text)
function contentTextDescStyles() {
  .fontSize($r('sys.float.Body_M'))
  .fontWeight(FontWeight.Regular)
  .fontColor($r('sys.color.font_secondary'))
  .maxLines(1)
  .textOverflow({
    overflow: TextOverflow.Ellipsis
  })
}

@ComponentV2
export struct CommonServices {
  @Param @Once title?: ResourceStr = ''
  @Param commonServicesContents: ListItemModel[] = []
  rowModifier: RowModifier = new RowModifier();

  @Styles
  iconSizeStyles() {
    .width(24)
    .height(24)
  }

  build() {
    Column({ space: 8 }) {
      if (this.title) {
        Text(this.title)
          .fontSize($r('sys.float.Subtitle_L'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_primary'))
          .height(24)
          .margin({
            left: 12,
            right: 12,
            bottom: 0,
            top: 24
          })
      }

      Grid() {
        ForEach(this.commonServicesContents, (item: ListItemModel, index: number) => {
          GridItem() {
            Row({ space: 16 }) {
              if (item.icon && item.symbol) {
                SymbolGlyph(item.icon as Resource)
                  .fontSize(24)
                  .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                  .fontColor([$r('sys.color.icon_secondary')])
              } else if (item.icon) {
                Image(item.icon)
                  .iconSizeStyles()
                  .fillColor($r('sys.color.icon_secondary'))
                  .draggable(false)
                  .autoResize(false)
                  .interpolation(ImageInterpolation.High)
              }

              Row({ space: 12 }) {
                Text(item.mainText)
                  .mainTextDescStyles()

                Row({ space: 4 }) {
                  if (item.contentImage) {
                    Image(item.contentImage)
                      .width(40)
                      .height(40)
                      .borderRadius(20)
                      .draggable(false)
                  } else if (item.contentText) {
                    Text(item.contentText)
                      .contentTextDescStyles()
                  }
                  SymbolGlyph($r('sys.symbol.chevron_right'))
                    .fontSize(24)
                    .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                    .fontColor([$r('sys.color.icon_fourth')])
                }
              }.layoutWeight(1)
              .height('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .border({
                color: { bottom: $r('sys.color.comp_divider') },
                width: { bottom: index === this.commonServicesContents.length - 1 ? 0 : '1px' }
              })
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .height('100%')
            .enabled(!item.disabled)
            .padding({ left: 8, right: 8 })
            .borderRadius(14)
            .attributeModifier(this.rowModifier)
            .onClick(() => {
              if (item.handler) {
                item.handler()
              }
            })
          }.margin({ left: 4, right: 4 })
          .height(56)
        }, (item: ListItemModel, index: number) => item.mainText + '_' + index)
      }
      .columnsTemplate('1fr')
      .width('100%')
      .height('auto')
      .padding({ bottom: 4 })
    }
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
  }
}