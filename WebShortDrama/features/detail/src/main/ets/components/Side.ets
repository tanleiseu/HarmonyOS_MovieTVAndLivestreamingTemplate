import { AppStorageV2, promptAction } from '@kit.ArkUI';
import { commentBuilder } from './CommentView';
import { ShortDramaDetailItemVM } from '../viewmodels/ShortDramaDetailItemVM';
import { PlayController } from '@agctemplate/video_swiper';
import { getMedia, getString } from '@agctemplate/resources';
import { UserInfoModel } from '@agctemplate/widgets';

const TAG: string = '[Side]'

/**
 * 功能描述：
 * 1. 展示视频播放界面右侧用户头像、视频评论数量、收藏数量、分享数量、作者是否被用户关注等信息
 *
 */
@Preview
@ComponentV2
export struct Side {
  @Param @Require videoDes: ShortDramaDetailItemVM = new ShortDramaDetailItemVM;
  @Param @Require playControl: PlayController;
  @Local isLike: boolean = false; // 是否点赞
  @Local isFavorite: boolean = false; // 是否收藏
  @Local isShowComment: boolean = false
  @Local isCommentShowSheet: boolean = false
  @Local userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, 'userInfo', () => new UserInfoModel())!;

  // 点击点赞按钮的回调函数
  private changeLikeCount(isAdd: boolean) {
    let likeCountNum = Number(this.videoDes.likeCount);
    if (isAdd) {
      likeCountNum++;
    } else {
      likeCountNum--;
    }
    this.videoDes.likeCount = '' + likeCountNum;
    animateTo({ duration: 200, curve: Curve.EaseInOut }, () => {
      this.isLike = !this.isLike;
    })
  }

  // 点击收藏按钮的回调函数
  private changeFavoriteCount(isIncrease: boolean) {
    if (isIncrease) {
      this.videoDes.dramaSocialInfo.setFavor();
    } else {
      this.videoDes.dramaSocialInfo.unsetFavor();
    }
  }

  build() {
    Column() {
      // 4 button
      Row() {
        // 点赞
        Column() {
          Image(!this.isLike ? getMedia('app.media.thumb_unselect') :
          getMedia('app.media.thumb_select'))
            .height(24)
            .width(24)
            .onClick(() => {
              this.changeLikeCount(!this.isLike ? true : false);
            })
            .margin({ bottom: 4 })
          Text(this.videoDes.likeCount)
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_on_primary'))
        }
        .height('%100')
        .margin({ right: 22 })
        .id('fabulousButton')

        // 分享
        Column() {
          Image(getMedia('app.media.share'))
            .height(24)
            .width(24)
            .margin({ bottom: 4 })
            .onClick(() => {
              // 调用Toast显示提示：此样式仅为案例演示
              promptAction.showToast({ message: getString('app.string.demo_toast_tips') });
            })
          Text($r('app.string.shortvideo_share'))
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_on_primary'))
            .onClick(() => {
              // 调用Toast显示提示：此样式仅为案例演示
              promptAction.showToast({ message: getString('app.string.demo_toast_tips') });
            })
        }
        .height('%100')
        .margin({ right: 22 })
        .id('shareButton')

        // 收藏
        Column() {
          Image(!this.videoDes.dramaSocialInfo.isFavorite ? getMedia('app.media.favorite_unselect') :
          getMedia('app.media.favorite_select'))
            .height(24)
            .width(24)
            .onClick(() => {
              if (this.userInfo.isPhoneAssociated) {
                this.changeFavoriteCount(!this.videoDes.dramaSocialInfo.isFavorite ? true : false);
              } else {
                promptAction.showToast({ message: getString('app.string.comment_tip') });
              }
            })
            .margin({ bottom: 4 })
          Text(`${this.videoDes.dramaSocialInfo.favoriteCount}`)
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_on_primary'))
        }
        .height('%100')
        .margin({ right: 22 })
        .id('favoriteButton')

        // 评论
        Column() {
          Image(getMedia('app.media.comment'))
            .height(24)
            .width(24)
            .margin({ bottom: 4 })
          Text(this.videoDes.commentCount)
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_on_primary'))
        }
        .height('%100')
        .onClick(() => {
          this.isShowComment = !this.isShowComment
        })
        .bindSheet($$this.isShowComment,
          commentBuilder(this.videoDes.dramaInfo.id, Number(this.videoDes.currentSerial), (count: number) => {
            this.videoDes.commentCount = count.toString()
          }), {
            detents: [SheetSize.MEDIUM, SheetSize.MEDIUM, 400],
            preferType: SheetType.BOTTOM,
            title: {
              title: getString('app.string.comment_count', this.videoDes.commentCount)
            },
            onWillDisappear: () => {
              this.isShowComment = !this.isShowComment;
            },
            backgroundColor: Color.White
          })
        .id('comment_button')
      }
      .width(190)
      .height(56)
      .justifyContent(FlexAlign.SpaceAround)
      .padding({ left: 14, right: 14 })
    }
  }
}