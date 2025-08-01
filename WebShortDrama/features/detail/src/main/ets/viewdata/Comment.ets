import { BasicDataSource } from '@agctemplate/video_swiper';

/**
 * 评论属性
 */
@ObservedV2
export class Comment {
  @Trace id?: string; // 评论id
  @Trace avatar?: ResourceStr; // 评论人头像
  @Trace name?: string; // 评论人昵称
  @Trace commentContent?: string; // 评论内容
  @Trace timeAgo?: string | ResourceStr; // 评论时间
  @Trace address?: string; // 评论地址
  @Trace likeCount?: string; // 评论的点赞人数
}


/**
 * 评论数据源
 */
@ObservedV2
export class CommentDataSource extends BasicDataSource {
  private commentArray: Comment[] = [];

  public totalCount(): number {
    return this.commentArray.length;
  }

  /**
   * 获取指定索引数据
   * @param index
   * @returns
   */
  public getData(index: number): Comment {
    return this.commentArray[index];
  }

  /**
   * 改变单个数据
   * @param index
   * @param data
   */
  public addData(index: number, data: Comment): void {
    this.commentArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  /**
   * 添加数据
   * @param data
   */
  public pushData(data: Comment): void {
    this.commentArray.push(data);
    this.notifyDataAdd(this.commentArray.length - 1);
  }
}