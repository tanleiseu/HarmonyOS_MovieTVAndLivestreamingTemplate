export class CommentInfo {
  id: string; // 评论id
  avatar: string; // 评论人头像
  name: string; // 评论人昵称
  commentContent: string; // 评论内容
  timeAgo: string; // 评论时间
  address: string; // 评论地址
  likeCount: string; // 评论的点赞人数

  constructor(commentInfo: any) {
    this.id = commentInfo?.id
    this.avatar = commentInfo?.avatar
    this.name = commentInfo?.name
    this.commentContent = commentInfo?.commentContent
    this.timeAgo = commentInfo?.timeAgo
    this.address = commentInfo?.address
    this.likeCount = commentInfo?.likeCount
  }
}