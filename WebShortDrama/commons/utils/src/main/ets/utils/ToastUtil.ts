import promptAction from '@ohos.promptAction';

// 短消息提示时长
const SHORT_TIME = 2000;
// 长消息提示时长
const LONG_TIME = 3500;

export class ToastUtil {
  private constructor() {
  }

  /**
   * 短消息提示
   * @param {string} content 提示内容
   */
  public static shortToast(content: string | Resource, distance?: number): void {
    promptAction.showToast({
      message: content,
      duration: SHORT_TIME,
      bottom: distance,
    });
  }

  /**
   * 长消息提示
   * @param {string} content
   */
  public static longToast(content: string | Resource): void {
    promptAction.showToast({
      message: content,
      duration: LONG_TIME,
    });
  }
}

