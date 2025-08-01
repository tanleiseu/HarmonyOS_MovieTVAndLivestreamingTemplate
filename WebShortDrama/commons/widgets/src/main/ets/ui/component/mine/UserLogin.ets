import { getColor, getMedia, getString } from '@agctemplate/resources'
import { Logger } from '@agctemplate/utils'
import { RowModifier } from '../../AttributeModifiers'
import { promptAction } from '@kit.ArkUI'
import { AssociateUtil } from '../../../util/Utils'
import { MinePageVM } from '../../viewmodel/MinePageVM'
import { UserInfoModel } from '../../../util/AccountUtil'
import { FunctionalButton, functionalButtonComponentManager } from '@kit.ScenarioFusionKit'


@Extend(Image)
function profileImageStyles() {
  .width(48)
  .height(48)
  .borderRadius(24)
  .draggable(false)
  .autoResize(false)
  .objectFit(ImageFit.Cover)
  .interpolation(ImageInterpolation.High)
}

@Extend(Text)
function userNameStyles() {
  .fontColor($r('sys.color.font_primary'))
  .fontWeight(FontWeight.Medium)
  .fontSize($r('sys.float.Subtitle_L'))
  .textOverflow({
    overflow: TextOverflow.Ellipsis
  })
  .maxLines(1)
}

const TAG = 'UserLogin';

@ComponentV2
export struct UserLogin {
  @Local vm: MinePageVM = MinePageVM.instance;
  @Param userInfoHandler?: Function = undefined
  rowModifier: RowModifier = new RowModifier();


  build() {
    Row({ space: 16 }) {
      Row({ space: 16 }) {
        this.profileImage()
        this.userName()
      }
      .height(64)
      .padding(8)
      .layoutWeight(1)
      .borderRadius(12)
      .attributeModifier(this.rowModifier)
      .onClick(() => {
        if (this.userInfoHandler && this.vm.userInfo.isPhoneAssociated) {
          this.userInfoHandler();
        } else {
          promptAction.showToast({ message: getString('app.string.login_tip'), alignment: Alignment.Center });
        }
      })

      this.accountLink()
    }
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
    .padding(4)
  }

  // 头像
  @Builder
  profileImage() {
    Image((this.vm.userInfo.isPhoneAssociated) ?
      this.vm.localInfo.avatar ? this.vm.localInfo.avatar :
      this.vm.userInfo.avatar : getMedia('app.media.user_login_img'))
      .profileImageStyles()
      .onError((error: ImageError) => {
        Logger.warn(TAG, 'image error')
      })
  }

  // 昵称
  @Builder
  userName() {
    Column() {
      if (this.vm.userInfo.isPhoneAssociated) {
        Text(this.vm.localInfo.nickname ? this.vm.localInfo.nickname : this.vm.userInfo.nickname)
          .userNameStyles()
        Text(getString('app.string.userId', this.vm.userInfo.id ?? ''))
          .fontColor($r('sys.color.font_secondary'))
          .fontWeight(FontWeight.Regular)
          .fontSize($r('sys.float.Body_M'))
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .maxLines(1)
      } else {
        Text(getString('app.string.mine_not_login'))
          .userNameStyles()
      }
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
    .height(48)
    .layoutWeight(1)
  }

  @Builder
  accountLink() {
    if (this.vm.userInfo.isPhoneAssociated){
      Row({ space: 4 }) {
        Image(getMedia('app.media.linked'))
          .height(16)
          .width(16)
        Text(getString('app.string.unlink'))
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.font_primary'))
      }
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
      .margin({ right: 8 })
      .height(28)
      .borderRadius(14)
      .onClick(async () => {
        await AssociateUtil.disassociateAccount(getContext(this));   //  container.resolve(LoginAPI).logout();
      })
    }else {
      Stack() {
        FunctionalButton({
          params: {
            openType: functionalButtonComponentManager.OpenType.GET_PHONE_NUMBER,
            label: '',
            styleOption: {
              plain: true,
              styleConfig: new functionalButtonComponentManager
                .ButtonConfig()
                .height(28)
                .width(92)
                .backgroundColor($r('sys.color.comp_background_tertiary')),
            },
          },
          controller: new functionalButtonComponentManager.FunctionalButtonController()
            .onGetPhoneNumber((err, data) => {
              AssociateUtil.associateAccount(err, data?.code);
            }),
        })
          .zIndex(1)

        Row({ space: 4 }){
          Image(getMedia('app.media.to_link'))
            .height(16)
            .width(16)
          Text(getString('app.string.to_link'))
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Body_M'))
            .fontColor(getColor('app.color.orange'))
        }
      }
      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
      .borderRadius(14)
    }
  }
}

