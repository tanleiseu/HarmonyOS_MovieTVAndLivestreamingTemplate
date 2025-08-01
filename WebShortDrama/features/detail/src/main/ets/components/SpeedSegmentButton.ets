import { Logger } from '@agctemplate/utils'

const TAG = 'SpeedSegmentButton'

@ObservedV2
export class MyStorage {
  static singleton_: MyStorage;
  static instance() {
    if(!MyStorage.singleton_) {
      MyStorage.singleton_ = new MyStorage();
    };
    return MyStorage.singleton_;
  }
  @Trace index: Map<number,number> = new Map();
}

@ComponentV2
export struct SpeedSegmentButton {
  @Local storage: MyStorage = MyStorage.instance();
  @Consumer('speed') curIndex: number = 0
  @Event onIndexSelect:(index: number) => void = (index: number) => {}
  private speeds: Array<String>  = ['0.5x', '1.0x', '1.25x', '1.5x', '2.0x']

  
  aboutToAppear(): void {
    if (!this.storage.index.has(this.curIndex)) {
      this.storage.index.set(this.curIndex, 1)
    }
  }

  build() {
    Row() {
      ForEach(this.speeds, (speed: string, index: number) => {
        Button(speed)
          .width('20%')
          .height(36)
          .fontSize(14)
          .padding('2px 8px 8px 2px')
          .borderRadius('18px')
          .fontColor(this.storage.index.get(this.curIndex) === index ?
            '#000' : '#9000')
          .backgroundColor(this.storage.index.get(this.curIndex) === index ?
            '#fff' : 'transparent')
          .shadow(this.storage.index.get(this.curIndex) === index ?
            { color:'#3000', radius:3 } : { color:'transparent', radius:0 })
          .onClick(() => {
            this.storage.index.set(this.curIndex, index)
            this.onIndexSelect(index)
            Logger.info(TAG,  `selectedIndex:${this.storage.index.size}`)
          })
      }, (speed: string) => speed)
    }
    .width('100%')
    .height(36)
    .borderRadius(18)
    .backgroundColor('#0d000000')
  }
}
