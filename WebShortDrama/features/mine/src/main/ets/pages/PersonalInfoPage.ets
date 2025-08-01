import { getString, NAV_PAGE_NAME } from '@agctemplate/resources';
import { appRouter, NavParams } from '@agctemplate/utils';
import { CommonServices, ListItemModel, NavDestinationModifier } from '@agctemplate/widgets'


@ComponentV2
export struct PersonalInfoPage {
  scroller: Scroller = new Scroller();
  navDestinationModifier: NavDestinationModifier = new NavDestinationModifier();
  @Param @Require userAvatar: ListItemModel[]
  @Param @Require userDetail: ListItemModel[]


  build() {
    NavDestination() {
      Column() {
        List({ scroller: this.scroller, space: 12 }) {
          ListItem() {
            CommonServices({
              commonServicesContents: this.userAvatar
            })
          }

          ListItem() {
            CommonServices({
              commonServicesContents: this.userDetail
            })
          }
        }
      }.width('100%')
      .height('100%')
      .padding({ left: 16, right: 16 })
    }
    .onBackPressed(() => {
      appRouter.back(true)
      return true
    })
    .hideTitleBar(false)
    .title(this.title())
    .backgroundColor($r('sys.color.background_secondary'))
    .attributeModifier(this.navDestinationModifier)
    .height('100%')
  }

  @Builder
  title() {
    Text(getString('app.string.personal_info'))
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .height(27)
      .margin({ top: 15, left: 8 })
  }

}

@Builder
export function PersonalInfoPageBuilder() {
  PersonalInfoPage({
    userAvatar: NavParams.getParams()?.userAvatar || [],
    userDetail: NavParams.getParams()?.userDetail || [],
  })
}