import { container } from '@agctemplate/utils';
import { RequestAPI } from '@agctemplate/server';
import { CategoryButtonVM } from '../viewmodels/CategoryButtonVM';

export async function getCategoryButtonList(): Promise<Array<CategoryButtonVM>> {
  let categoryList = await container.resolve(RequestAPI).getBillboardCategoryList()
  const result = categoryList.getBody().data.map(category => {
    const btn = new CategoryButtonVM();
    btn.icon = category.icon
    btn.text = category.text
    btn.isSelected = category.isSelected
    return btn
  })
  return Promise.resolve(result)
}