/**
 * @Description:数据库DB常量
 * @author: create by zyl on 2024-07-06
 */
export class AppDBConst {
  //主数据库版本  - DB是后台生成的，不会用到
  static readonly MAIN_DB_VERSION: number = 1
  //图片数据库版本 - DB是APP生成的，后面加字段用
  static readonly PICTURE_DB_VERSION: number = 1
  //图片库DBName
  static readonly PICTURE_DB_NAME: string = "PICTURE_DB_NAME"
}