import sql from 'smartdb';
import { MainDBHelper } from './MainDBHelper';


export class User {
  @sql.SqlColumn(sql.ColumnType.INTEGER)
  id: number = 0
  @sql.SqlColumn(sql.ColumnType.TEXT)
  name: string = ''

  constructor() {
  }

  // constructor(id: number, name: string) {
  //   this.id = id
  //   this.name = name
  // }

}

class UserDao {
  table: string = "db_user"

  constructor() {
  }

  /**
   * @Description:新增
   * @param id
   * @param name
   * @returns Promise<boolean> 成功true or 失败false
   */
  insert(id: number, name: string): Promise<boolean> {
    let cv = new Map<string, string | number>()
    cv.set("id", id)
    cv.set("name", name)
    return MainDBHelper.getInstance().insert(this.table, cv)
  }

  /**
   * @Description:查询集合数
   * @returns
   */
  findAllCount(succeed: (response: number) => void) {
    MainDBHelper.getInstance().queryItemData<number>(`select count(*) from ${this.table}`, Number, succeed)
  }

  /**
   * @Description:查询名称集合
   * @returns
   */
  findAllName(succeed: (userList: string[]) => void) {
    MainDBHelper.getInstance().queryListData<string>(`select name from ${this.table}`, String, succeed)
  }

  /**
   * @Description:查询单个名称
   * @returns
   */
  findOneName(succeed: (name: string) => void) {
    MainDBHelper.getInstance().queryItemData<string>(`select name from ${this.table}`, String, succeed)
  }

  /**
   * @Description:查询所有数据
   * @returns
   */
  findAllUser(succeed: (userList: User[]) => void) {
    MainDBHelper.getInstance().queryListData<User>(`select * from ${this.table}`, User, succeed)
  }

  /**
   * @Description:查询单个数据
   * @returns
   */
  findOneUser(succeed: (name: User) => void) {
    MainDBHelper.getInstance().queryItemData<User>(`select * from ${this.table}`, User, succeed)
  }

  /**
   * @description 删除所有数据
   * @returns
   */
  deleteAll(): Promise<void> {
    return MainDBHelper.getInstance().execSQL(`delete from ${this.table} `)
  }
}

export const userDao = new UserDao()
