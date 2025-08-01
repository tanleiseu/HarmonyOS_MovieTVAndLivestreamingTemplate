import { PageReq } from "./PageReq";

export class DramaPageReq extends PageReq {
  category: string = ''
  constructor(pageReq: any) {
    super({
      pageSize: pageReq?.pageSize,
      pageNum: pageReq?.pageNum
    })
    this.category = pageReq.category
  }
}