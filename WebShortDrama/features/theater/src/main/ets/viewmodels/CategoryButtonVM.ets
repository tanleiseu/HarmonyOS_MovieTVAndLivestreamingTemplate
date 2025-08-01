@ObservedV2
export class CategoryButtonVM {
  icon: string = ''
  text: string = ''
  @Trace isSelected: boolean = false
  onclickCallback?: Function
}