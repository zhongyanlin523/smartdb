import relationalStore from '@ohos.data.relationalStore';
import sql from 'smartdb'
import DbUtil from 'smartdb/src/main/ets/DbUtil';
import { AppDBConst } from './AppDBConst';

/**
 * @Description:图片数据库操作类
 * @author: create by zyl on 2024/07/03
 */
class PictureDBHelper extends sql.DbOpenHelper {
  constructor() {
    super()
  }
  // <editor-fold defaultstate="collapsed" desc="调用源码的注解方式，不开放使用">

  /**
   * @Description:执行sql
   * @author: create by zyl on 2024/07/03
   */
  @sql.Sql("#sql")
  @sql.DbName(AppDBConst.PICTURE_DB_NAME)
  private annotationSql(@sql.Param("sql") mSql: string): Promise<void> {
    return sql.PromiseNull();
  }

  /**
   * @Description:执行sql
   * @author: create by zyl on 2024/07/03
   */
  @sql.SqlInsert("#sql")
  @sql.DbName(AppDBConst.PICTURE_DB_NAME)
  private annotationSqlInsert(@sql.Param("sql") mSql: string): Promise<void> {
    return sql.PromiseNull();
  }

  /**
   * @Description:查询
   * @author: create by zyl on 2024/07/03
   */
  @sql.SqlQuery("#sql",true)
  @sql.DbName(AppDBConst.PICTURE_DB_NAME)
  private annotationQuery(@sql.Param("sql") mSql: string): Promise<relationalStore.ResultSet> {
    return sql.PromiseNull();
  }

  /**
   * @Description:执行事务
   * @param: execList 事务清单
   */
  @sql.Transactional()
  @sql.DbName(AppDBConst.PICTURE_DB_NAME)
  async annotationExecTransactional(execList: () => void) {
    execList()
  }

  // </editor-fold>

  async onCreate(db: relationalStore.RdbStore) {
    //用户表[测试用]
    await this.annotationSql("create table if not exists db_user ( id INTEGER  PRIMARY KEY AUTOINCREMENT ,name TEXT not null)")
    //图片表
    let mImageCreateSql = `CREATE TABLE if not exists Woolinte_PtypeImage(
     [Nub] integer PRIMARY KEY autoincRement,
     [PtypeID_] [varchar](60) DEFAULT '',
     [NubCount] [varchar](60) DEFAULT '',
     [Image] [varchar](8000) DEFAULT '',
     [xiwamaxtime] [INTEGER] DEFAULT ''
     ); `
    await this.annotationSql(mImageCreateSql);

  }

  async onUpgrade(db: relationalStore.RdbStore, oldVersion: number, newVersion: number) {
    if (oldVersion <= 2) {
      //升级操作
    }
  }

  private static _instance: PictureDBHelper;

  public static getInstance(): PictureDBHelper {
    if (!PictureDBHelper._instance) {
      PictureDBHelper._instance = new PictureDBHelper();
    }
    return PictureDBHelper._instance;
  }


  /**
   * @Description:执行事务
   * @param: execList 事务清单
   */
  async execTransactional(execList: () => void) {
    this.annotationExecTransactional(execList)
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

export default PictureDBHelper.getInstance()