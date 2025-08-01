export class Category {
  icon: string
  text: string
  isSelected: boolean
  constructor(category: any) {
    this.icon = category?.icon
    this.text = category?.text
    this.isSelected = category?.isSelected
  }
}