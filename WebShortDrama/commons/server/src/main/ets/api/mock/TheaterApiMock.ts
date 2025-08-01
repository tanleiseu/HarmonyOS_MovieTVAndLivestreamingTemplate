import { MockAdapter } from '@agctemplate/utils';
import { DramaInfo } from '../../bean/common/DramaInfo';
import { getDramaByName, getDramas, getOneDrama } from './mockData/mockDramaFactory';

function random(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1) + min)
}

// 初始化数据
const generateDramaList = (length: number): Array<DramaInfo> => {
  const result = []
  for (let i = 0; i < length; i++) {
    let totalCount = random(40, 120)
    let drama = getOneDrama();
    result.push({
      id: drama.id,
      coverUrl: drama.coverUrl,
      name: drama.name,
      description: drama.description,
      totalCount: totalCount,
      latestUpdate: i % 3 === 0 ? totalCount : random(1, totalCount)
    })
  }
  return result
}


const recommendList: Array<DramaInfo> = generateDramaList(25)
const thumbUpList: Array<DramaInfo> = generateDramaList(50)
const hotList: Array<DramaInfo> = generateDramaList(60)
const newList: Array<DramaInfo> = generateDramaList(40)
const searchList: Array<DramaInfo> = generateDramaList(50)

// 类别
MockAdapter
  .onGet({
    url: 'https://agc.template.com/theater/category'
  }, {
    ret: {
      code: '0'
    },
    total: 3,
    data: [
      {
        icon: 'thumb_up', text: '必看榜', isSelected: true
      },
      {
        icon: 'hot', text: '热播榜', isSelected: false,
      },
      {
        icon: 'film', text: '新剧榜', isSelected: false
      }
    ]
  })
  .withDelay(100);

function getDramaList(param: any): Array<DramaInfo> {
  let category: string = param.category
  let pageNum: number = param.pageNum
  let pageSize: number = param.pageSize
  const resultList = category === '必看榜' ? thumbUpList : (category === '热播榜' ? hotList : newList)
  if ((pageNum - 1) * pageSize > resultList.length) {
    // 超过范围了
    return []
  } else {
    return resultList.slice((pageNum - 1) * pageSize, Math.min(pageNum * pageSize, resultList.length))
  }
}

// 排行榜查询 全部
MockAdapter
  .onGet({
    url: 'https://agc.template.com/theater/billboard'
  }, (config) => {
    let param = JSON.parse(config.data)
    let resultList = getDramaList(param)
    return {
      ret: {
        code: '0'
      },
      total: resultList.length,
      data: resultList
    }
  })
  .withDelay(100);

// 排行榜查询 只显示一部分
MockAdapter
  .onGet({
    url: 'https://agc.template.com/theater/billboard/preview'
  }, (config) => {
    let category = JSON.parse(config.data)
    let resultList = category === '必看榜' ? thumbUpList : (category === '热播榜' ? hotList : newList)
    resultList = resultList.slice(0, Math.min(6, resultList.length))
    return {
      ret: {
        code: '0'
      },
      total: resultList.length,
      data: resultList
    }
  })
  .withDelay(100);

// 优选短剧
MockAdapter
  .onGet({
    url: 'https://agc.template.com/theater/recommend'
  }, (config) => {
    let param = JSON.parse(config.data)
    let pageNum: number = param.pageNum
    let pageSize: number = param.pageSize
    let resultList = []
    if ((pageNum - 1) * pageSize > recommendList.length) {
      // 超过范围了
    } else {
      resultList = recommendList.slice((pageNum - 1) * pageSize, Math.min(pageNum * pageSize, recommendList.length))
    }
    return {
      ret: {
        code: '0'
      },
      total: resultList.length,
      data: resultList
    }
  })
  .withDelay(100);

// 搜索
MockAdapter
  .onGet({
    url: 'https://agc.template.com/theater/search'
  }, (config) => {
    let param = JSON.parse(config.data)
    let pageNum: number = param.pageNum
    let pageSize: number = param.pageSize
    let searchText: string = param.searchText
    let searchList = []
    let resultList = []
    getDramas().forEach((name: string) => {
      if (name.indexOf(searchText) !== -1) {
        searchList.push(getDramaByName(name))
      }
    })

    if ((pageNum - 1) * pageSize > searchList.length) {
      // 超过范围了
      // return []
    } else {
      resultList = searchList.slice((pageNum - 1) * pageSize, Math.min(pageNum * pageSize, searchList.length))
    }
    return {
      ret: {
        code: '0'
      },
      total: resultList.length,
      data: resultList
    }
  })
  .withDelay(100);

// 优选短剧
MockAdapter
  .onGet({
    url: 'https://agc.template.com/theater/search/tip'
  }, (config) => {
    let searchText = JSON.parse(config.data)

    let searchTips = []
    if (searchText) {
      getDramas().forEach((name: string) => {
        if (name.indexOf(searchText) !== -1) {
          searchTips.push(name)
        }
      })
    }

    return {
      ret: {
        code: '0'
      },
      total: searchTips.length,
      data: searchTips
    }
  })
  .withDelay(100);

// 剧场界面展示的Banner
MockAdapter
  .onGet({
    url: 'https://agc.template.com/theater/banner'
  }, {
    ret: {
      code: '0'
    },
    total: 6,
    data: [
      'https://agc-storage-drcn.platform.dbankcloud.cn/v0/app-d45y3/banner.png',
      'https://agc-storage-drcn.platform.dbankcloud.cn/v0/app-d45y3/banner.png',
      'https://agc-storage-drcn.platform.dbankcloud.cn/v0/app-d45y3/banner.png'
    ]
  })
  .withDelay(100);