export interface Comment {
  id: string;
  avatar: string;
  name: string;
  commentContent: string;
  timeAgo: string;
  address: string;
  likeCount: string;
}

export interface Episode {
  id: number;
  url: string;
  desc: string;
  dramaId: string;
  socialInfo: {
    likeCount: string;
    favoriteCount: string;
    shareCount: string;
    commentCount: string;
  }
}

export interface ActorInfo {
  id: string;
  name: string;
  avatar: string;
}

export interface Drama {
  id: string;
  coverUrl: string;
  promotionalUrl: string;
  name: string;
  description: string;
  totalCount: number;
  latestUpdate: number;
  category: string;
  actorInfo: Array<ActorInfo>
  curIndex: number
  popular:string
  favoriteCount:number
  isFavorite:boolean
}