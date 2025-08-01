import { getString } from '@agctemplate/resources';
import { CommentListRes, RequestAPI } from '@agctemplate/server';
import { CommentInfo } from '@agctemplate/server';
import { container, Logger } from '@agctemplate/utils';
import { AppStorageV2, ComponentContent, promptAction } from '@kit.ArkUI';
import { Comment, CommentDataSource } from '../viewdata/Comment';
import { BusinessError } from '@kit.BasicServicesKit';
import { commentInputDialogBuilder } from './CommentInputDialog';
import { AiBarHeight, AppStorageKeys, NavDestinationModifier, UserInfoModel } from '@agctemplate/widgets'

const TAG = '[CommentView]'


/**
 * 单条评论布局（预览）
 */
@Preview
@ComponentV2
export struct PreviewCommentView {
  comment: Comment = {
    avatar: $r('app.media.shortvideo_38'),
    name: 'test',
    commentContent: '没有看到后续',
    timeAgo: '3小时前',
    address: '广州',
    likeCount: '100'
  };

  build() {
    CommentView({ comment: this.comment })
  }
}

/**
 * 单条评论布局
 */
@ComponentV2
export struct CommentView {
  // 评论
  @Param @Require comment: Comment = new Comment()

  build() {
    Row({ space: 8 }) {

      Image(this.comment.avatar)
        .width(16)
        .height(16)

      Column({ space: 8 }) {
        Text(this.comment.name)
          .fontSize($r('sys.float.Body_S'))
          .fontColor($r('sys.color.font_secondary'))
          .width('100%')

        Text(this.comment.commentContent)
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.font_primary'))
          .width('100%')

        Row() {
          Row({ space: 8 }) {
            Text(this.comment.timeAgo)
              .fontSize($r('sys.float.Caption_M'))
              .fontColor($r('sys.color.font_tertiary'))
              .height(16)
            Text(this.comment.address)
              .fontSize($r('sys.float.Caption_M'))
              .fontColor($r('sys.color.font_tertiary'))
              .height(16)
          }

          Row({ space: 4 }) {
            SymbolGlyph($r('sys.symbol.hand_thumbsup'))

            Text(this.comment.likeCount)
              .fontSize($r('sys.float.Caption_M'))
              .fontColor($r('sys.color.font_secondary'))
          }
        }.width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
    }
    .alignItems(VerticalAlign.Top)
  }
}

/**
 * 评论组件（预览）
 */
@Preview
@ComponentV2
export struct PreviewCommentComponent {
  build() {
    CommentComponent({ dramaId: 'drama1', episodeIndex: 0 })
  }
}

/**
 * 评论组件
 */
@ComponentV2
export struct CommentComponent {
  @Param @Require dramaId: string
  @Param @Require episodeIndex: number
  @Local aiBarHeight: AiBarHeight = AppStorageV2.connect(AiBarHeight, AppStorageKeys.AI_BAR_HEIGHT,
    () => new AiBarHeight())!;
  @Local loginStatus: boolean = false
  @Local httpSuccess: boolean = true
  @Local userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, 'userInfo', () => new UserInfoModel())!;
  @Local localInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, 'localInfo', () => new UserInfoModel())!;
  @Param userInfoHandler?: Function = undefined
  @Event onCommentCountChange: (count: number) => void = (count: number) => {
  }
  navDestinationModifier: NavDestinationModifier = new NavDestinationModifier();
  listScroll: ListScroller = new ListScroller();
  commentData: CommentDataSource = new CommentDataSource();
  private contentNode: ComponentContent<Object> =
    new ComponentContent(this.getUIContext(), wrapBuilder(commentInputDialogBuilder), (textComment: string) => {
      this.publishComment(textComment)
    });

  // 发布评论
  publishComment(textComment: string): void {
    if (this.contentNode !== null) {
      this.getUIContext()
        .getPromptAction()
        .closeCustomDialog(this.contentNode)
        .then(() => {
          Logger.info(TAG, 'CloseCustomDialog complete.')
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`CloseCustomDialog args error code is ${code}, message is ${message}`);
        })
    }
    const comment: Comment = {
      name: this.localInfo.nickname ? this.localInfo.nickname : this.userInfo.nickname,
      commentContent: textComment,
      timeAgo: getString('app.string.time_now'),
      avatar: this.localInfo.avatar ? this.localInfo.avatar : this.userInfo.avatar
    }
    this.commentData.addData(0, comment);
    this.listScroll.scrollToIndex(0, true, ScrollAlign.START);
    this.onCommentCountChange(this.commentData.totalCount())
  }

  aboutToAppear(): void {
    container.resolve(RequestAPI).getCommentList({
      pageSize: 1,
      pageNum: 20
    }).then((res) => {
      let commentListRes: CommentListRes = new CommentListRes(res.getBody())
      commentListRes.commentList?.map((commentInfo: CommentInfo) => {
        this.commentData.pushData({
          id: commentInfo.id ?? '',
          avatar: commentInfo.avatar ?? '',
          name: commentInfo.name ?? '',
          commentContent: commentInfo.commentContent ?? '',
          timeAgo: commentInfo.timeAgo ?? '',
          address: commentInfo.address ?? '',
          likeCount: commentInfo.likeCount ?? '',
        })
      })
      this.onCommentCountChange(this.commentData.totalCount())
    }).catch((error: Error) => {
      Logger.info(TAG, `get comment list failed:${error.message}`)
    })
  }

  openDialog() {
    this.getUIContext().getPromptAction().openCustomDialog(this.contentNode, {
      onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
        Logger.info(TAG, 'reason' + JSON.stringify(dismissDialogAction.reason))
        if (dismissDialogAction.reason === DismissReason.PRESS_BACK) {
          dismissDialogAction.dismiss()
        }
        if (dismissDialogAction.reason === DismissReason.TOUCH_OUTSIDE) {
          dismissDialogAction.dismiss()
        }
      },
      alignment: DialogAlignment.Bottom
    })
      .catch((error: BusinessError) => {
        Logger.error(TAG, `openCustomDialog error code is ${error.code}, message is ${error.message}`)
      })
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Row() {
          List({ scroller: this.listScroll, space: 12 }) {
            LazyForEach(this.commentData, (item: Comment, index) => {
              ListItem() {
                CommentView({ comment: item })
                  .onClick(() => {
                    // 调用Toast显示提示：此样式仅为案例演示
                    promptAction.showToast({ message: getString('app.string.demo_toast_tips') });
                  })
              }.margin({ left: 16, right: 16 })
            }, (item: Comment) => item.id)
          }
          .id('comment_list')
          .width('100%')
          .height('100%');
        }.layoutWeight(1)

        Row() {
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
            Button(getString('app.string.commit_comment'))
              .backgroundColor($r('sys.color.comp_background_tertiary'))
              .width('100%')
              .borderRadius(24)
              .height(40)
              .borderRadius(24)
              .fontSize($r('sys.float.Body_L'))
              .fontColor($r('sys.color.font_secondary'))
              .align(Alignment.Start)
              .onClick(() => {
                if (this.userInfo.isPhoneAssociated) {
                  this.openDialog()
                } else {
                  promptAction.showToast({ message: getString('app.string.comment_tip') });
                }
              })
          }
          .width('100%')

        }.margin({ left: 16, right: 16 })
        .height(62)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .backgroundColor(Color.White)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .margin({ bottom: `${px2vp(this.aiBarHeight.value)}vp` })
  }
}

@Builder
export
function
commentBuilder(dramaId: string, episodeIndex: number, onCommentCountChange: (count: number) => void) {
  CommentComponent({ dramaId: dramaId, episodeIndex: episodeIndex, onCommentCountChange: onCommentCountChange })
}