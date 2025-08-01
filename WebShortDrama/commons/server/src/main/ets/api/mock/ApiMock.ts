import { MockAdapter } from '@agctemplate/utils';
import { getCommentList } from './mockData/mockCommentList'
import { getEpisodeList } from './mockData/mockEpisodeList';
import {
  getDramaInfo,
  getFavorite,
  getFeedDramaList,
  getWatched,
  setFavorite,
  unsetFavorite
} from './mockData/mockDramaFactory';

// 设置模拟规则
MockAdapter
  .withDelay(100)
  .onPost({
    url: 'https://agc.template.com/mywatchrecord/list'
  }, {
    ret: {
      code: '0'
    },
    total: 3,
    myWatchRecord: getWatched()
  })
  .onPost({
    url: 'https://agc.template.com/myfollowdrama/list'
  }, () => {
    return {
      ret: {
        code: '0'
      },
      total: 3,
      myFollowDramas: getFavorite()
    }
  })
  .onPost({
    url: 'https://agc.template.com/comment/list'
  }, {
    ret: {
      code: '0'
    },
    totalCount: 4,
    commentList: getCommentList()
  })
  .onPost({
    url: 'https://agc.template.com/feeddrama/list'
  }, {
    ret: {
      code: '0'
    },
    total: 3,
    feedDramaList: getFeedDramaList()
  })
  .onPost({
    url: 'https://agc.template.com/episode/list'
  }, (config) => {
    let dramaId = JSON.parse(config.data)
    return {
      ret: {
        code: '0'
      },
      total: 3,
      dramaInfo: getDramaInfo(dramaId),
      episodeList: getEpisodeList()
    }
  })
  .onPost({
    url: 'https://agc.template.com/getaccesstoken'
  }, {
    ret: {
      code: '0'
    },
    accessToken: 'accessToken',
    refreshToken: 'refreshToken',
    expireTime: `${Date.now() + 60 * 60 * 1000}`
  })
  .onPost({
    url: 'https://agc.template.com/getuserinfo'
  }, {
    ret: {
      code: '0'
    },
    id: '123',
    name: '瓜瓜',
    image: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/app-d45y3/avatar%2Fman1.png?token=454d3803-0b69-4fb5-b0d1-33c0f9007d15',
    phone: '133****7890'
  })
  .onPost({
    url: 'https://agc.template.com/setfavorite'
  }, (data) => {
    let dramaId = JSON.parse(data.data)
    setFavorite(dramaId)
    return {
      ret: {
        code: '0'
      }
    }
  })
  .onPost({
    url: 'https://agc.template.com/unsetfavorite'
  }, (data) => {
    let dramaId = JSON.parse(data.data)
    unsetFavorite(dramaId)
    return {
      ret: {
        code: '0'
      }
    }
  })
  .onPost({
    url: 'https://agc.template.com/api/user/associate'
  }, {
    ret: {
      code: '0'
    },
    cellphone: '133****7890'
  })
  .onPost({
    url: 'https://agc.template.com/api/user/disassociate'
  }, {
    ret: {
      code: '0'
    },
    cellphone: '133****7890'
  })
  .onGet({
    url: 'https://agc.template.com/api/user/info'
  }, {
    ret: {
      code: '0'
    },
    userInfo: {
      id: '123',
      nickname: '瓜瓜',
      avatar: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/app-d45y3/avatar%2Fman1.png?token=454d3803-0b69-4fb5-b0d1-33c0f9007d15',
      cellphone: '133****7890',
      isPhoneAssociated: false,
      isMock: false
    }
  })
