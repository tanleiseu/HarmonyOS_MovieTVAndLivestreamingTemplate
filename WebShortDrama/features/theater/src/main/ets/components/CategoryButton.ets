import { getColor, getMedia } from '@agctemplate/resources'
import { CategoryButtonVM } from '../viewmodels/CategoryButtonVM'

@ComponentV2
export struct CategoryButton {

  @Param @Require options: CategoryButtonVM
  @Event onClickCallback: Function = () => {}

  defaultIcon(icon: string): ResourceStr {
    return getMedia(`app.media.${icon}_black`)
  }

  selectedIcon(icon: string): ResourceStr {
    return getMedia(`app.media.${icon}_white`)
  }

  getBtnTextColor(isSelected: boolean): Resource {
    return isSelected ? getColor('app.color.category_selected_text') : getColor('app.color.category_text')
  }

  getBtnBackgroundColor(isSelected: boolean): Resource {
    return isSelected ? getColor('app.color.category_selected_background') : getColor('app.color.category_background')
  }

  build() {
    Column() {
      Row() {
        Column() {
          Image(this.options.isSelected ? this.selectedIcon(this.options.icon) : this.defaultIcon(this.options.icon))
            .width(16)
            .height(16)
            .margin({
              right: 4
            })
        }

        Column() {
          Text(this.options.text)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.getBtnTextColor(this.options.isSelected))
        }
      }
      .alignItems(VerticalAlign.Center)
    }
    .padding({
      top: 10,
      right: 12,
      bottom: 10,
      left: 12
    })
    .height(36)
    .borderRadius(21)
    .backgroundColor(this.getBtnBackgroundColor(this.options.isSelected))
    .onClick(() => {
      this.onClickCallback(this.options)
    })
  }
}