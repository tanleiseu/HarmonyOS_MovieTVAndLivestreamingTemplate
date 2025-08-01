export class SocialInfo {
  likeCount: string; //喜欢数量
  favoriteCount: string; //收藏数量
  shareCount: string; //分享数量
  commentCount: string; //评论数量

  constructor(socialInfo: any) {
    this.likeCount = socialInfo?.likeCount
    this.favoriteCount = socialInfo?.favoriteCount
    this.shareCount = socialInfo?.shareCount
    this.commentCount = socialInfo?.commentCount
  }
}