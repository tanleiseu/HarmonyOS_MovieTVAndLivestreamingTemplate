import { Comment } from './bean';
let commentList: Array<Comment> = [
  {
    id: '1',
    avatar: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/app-d45y3/avatar/woman1.png',
    name: '小美',
    commentContent: '非常好，加1',
    timeAgo: '1天前',
    address: '北京',
    likeCount: '101'
  },
  {
    id: '2',
    avatar: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/app-d45y3/avatar/woman2.png',
    name: '大美',
    commentContent: '非常好，加2',
    timeAgo: '2天前',
    address: '南京',
    likeCount: '8'
  },
  {
    id: '3',
    avatar: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/app-d45y3/avatar/man1.png',
    name: '小强',
    commentContent: '我猛然一看，就猛然看到这个回答，我直呼我直呼，上次看到这么这么的回答还是上次，这回答属于是典型的典型了属于是，我之前还没发现，当我发现的时候我已经发现了，这回答就像一个回答，回答的内容充满了内容，我不禁感慨了一句感慨，真是听君一席话，如听一席话，希望下次看到这么这么的回答是下次。',
    timeAgo: '3天前',
    address: '布宜诺斯艾利斯',
    likeCount: '6'
  },
  {
    id: '4',
    avatar: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/app-d45y3/avatar/man2.png',
    name: '大壮',
    commentContent: '非常好，加4',
    timeAgo: '4天前',
    address: '美国',
    likeCount: '102'
  }
]

export const getCommentList = (): Array<Comment> => {
  return commentList;
}