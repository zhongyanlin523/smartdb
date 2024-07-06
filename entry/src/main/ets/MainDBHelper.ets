import relationalStore from '@ohos.data.relationalStore';
import sql from 'smartdb';
import DbUtil from 'smartdb/src/main/ets/DbUtil';

/**
 * @Description:主数据库操作类
 * @author: create by zyl on 2024/07/03
 * @see annotationSql
 */
export class MainDBHelper extends sql.DbOpenHelper {
  constructor() {
    super()
  }

  private static _instance: MainDBHelper;

  public static getInstance(): MainDBHelper {
    if (!MainDBHelper._instance) {
      MainDBHelper._instance = new MainDBHelper();
    }
    return MainDBHelper._instance;
  }

  async onCreate(db: relationalStore.RdbStore) {
    //用户表
    await this.annotationSql("create table if not exists db_user ( id INTEGER  PRIMARY KEY AUTOINCREMENT ,name TEXT not null)")
  }

  async onUpgrade(db: relationalStore.RdbStore, oldVersion: number, newVersion: number) {
    if (oldVersion <= 2) {
      //升级操作
    }
  }


  // <editor-fold defaultstate="collapsed" desc="源码为注解方式，需要转一层，不直接使用源码">

  /**
   * @Description:执行sql
   * @author: create by zyl on 2024/07/03
   */
  @sql.Sql("#sql")
  private annotationSql(@sql.Param("sql") mSql: string): Promise<void> {
    console.debug("自定义sql：" + mSql)
    return new Promise<void>((resolve, reject) => {
      console.debug("自定义sql：resolve" + resolve)
      console.debug("自定义sql：reject" + reject)
    })
  }

  /**
   * @Description:执行sql
   * @author: create by zyl on 2024/07/03
   */
  @sql.SqlInsert("#sql")
  private annotationSqlInsert(@sql.Param("sql") mSql: string): Promise<void> {
    sql.Logger.info("自定义sql：" + mSql)
    return sql.PromiseNull();
  }

  /**
   * @Description:查询
   * @author: create by zyl on 2024/07/03
   */
  @sql.SqlQuery("#sql",true)
  private annotationQuery(@sql.Param("sql") mSql: string): Promise<relationalStore.ResultSet> {
    sql.Logger.info("自定义sql：" + mSql)
    // 如果不需要使用reject，可以简化Promise的构造
    return sql.PromiseNull();
  }

  // </editor-fold>


  /**
   * @Description:执行事务
   * @param: execList 事务清单
   */
  @sql.Transactional()
  async execTransactional(execList: () => void) {
    execList()
  }

  /**
   * @Description:单个新增
   * @param tableName 表名
   * @param map 数据源
   * @returns Promise<boolean> 成功true or 失败false
   */
  async insert(tableName: string, map: Map<string, string | number>): Promise<boolean> {
    // <editor-fold defaultstate="collapsed" desc="单个新增实现代码">
    // 使用Array.from将Map对象转换成数组，然后再进行处理
    let valueStr = Array.from(map.values()).map(value => {
      // 对值进行适当的转换，确保安全（例如，字符串加引号，特殊字符转义等）
      if (typeof value === 'string') {
        return `'${value}'`; // 字符串加单引号
      } else {
        return value; // 数字等直接返回
      }
    }).join(',');
    let mSql = `replace into ${tableName} (${Array.from(map.keys()).join(',')}) VALUES (${valueStr})`;
    try {
      // 尝试执行插入操作
      await this.annotationSqlInsert(mSql);
      // 插入成功，返回true
      return true;
    } catch (error) {
      // 返回false表示失败
      return false;
    }
    // </editor-fold>
  }

  /**
   * @Description:批量新增
   * @param tableName 表名
   * @param map 数据源
   */
  async batchInsert(tableName: string, dataItems: Array<Map<string, string | number>>): Promise<void> {
    // <editor-fold defaultstate="collapsed" desc="批量新增实现代码">
    if (dataItems.length === 0) {
      return sql.PromiseNull(); // 如果没有数据，则直接返回
    }

    // 初始化SQL语句的值部分
    let valuesClause = '';

    // 构建批量插入的VALUES子句
    dataItems.forEach((item, index) => {
      // 使用Array.from将Map对象转换成数组，然后再进行处理
      let valueStr = Array.from(item.values()).map(value => {
        // 对值进行适当的转换，确保安全（例如，字符串加引号，特殊字符转义等）
        if (typeof value === 'string') {
          return `'${value}'`; // 字符串加单引号
        } else {
          return value; // 数字等直接返回
        }
      }).join(',');
      // 拼接单个VALUES子句
      valuesClause += `(${valueStr}),`;

      // 如果是最后一个元素，去除末尾的逗号
      if (index === dataItems.length - 1) {
        valuesClause = valuesClause.slice(0, -1);
      }
    });

    // 完整的SQL语句
    let batchInsertSql =
      `replace into ${tableName} (${Array.from(dataItems[0].keys()).join(',')}) VALUES ${valuesClause}`;
    return this.annotationSql(batchInsertSql)
    // </editor-fold>
  }

  /**
   * @Description:execSQL方法 。除查询外都可用
   * @param mSql 执行语句
   */
  execSQL(mSql: string): Promise<void> {
    return this.annotationSql(mSql)
  }

  /**
   * @Description:查询单个
   * @param mSql sql语句
   * @param clazz 实体类class【必要传，原因三方转实体类用。。。】
   * @param succeed 回调函数
   */
  async queryItemData<T>(mSql: string, clazz: Object, succeed: (response: T) => void) {
    await this.annotationQuery(mSql).then(result => {
      succeed(DbUtil.parseAndCreateObject<T>(result, clazz));
    })
  }


  /**
   * @Description:查询数组
   * @param mSql sql语句
   * @param clazz 实体类class 【必要传，原因三方转实体类用。。。】
   * @param succeed 回调函数
   */
  async queryListData<T>(mSql: string, clazz: Object, succeed: (response: T[]) => void) {
    await this.annotationQuery(mSql).then(result => {
      succeed(DbUtil.parseAndCreateObjects<T>(result, clazz));
    })
  }
}



