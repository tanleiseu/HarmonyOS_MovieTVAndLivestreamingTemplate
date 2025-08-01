@ComponentV2
export struct BannerPanel {

  @Param @Require bannerList: Array<string>

  build() {
    Row() {
      Swiper() {
        ForEach(this.bannerList, (banner: string) => {
          Image(banner)
            .height('100%')
            .width('100%')
            .objectFit(ImageFit.Cover)
        }, (banner: string) => banner)
      }
      .width('100%')
      .height('100%')
      .borderRadius(16)
      .loop(false)
      .indicator(
        this.bannerList.length === 1 ? false : (
        Indicator.dot()
          .selectedColor($r('sys.color.alert'))
          .color($r('sys.color.alert'))
        )
      )
    }
    .width('100%')
    .height(184)
    .margin({
      top: 8,
      bottom: 0
    })
  }
}