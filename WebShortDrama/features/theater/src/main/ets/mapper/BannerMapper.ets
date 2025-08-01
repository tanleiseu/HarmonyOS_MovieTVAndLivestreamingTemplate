import { container } from '@agctemplate/utils';
import { RequestAPI } from '@agctemplate/server';

export async function getBannerList(): Promise<Array<string>> {
  let list = await container.resolve(RequestAPI).getBannerList()
  return Promise.resolve(list.getBody().data)
}