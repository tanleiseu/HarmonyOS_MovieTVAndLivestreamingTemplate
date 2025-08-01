@ObservedV2
export class DramaCoverVM {
  dramaId: string = ''
  imagePath: ResourceStr = ''
  title: string = ''
  content: string = ''
  // 总集数
  episodes: number = 0
  // 最后一次更新的集数
  latestUpdate: number = 0
  rankId?: number
}