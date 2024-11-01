import relationalStore from '@ohos.data.relationalStore';
import Logger from './Logger'
import dataPreferences from '@ohos.data.preferences';
import { DbOpenHelper } from './DbOpenHelper';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 存储所有的dbHelper
 */
const dbHelpers = {}

export class DbHelper {
  dbContext: any;
  storeConfig: relationalStore.StoreConfig
  dbVersion: number = 0
  rdbStore: relationalStore.RdbStore

  async initDb(context: any, dbName: string, customDir: string, dbVersion: number, dbOpenHelper: DbOpenHelper) {
    await this.initDbWithConfig(context, {
      name: dbName,
      customDir: customDir,
      securityLevel: relationalStore.SecurityLevel.S1
    }, dbVersion, dbOpenHelper)
  }

  async initDbWithConfig(context: any, storeConfig: relationalStore.StoreConfig, dbVersion: number, dbOpenHelper: DbOpenHelper) {
    if (dbVersion <= 0) {
      throw new Error("dbVersion must > 0");
    }
    let dbName = storeConfig.name;
    this.dbContext = context;
    this.storeConfig = storeConfig
    this.dbVersion = dbVersion
    if (this.rdbStore) {
      // this.rdbStore.close() //适配跨平台
      this.rdbStore = null
    }
    let dbPreferenceKey = `smartdb_preference`
    let dbVersionKey = `smartdb_version_${dbName}`
    let preferences = await dataPreferences.getPreferences(context, dbPreferenceKey)
    let oldVersion = (await preferences.get(dbVersionKey, 0)) as number

    if (this.dbVersion < oldVersion) {
      this.dbVersion = oldVersion
    }

    await this.getRdbStore()

    if (oldVersion != this.dbVersion) {
      await dbOpenHelper.onCreate(this.rdbStore)
      if (oldVersion < this.dbVersion) {
        this.beginTransaction()
        await dbOpenHelper.onUpgrade(this.rdbStore, oldVersion, this.dbVersion)
        this.commit()
      }
      await preferences.put(dbVersionKey, this.dbVersion)
      await preferences.flush()
    }

    //bind当前db
    dbHelpers[dbName] = this
  }

  deleteRdbStore(){
    relationalStore.deleteRdbStore(this.dbContext, this.storeConfig, (err: BusinessError) => {
      if (err) {
        console.error(`Delete RdbStore failed, code is ${err.code},message is ${err.message}`);
        return;
      }
      console.info('Delete RdbStore successfully.');
    })
  }

  getRdbStore(): Promise<relationalStore.RdbStore> {
    return new Promise((resolve, reject) => {
      if (this.rdbStore) {
        resolve(this.rdbStore)
      } else {
        relationalStore.getRdbStore(this.dbContext, this.storeConfig).then((store) => {
          this.rdbStore = store
          resolve(store)
        }).catch((e) => {
          Logger.error(e)
          reject(e)
        })
      }
    })
  }

  beginTransaction() {
    if (this.rdbStore) {
      Logger.debug("transaction begin")
      this.rdbStore.beginTransaction()
    }
  }

  commit() {
    if (this.rdbStore) {
      Logger.debug("transaction commit")
      this.rdbStore.commit()
    }
  }

  rollBack() {
    if (this.rdbStore) {
      Logger.debug("transaction rollBack")
      this.rdbStore.rollBack()
    }
  }
}

/**
 * 默认dbHelper
 */
export const defaultDbHelper = createDbHelper("default")

/**
 * 创建更多dbHelper
 * @param key 自定义key,需要配置DbName装饰器使用
 * @returns
 * @returns
 */
export function createDbHelper(key: string): DbHelper {
  let dbHelper = new DbHelper()
  dbHelpers[key] = dbHelper
  return dbHelper
}

/**
 * 获取dbHelper
 * @param key 创建时传入的key或者数据名
 * @returns
 */
export function getDbHelper(key: string): DbHelper | null {
  return dbHelpers[key]
}

/**
 * 保留,兼容旧版本
 */
export default defaultDbHelper
