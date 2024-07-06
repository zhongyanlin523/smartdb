import sql from 'smartdb';
import hilog from '@ohos.hilog';
import { MainDBHelper } from './MainDBHelper';
import { PictureDBHelper } from './PictureDBHelper';
export interface ConstructorArgs {
  id: number;
  name: string;
}
/**
 * AppDB类用于初始化应用程序的数据库
 */
class AppDB {
  private static _instance: AppDB;

  public static getInstance(): AppDB {
    if (!AppDB._instance) {
      AppDB._instance = new AppDB();
    }
    return AppDB._instance;
  }

  static DB_VERSION: number = 3


  /**
   * @Description: 测试用，直接加载两个db
   */
  initDb(context: Context) {
    sql.Logger.setLogLevel(hilog.LogLevel.DEBUG)
    sql.dbHelper.initDb(context, "test.db", AppDB.DB_VERSION, MainDBHelper.getInstance())
    sql.createDbHelper(PictureDBHelper.PICTURE_DB_NAME).initDb(context, "test2.db", AppDB.DB_VERSION, PictureDBHelper.getInstance())
  }


  // <editor-fold defaultstate="collapsed" desc="初始化主数据库">
  /**
   * 初始化主数据库。
   *
   * 此函数用于在给定的上下文中初始化主数据库。它通过传入的ztCode和指定的数据库版本，
   * 创建并初始化一个名为`ztCode.db`的数据库。主数据库的帮助类通过getInstance方法获取。
   *
   * @param context 应用程序的上下文，用于数据库操作。
   * @param ztCode 一个字符串代码，用于生成数据库文件的名称，数据库文件名为`ztCode.db`。
   */
  initMainDb(context: Context, ztCode: string) {
    sql.dbHelper.initDb(context, `${ztCode}.db`, AppDB.DB_VERSION, MainDBHelper.getInstance())
  }

  // </editor-fold>

  // <editor-fold defaultstate="collapsed" desc="初始化图片数据库">
  /**
   * 初始化图片数据库。
   *
   * 此函数用于在给定的上下文中初始化用于存储图片数据的数据库。它通过传入的ztCode和指定的数据库版本，
   * 创建并初始化一个名为`pic_ztCode.db`的数据库。图片数据库的帮助类通过createDbHelper方法的特定实例获取。
   *
   * @param context 应用程序的上下文，用于数据库操作。
   * @param ztCode 一个字符串代码，用于生成数据库文件的名称，数据库文件名为`pic_ztCode.db`。
   */
  initPictureDb(context: Context, ztCode: string) {
    sql.createDbHelper("test2").initDb(context, `pic_${ztCode}.db`, AppDB.DB_VERSION, PictureDBHelper.getInstance())
  }

  // </editor-fold>
}

export default AppDB.getInstance()