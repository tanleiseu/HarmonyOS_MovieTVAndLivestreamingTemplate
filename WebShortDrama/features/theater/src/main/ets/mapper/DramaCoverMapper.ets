import { container } from '@agctemplate/utils';
import { RequestAPI } from '@agctemplate/server';
import { DramaCoverVM } from '../viewmodels/DramaCoverVM';

export async function getRankList(category: string, pageNum?: number): Promise<Array<DramaCoverVM>> {
  let instance = container.resolve(RequestAPI)
  let list = (pageNum === undefined) ? (
    await instance.getBillboardDramaPreviewList(category)
  ) : (
    await instance.getBillboardDramaList({
      category: category,
      pageSize: 10,
      pageNum: pageNum!
    })
  )
  const result = list.getBody().data
    .map(cover => {
      const item = new DramaCoverVM()
      item.dramaId = cover.id
      item.imagePath = cover.coverUrl
      item.title = cover.name
      item.content = cover.description
      item.episodes = cover.totalCount
      item.latestUpdate = cover.latestUpdate
      item.rankId = parseInt(cover.id)
      return item
    })
  return Promise.resolve(result)
}

export async function getSearchList(searchText: string, pageNum: number): Promise<Array<DramaCoverVM>> {
  let list = await container.resolve(RequestAPI).getSearchDramaList({
    searchText: searchText,
    pageSize: 10,
    pageNum: pageNum
  })
  const result = list.getBody().data
    .map(cover => {
      const item = new DramaCoverVM()
      item.dramaId = cover.id
      item.imagePath = cover.coverUrl
      item.title = cover.name
      item.content = cover.description
      item.episodes = cover.totalCount
      item.latestUpdate = cover.latestUpdate
      item.rankId = parseInt(cover.id)
      return item
    })
  return Promise.resolve(result)
}

export async function getRecommendList(pageNum: number): Promise<Array<DramaCoverVM>> {
  let list = await container.resolve(RequestAPI).getRecommendDramaList({
    pageSize: 10,
    pageNum: pageNum
  })
  const result = list.getBody().data
    .map(cover => {
      const item = new DramaCoverVM()
      item.dramaId = cover.id
      item.imagePath = cover.coverUrl
      item.title = cover.name
      item.content = cover.description
      item.episodes = cover.totalCount
      item.latestUpdate = cover.latestUpdate
      item.rankId = parseInt(cover.id)
      return item
    })
  return Promise.resolve(result)
}