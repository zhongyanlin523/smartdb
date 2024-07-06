import Logger from '../Logger'
import DbUtil from '../DbUtil'

export function SqlQuery(sql: string, isNative?: boolean): MethodDecorator {
  return DbUtil.handleSql(sql, (newSql, target, propertyKey) => {
    return new Promise(async (resolve, reject) => {
      try {
        let dbHelper = DbUtil.getDbHelperByDecorator(target, propertyKey)
        let rdbStore = await dbHelper.getRdbStore()
        let result = await rdbStore.querySql(newSql)
        if (isNative) {
          resolve(result)
        } else {
          resolve(DbUtil.parseResult(result, target, propertyKey))
        }
      } catch (e) {
        Logger.error(e)
        reject(e)
      }
    })
  })
}
