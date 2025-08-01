import { container } from '@agctemplate/utils';

import { RequestAPI } from './src/main/ets/api/RequestAPI';

export * from './src/main/ets/bean/response/MyFollowDramaRes';

export * from './src/main/ets/bean/response/MyWatchRecordRes';

export * from './src/main/ets/bean/response/CommentListRes';

export * from './src/main/ets/bean/response/DramaListRes';

export * from './src/main/ets/bean/response/EpisodeListRes';

export { RequestAPI } from './src/main/ets/api/RequestAPI';

export { FloorBean } from './src/main/ets/bean/common/FloorBean';

export { DramaInfo } from './src/main/ets/bean/common/DramaInfo';

export { EpisodeInfo } from './src/main/ets/bean/common/EpisodeInfo';

export { CommentInfo } from './src/main/ets/bean/common/CommentInfo';

container.register(RequestAPI, {
  value: new RequestAPI()
});
