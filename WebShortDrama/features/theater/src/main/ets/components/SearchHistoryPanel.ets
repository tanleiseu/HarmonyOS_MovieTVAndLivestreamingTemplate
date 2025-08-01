import { AppStorageV2 } from '@kit.ArkUI'
import { getColor, getString } from '@agctemplate/resources'
import { SearchRecords } from '../viewmodels/SearchRecordsVM'

@ComponentV2
export struct SearchHistoryPanel {

  @Param @Require searchText: string
  @Param @Require isEdit: boolean
  @Event searchRecordClickEvent: Function = () => {}
  @Local searchRecords: SearchRecords = AppStorageV2.connect(SearchRecords, () => new SearchRecords())!

  build() {
    Row() {
      Column() {
        Row() {
          Stack() {
            Column() {
              Text(getString('app.string.drama_search_history_title'))
                .fontSize(14)
                .fontColor(getColor('app.color.normal_font_color'))
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)

            Column() {
              Row() {
                Column() {
                  SymbolGlyph($r('sys.symbol.trash'))
                    .fontSize(16)
                    .fontColor([getColor('app.color.normal_font_color')])
                }

                Column() {
                  Text(getString('app.string.drama_search_result_clear_btn'))
                    .fontSize(14)
                    .fontColor(getColor('app.color.normal_font_color'))
                    .margin({
                      left: 4
                    })
                }
              }
              .onClick(() => {
                this.searchRecords.records = []
              })
            }
            .width('100%')
            .alignItems(HorizontalAlign.End)
          }
        }
        .width('100%')
        .padding({
          top: 12, bottom: 12
        })


        Flex({ wrap: FlexWrap.Wrap }){
          ForEach(this.searchRecords.records.slice(0, 9), (record: string) => {
            Column() {
              Text(record)
                .maxLines(1)
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .margin({
                  top: 4,
                  right: 12,
                  bottom: 4,
                  left: 12
                })
            }
            .margin({ bottom: 6, right: 12 })
            .borderRadius(14)
            .backgroundColor(getColor('app.color.component_background_color'))
            .onClick(() => {
              this.searchRecordClickEvent(record)
            })
          }, (record: string) => record)
        }
        .width('100%')
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .margin({
      bottom: 12
    })
    .alignItems(VerticalAlign.Top)
  }
}