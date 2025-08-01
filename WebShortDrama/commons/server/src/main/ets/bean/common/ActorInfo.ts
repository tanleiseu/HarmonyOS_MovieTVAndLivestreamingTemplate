export class ActorInfo {
  id: string
  name: string; // 名称
  avatar: string; // 头像

  constructor(actorInfo: any) {
    this.id = actorInfo?.id
    this.name = actorInfo?.name
    this.avatar = actorInfo?.avatar
  }
}