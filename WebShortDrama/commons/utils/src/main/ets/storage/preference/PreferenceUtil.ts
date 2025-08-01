import dataPreferences from '@ohos.data.preferences';
import { Logger } from "../../logger/AppLogger";
import { Context } from '@kit.AbilityKit';
import { CryptoUtil } from '../../utils/CryptoUtil';

const TAG = 'PreferenceManager';
const DEFAULT_STORE_NAME: string = "defaultStore";

export class PreferenceUtil {
  private static cachedPreferences: Map<string, dataPreferences.Preferences> = new Map();

  private constructor() {
  }

  /**
   * @description 根据key异步获取首选项中存的值
   * @param context: context
   * @param storeName: storeName
   * @param key: 首选项的键值
   */
  public static async getValue(context: Context, storeName: string,
    key: string): Promise<dataPreferences.ValueType | null> {
    try {
      let store = await this.getStore(context, storeName);
      this.updateStoreCache(storeName, store);
      const result = await store.get(key, '');
      Logger.debug(TAG, `getValue from ${storeName} with key:${key} and value:${result}`);
      return result;
    } catch (err) {
      Logger.error(TAG,
        `getValue from ${storeName} error, key:${key}, err:${err.message}`);
      return null;
    }
  }

  /**
   * @description 根据key同步获取首选项中存的值
   * @param context: context
   * @param storeName: storeName
   * @param key: 首选项的键值
   */
  public static getValueSync(context: Context, storeName: string, key: string): dataPreferences.ValueType | null {
    try {
      let store = this.getStoreSync(context, storeName);
      this.updateStoreCache(storeName, store);
      const result = store.getSync(key, '');
      Logger.debug(TAG, `getValueSync from ${storeName} with key:${key} and value:${result}`);
      return result;
    } catch (err) {
      Logger.error(TAG,
        `getValueSync from ${storeName} error, key:${key}, err:${err.message}`);
      return null;
    }
  }

  /**
   * @description 在首选项中存入键值对并持久化
   * @param context: context
   * @param storeName: storeName
   * @param key: 存入的键
   * @param value:存入的value值
   */
  public static async setValue(context: Context, storeName: string, key: string,
    value: dataPreferences.ValueType): Promise<void> {
    try {
      Logger.debug(TAG, `begin to putValue to ${storeName} with key:${key} and value:${value}`);
      let store = await this.getStore(context, storeName);
      this.updateStoreCache(storeName, store);
      await store.put(key, value);
      await store.flush();
    } catch (err) {
      Logger.error(TAG, `putValue from ${storeName} error, key:${key}, err:${err.message}`);
    }
  }

  /**
   * @description 在首选项中删除键值对并持久化
   * @param context: context
   * @param storeName: storeName
   * @param key: 存入的键
   */
  public static async deleteValue(context: Context, storeName: string, key: string): Promise<void> {
    try {
      Logger.debug(TAG, `begin to delete from ${storeName} with key:${key}`);
      let store = await this.getStore(context, storeName);
      this.updateStoreCache(storeName, store);
      await store.delete(key);
      await store.flush();
    } catch (err) {
      Logger.error(TAG, `delete from ${storeName} error, key:${key}, err:${err.message}`);
    }
  }

  /**
   * @description 清理storeName对应的store所有内容
   * @param context: context
   * @param storeName: storeName
   */
  public static async clear(context: Context, storeName: string): Promise<void> {
    try {
      Logger.debug(TAG, `begin to clear ${storeName}`);
      let store = await this.getStore(context, storeName);
      this.updateStoreCache(storeName, store);
      await store.clear();
      await store.flush();
    } catch (err) {
      Logger.error(TAG, `clear ${storeName} error, err:${err.message}`);
    }
  }

