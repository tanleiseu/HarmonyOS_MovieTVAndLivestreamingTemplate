import { getMedia, getString, NAV_PAGE_NAME } from '@agctemplate/resources'
import { AppStorageKeys, ListItemModel, Mine, MinePageVM, StatusBarHeight } from '@agctemplate/widgets'
import { appRouter } from '@agctemplate/utils';
import { AppStorageV2, promptAction } from '@kit.ArkUI';


@ComponentV2
export struct MineMainPage {
  @Local statusBarHeight: StatusBarHeight = AppStorageV2.connect(StatusBarHeight, AppStorageKeys.STATUS_BAR_HEIGHT,
    () => new StatusBarHeight())!;
  @Local userAvatar: ListItemModel = new ListItemModel(getString('app.string.avatar'))
  @Local userName: ListItemModel = new ListItemModel(getString('app.string.nick_name'))
  @Local userPhone: ListItemModel = new ListItemModel(getString('app.string.phone_number'))
  @Local vm: MinePageVM = MinePageVM.instance;

  build() {
    Mine({
      userInfoHandler: () => {
        appRouter.push({
          builderName: NAV_PAGE_NAME.PersonalInfoPage.name, params: {
            userAvatar: [this.userAvatar.setContentImage(this.vm.localInfo.avatar ? this.vm.localInfo.avatar :
            this.vm.userInfo.avatar)
              .setHandle(() => {
                appRouter.push({
                  builderName: NAV_PAGE_NAME.ChangePage.name
                })
              })],
            userDetail: [this.userName.setContentText(this.vm.localInfo.nickname ? this.vm.localInfo.nickname :
            this.vm.userInfo.nickname)
              .setHandle(() => {
                appRouter.push({
                  builderName: NAV_PAGE_NAME.ChangePage.name
                })
              }),
              this.userPhone.setContentText(this.vm.userInfo.cellphone).setHandle(() => {
                promptAction.showToast({ message: getString('app.string.phone_tip'), alignment: Alignment.Center });
              })]
          }
        })
      },
      commonServicesContents: [new ListItemModel(getString('app.string.my_favor'),
        getMedia('app.media.favor')).setHandle(() => {
        if (this.vm.userInfo.isPhoneAssociated) {
          appRouter.push({ builderName: NAV_PAGE_NAME.MyFavoritesPage.name })
        } else {
          promptAction.showToast({ message: getString('app.string.login_tip'), alignment: Alignment.Center });
        }
      }),
        new ListItemModel(getString('app.string.my_record'), getMedia('app.media.record')).setHandle(() => {
          appRouter.push({ builderName: NAV_PAGE_NAME.WatchRecordsPage.name })
        })]
    })
      .padding({ top: `${px2vp(this.statusBarHeight.value)}vp` })
  }
}

@Builder
export function MineMainPageBuilder(index: number) {
  MineMainPage()
}