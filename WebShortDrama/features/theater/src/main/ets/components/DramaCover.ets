import { getColor, getString } from '@agctemplate/resources'
import { DramaCoverVM } from '../viewmodels/DramaCoverVM'

export function getCoverEpisodeShowText(isEnd: boolean, episodes: number, latestUpdate: number) {
  return isEnd ? getString('app.string.cover_episode_info', episodes.toString()) :
  getString('app.string.cover_update_info', latestUpdate.toString())
}

function getCoverEpisodeStateText(isEnd: boolean) {
  return isEnd ? getString('app.string.cover_state_end') : getString('app.string.cover_state_update')
}

function getRankBackgroundColor(rankId?: number): Resource {
  switch (rankId) {
    case 1:
      return getColor('app.color.billboard_rank_top')
    case 2:
      return getColor('app.color.billboard_rank_next')
    case 3:
      return getColor('app.color.billboard_rank_third')
    default:
      return getColor('app.color.billboard_rank_other')
  }
}

@ComponentV2
export struct DramaCover {

  @Param @Require drama: DramaCoverVM
  @Param @Require index: number
  @Param @Require isVertical: boolean

  build() {
    Column() {
      Row() {
        Column() {
          Stack() {
            Text(this.index.toString())
              .padding({
                top: 1,
                right: 8,
                bottom: 1,
                left: 8
              })
              .fontSize(10)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Medium)
              .borderRadius({
                topLeft: 8, bottomRight: 8
              })
              .backgroundColor(getRankBackgroundColor(this.index))
              .zIndex(100)
            Image(this.drama.imagePath)
              .width(this.isVertical ? 68 : 48)
              .height(this.isVertical ? 90 : 64)
              .borderRadius(8)
          }
          .alignContent(Alignment.TopStart)
        }

        Column() {
          Row() {
            Text(this.drama.title)
              .maxLines(this.isVertical ? 1 : 2)
              .fontSize(this.isVertical ? 16 : 14)
              .fontWeight(FontWeight.Medium)
          }
          .height(this.isVertical ? 21 : 38)
          .margin({
            bottom: this.isVertical ? 0 : 10
          })
          .alignItems(VerticalAlign.Top)

          if (this.isVertical) {
            Row() {
              Text(this.drama.content)
                .maxLines(2)
                .fontSize(12)
                .fontColor(getColor('app.color.normal_font_color'))
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .height(38)
            .margin({
              top: 8, bottom: 8
            })
          }

          Row() {
            Column() {
              Text(getCoverEpisodeStateText(this.drama.episodes === this.drama.latestUpdate))
                .fontSize(12)
                .fontColor(getColor('app.color.normal_font_color'))
            }

            Column() {
              Text(getString('app.string.cover_episode', this.drama.episodes.toString()))
                .fontSize(12)
                .fontColor(getColor('app.color.normal_font_color'))
                .margin({
                  left: 4
                })
            }
          }
          .width(84)
        }
        .width(this.isVertical ? 244 : 84)
        .margin({
          left: this.isVertical ? 16 : 8
        })
        .alignItems(HorizontalAlign.Start)
      }
      .alignItems(VerticalAlign.Top)
    }
    .alignItems(HorizontalAlign.Start)
  }
}