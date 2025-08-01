import { TabHeaderInfo } from './src/main/ets/view/components/tabs/TabItem';

export { TabHeaderInfo } from './src/main/ets/view/components/tabs/TabItem';

export interface TabInfo {
  tabHeaderInfo: TabHeaderInfo;
  tabContentBuilder: WrappedBuilder<[number]>;
}

export class TabInfoRegister {
  static tabInfos: TabInfo[] = [];
}
