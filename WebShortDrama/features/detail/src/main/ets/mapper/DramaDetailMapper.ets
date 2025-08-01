import { CommentDataSource } from '../viewdata/Comment';
import { ShortDramaDetailItemVM } from '../viewmodels/ShortDramaDetailItemVM';
import { CommentListRes } from '@agctemplate/server'
import { CommentInfo } from '@agctemplate/server';
import { EpisodeInfo } from '@agctemplate/server';
import { DetailVideoData } from '../models/DetailVideoData';

export function mapCommentInfo(commentListRes: CommentListRes): CommentDataSource {
  let commentDataSource: CommentDataSource = new CommentDataSource()
  commentListRes.commentList?.map((commentInfo: CommentInfo) => {
    commentDataSource.pushData({
      id: commentInfo.id ?? '',
      avatar: commentInfo.avatar ?? '',
      name: commentInfo.name ?? '',
      commentContent: commentInfo.commentContent ?? '',
      timeAgo: commentInfo.timeAgo ?? '',
      address: commentInfo.address ?? '',
      likeCount: commentInfo.likeCount ?? '',
    })
  })
  return commentDataSource;
}

export function mapEpisodeInfo(episodeInfo: EpisodeInfo): DetailVideoData {
  let shortDramaDetailItemVM: ShortDramaDetailItemVM = new ShortDramaDetailItemVM()
  shortDramaDetailItemVM.url = episodeInfo?.url || ''
  shortDramaDetailItemVM.dramaInfo.id = episodeInfo?.dramaId || ''
  shortDramaDetailItemVM.dramaInfo.description = episodeInfo?.desc || ''
  shortDramaDetailItemVM.likeCount = episodeInfo?.socialInfo?.likeCount || ''
  shortDramaDetailItemVM.favoriteCount = episodeInfo?.socialInfo?.favoriteCount || ''
  shortDramaDetailItemVM.shareCount = episodeInfo?.socialInfo?.shareCount || ''
  shortDramaDetailItemVM.commentCount = episodeInfo?.socialInfo?.commentCount || ''
  shortDramaDetailItemVM.currentSerial = episodeInfo?.id || 0
  shortDramaDetailItemVM.dramaInfo.totalCount = episodeInfo?.totalCount || 0
  let videoPlayData: DetailVideoData = new DetailVideoData(shortDramaDetailItemVM)
  return videoPlayData;
}
