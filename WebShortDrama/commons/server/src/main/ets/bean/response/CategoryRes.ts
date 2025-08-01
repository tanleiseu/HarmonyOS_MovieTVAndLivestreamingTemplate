import { Category } from '../common/Category';
import { RetBean } from '../common/RetBean';

export class CategoryRes {
  ret: RetBean;
  data: Category[];
  total: number;

  constructor(categoryRes?: CategoryRes) {
    this.ret = new RetBean(categoryRes?.ret);
    this.data = (categoryRes?.data || []).map((item) => new Category(item));
    this.total = categoryRes?.total || 0;
  }
}