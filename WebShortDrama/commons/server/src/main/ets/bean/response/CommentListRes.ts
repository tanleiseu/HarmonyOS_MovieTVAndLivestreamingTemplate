import { CommentInfo } from '../common/CommentInfo';
import { RetBean } from '../common/RetBean';

export class CommentListRes {
  ret: RetBean;
  commentList: CommentInfo[];
  totalCount:number;

  constructor(commentInfoRes?: CommentListRes) {
    this.ret = new RetBean(commentInfoRes?.ret);
    this.commentList = (commentInfoRes?.commentList || []).map((item) => new CommentInfo(item));
    this.totalCount = commentInfoRes?.totalCount || 0
  }
}