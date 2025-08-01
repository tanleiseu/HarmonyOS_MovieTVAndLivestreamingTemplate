import { TabHeaderInfo, TabInfoRegister } from '@agctemplate/frame';
import { HomeMainPageBuilder } from '@agctemplate/home';
import { MineMainPageBuilder } from '@agctemplate/mine';
import { TheaterMainPageBuilder } from '@agctemplate/theater'
import { appRouter, deepEqual, NavRouterActionType, navStackActionOptions } from '@agctemplate/utils';
import '@agctemplate/resources';
import '@agctemplate/login';
import { getMedia, getString, NAV_PAGE_NAME } from '@agctemplate/resources';

@Entry
@ComponentV2
struct Index {
  navPathStack: NavPathStack = new NavPathStack();
  navStackAction: (actionType: NavRouterActionType, options: navStackActionOptions) => boolean =
    (actionType: NavRouterActionType, options: navStackActionOptions) => {
      switch (actionType) {
        case NavRouterActionType.PUSH:
          let allPathName = this.navPathStack.getAllPathName();
          if (allPathName.length > 0 && allPathName[allPathName.length-1] === options.name &&
          deepEqual(this.navPathStack.getParamByIndex(allPathName.length - 1), options.params)) {
            this.navPathStack.replacePathByName(options.name, options.params, options.animated)
          } else {
            this.navPathStack.pushPathByName(options.name, options.params, options.popCallback, options.animated)
          }
          return true;
        case NavRouterActionType.REPLACE:
          this.navPathStack.replacePathByName(options.name, options.params, options.animated)
          return true;
        case NavRouterActionType.POP:
          if (this.navPathStack.size() <= 1) {
            appRouter.back(false);
            return true;
          }
          if (options.name) {
            options.params ? this.navPathStack.popToName(options.name, options.params, options.animated) :
            this.navPathStack.popToName(options.name, options.animated)
          } else {
            options.params ? this.navPathStack.pop(options.params, options.animated) :
            this.navPathStack.pop(options.animated)
          }
          return true;
        default:
          return false;
      }
    }

  aboutToAppear() {
    appRouter.setNavStackAction(this.navStackAction);
    appRouter.setNavPathStack(this.navPathStack);
    this.initMainPageContent();
    appRouter.push({
      builderName: NAV_PAGE_NAME.MainTabPage.name
    })
  }

  build() {
    Navigation(this.navPathStack) {
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .width('100%')
    .height('100%')
  }

  initMainPageContent() {
    TabInfoRegister.tabInfos = [{
      tabHeaderInfo: new TabHeaderInfo(getString('app.string.home'), false,
        getMedia('app.media.home_select'), getMedia('app.media.home_unselect'),
        getMedia('app.media.home_unselect_dark')),
      tabContentBuilder: wrapBuilder(HomeMainPageBuilder)
    }, {
      tabHeaderInfo: new TabHeaderInfo(getString('app.string.theater'), false,
        getMedia('app.media.theater_select'), getMedia('app.media.theater_unselect'),
        getMedia('app.media.theater_unselect_dark')),
      tabContentBuilder: wrapBuilder(TheaterMainPageBuilder)
    }, {
      tabHeaderInfo: new TabHeaderInfo(getString('app.string.mine'), false,
        getMedia('app.media.mine_select'), getMedia('app.media.mine_unselect'),
        getMedia('app.media.mine_unselect_dark')),
      tabContentBuilder: wrapBuilder(MineMainPageBuilder)
    }];
  }
}