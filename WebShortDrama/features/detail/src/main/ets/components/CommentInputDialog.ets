import { getString } from '@agctemplate/resources';
import { AiBarHeight, AppStorageKeys, StatusBarHeight } from '@agctemplate/widgets';
import { AppStorageV2 } from '@kit.ArkUI';

const ID_TEXT_INPUT: string = 'id_image_comment_text_input';
const ID_TEXT_PUSH: string = 'id_image_comment_text_publish';

@Preview
@ComponentV2
export struct CommentInputDialog {
  @Local aiBarHeight: AiBarHeight = AppStorageV2.connect(AiBarHeight, AppStorageKeys.AI_BAR_HEIGHT,
    () => new AiBarHeight())!;
  @Local statusBarHeight: StatusBarHeight = AppStorageV2.connect(StatusBarHeight, AppStorageKeys.STATUS_BAR_HEIGHT,
    () => new StatusBarHeight())!;
  // 输入的文字
  @Local text: string | ResourceStr = '';
  @Local textInComment: string = '';
  // 发布接口，用于主页面更新评论数据
  @Event onPublish: Function = (textComment: string): void => {
  }
  placeHolderText:Resource = getString('app.string.commit_comment')

  build() {
    Column() {
      RelativeContainer() {
        TextInput({ placeholder: this.placeHolderText, text: this.textInComment })
          .height(40)
          .padding({
            left: 10,
            right: 50,
            top: 3,
            bottom: 3
          })
          .margin({
            right: 10
          })
          .onChange((value: string) => {
            this.textInComment = value;
          })
          .defaultFocus(true)
          .alignRules({
            // 性能知识点：使用相对布局组件RelativeContainer，子组件通过alignRules接口将父组件或者其他组件设为锚点，可使布局扁平化，有利于性能提升
            top: { anchor: '__container__', align: VerticalAlign.Top },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            right: { anchor: ID_TEXT_PUSH, align: HorizontalAlign.Start }
          })
          .id(ID_TEXT_INPUT)
        Button(getString('app.string.publish'))
          .width(60)
          .height(30)
          .borderRadius(15)
          .backgroundColor('#be1d1d')
          .fontColor(Color.White)
          .onClick(() => {
            this.text = this.textInComment;
            this.textInComment = '';
            this.onPublish(this.text);
          })
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            right: { anchor: '__container__', align: HorizontalAlign.End }
          })
          .id(ID_TEXT_PUSH)
      }
      .height(50)
      Blank()
        .height(20)
    }
    .padding({
      top: 10,
      left: 10,
      right: 10,
      bottom: px2vp(this.aiBarHeight.value)
    })
    .backgroundColor(Color.White)
    .offset({
      y: 20
    })
  }
}

@Builder
export function commentInputDialogBuilder(onPublishComment: Function) {
  CommentInputDialog({ onPublish: onPublishComment })
}
