import { container } from '@agctemplate/utils';
import { RequestAPI } from '@agctemplate/server';

export async function getTipInfos(searchText:string): Promise<Array<string>> {
  let list = await container.resolve(RequestAPI).getSearchTipList(searchText)
  return Promise.resolve(list.getBody().data)
}