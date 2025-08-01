import { getMedia } from '@agctemplate/resources';
import { Logger } from '@agctemplate/utils';
import { MinePageVM } from '@agctemplate/widgets';
import { FunctionalButton, functionalButtonComponentManager } from '@kit.ScenarioFusionKit';


const TAG = '[AvatarButton]';

@ComponentV2
export struct AvatarButton {
  vm: MinePageVM = MinePageVM.instance;

  build() {
    FunctionalButton({
      params: {
        openType: functionalButtonComponentManager.OpenType.CHOOSE_AVATAR,
        label: '',
        styleOption: {
          styleConfig: new functionalButtonComponentManager.ButtonConfig()
            .type(ButtonType.Normal)
            .backgroundImage(this.vm.localInfo.avatar ? this.vm.localInfo.avatar : this.vm.userInfo.avatar === '' ? getMedia('app.media.user_login_img') :
            this.vm.userInfo.avatar)
            .backgroundImageSize(ImageSize.Cover)
            .backgroundColor(Color.Transparent)
            .width(80)
            .height(80)
            .borderRadius('50%'),
        },
      },
      controller: new functionalButtonComponentManager.FunctionalButtonController().onChooseAvatar((err, data) => {
        if (err) {
          Logger.error(TAG, err.code + '', err.message);
          return;
        }
        if (data.avatarUri) {
          this.vm.updateAvatar(data.avatarUri);
          Logger.info(TAG, 'succeeded in choosing avatar');
        } else {
          Logger.error(TAG, 'Failed: the uri is empty.');
        }
      }),
    })
  }
}