  /**
   * @description 根据key判断首选项中是否存在值
   * @param context: context
   * @param storeName: storeName
   * @param key: 首选项的键值
   */
  public static async hasKey(context: Context, storeName: string, key: string): Promise<boolean> {
    try {
      let store = await this.getStore(context, storeName);
      this.updateStoreCache(storeName, store);
      const result = await store.has(key);
      return result;
    } catch (err) {
      Logger.error(TAG, `query from ${storeName} with key:${key} error, err:${err.message}`);
      return false;
    }
  }

  /**
   * @description 根据key判断首选项中是否存在值
   * @param context: context
   * @param storeName: storeName
   * @param key: 首选项的键值
   */
  public static hasKeySync(context: Context, storeName: string, key: string): boolean {
    try {
      let store = this.getStoreSync(context, storeName);
      this.updateStoreCache(storeName, store);
      const result = store.hasSync(key);
      return result;
    } catch (err) {
      Logger.error(TAG, `Sync query from ${storeName} with key:${key} error, err:${err.message}`);
      return false;
    }
  }

  /**
   * @description 根据key获取首选项的值并解密，返回明文文本
   * @param key: 首选项的键
   */
  public static async getDecryptionText(context: Context, storeName: string, key: string): Promise<string | null> {
    Logger.debug(TAG, `getDecryptionText storeName:${storeName} key:${key} `)
    if (!PreferenceUtil.hasKeySync(context, storeName, key)) {
      Logger.error(TAG, `getDecryptionText storeName:${storeName} key:${key} fail,key not exist`)
      return null;
    }
    try {
      let ciphertextBytes: Uint8Array = await PreferenceUtil.getValue(context, storeName, key) as Uint8Array;
      let plaintext = await CryptoUtil.huksAesGCMDecrypt(ciphertextBytes);
      Logger.debug(TAG, `getDecryptionText storeName:${storeName} key:${key} success.`);
      return plaintext;
    } catch (e) {
      Logger.error(TAG,
        `getDecryptionText storeName:${storeName} key:${key} ERROR!!!,error is ${JSON.stringify(e)}`);
    }
    return null;
  }

  /**
   * @description 将value进行加密并存入首选项中
   * @param key: 存入的键
   * @param value:待加密存的明文文本
   */
  public static async setEncryptionText(context: Context, storeName: string, key: string,
    value: string): Promise<void> {
    Logger.debug(TAG, `setEncryptionText storeName:${storeName} key:${key}`);
    if (value == null) {
      Logger.error(TAG, `value is empty,delete key:${key} from preferences`);
      await PreferenceUtil.deleteValue(context, storeName, key);
      return;
    }

    try {
      let ciphertextBytes: Uint8Array = await CryptoUtil.huksAesGCMEncrypt(value);
      await PreferenceUtil.setValue(context, storeName, key, ciphertextBytes);
    } catch (e) {
      Logger.error(TAG,
        `setEncryptionText storeName:${storeName} key:${key} ERROR!!!,error is ${JSON.stringify(e)}`);
    }
    Logger.debug(TAG, `setEncryptionText storeName:${storeName} key:${key} success.`);
  }

  private static async getStore(context: Context, storeName: string): Promise<dataPreferences.Preferences> {
    let actualStoreName = !storeName ? DEFAULT_STORE_NAME : storeName;
    let store = this.cachedPreferences.get(actualStoreName);
    if (store) {
      return store;
    }
    Logger.info(TAG, `there is no cached store:${actualStoreName}, begin to get one`);
    return dataPreferences.getPreferences(context, actualStoreName);
  }

  private static getStoreSync(context: Context, storeName: string): dataPreferences.Preferences {
    let actualStoreName = !storeName ? DEFAULT_STORE_NAME : storeName;
    let store = this.cachedPreferences.get(actualStoreName);
    if (store) {
      return store;
    }
    Logger.info(TAG, `getStoreSync there is no cached store:${actualStoreName}, begin to get one`);
    return dataPreferences.getPreferencesSync(context, { name: actualStoreName });
  }

  private static updateStoreCache(storeName: string, store: dataPreferences.Preferences): void {
    if (!this.cachedPreferences.has(storeName)) {
      this.cachedPreferences.set(storeName, store);
    }
  }
}
