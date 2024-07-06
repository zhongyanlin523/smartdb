import PictureDBHelper from './PictureDBHelper';

export class User {
  id: number
  name: string

  constructor(id: number, name: string) {
    this.id = id
    this.name = name
  }
}

class UserDao2 {
  table: string = "db_user"

  constructor() {
  }

  /**
   * @Description:事务新增
   * @param id
   * @param name
   * @returns Promise<boolean> 成功true or 失败false
   */
  execTransactional(id: number): Promise<void> {
    return PictureDBHelper.execTransactional(() => {
      this.insert(id + 0, '张三' + id)
      this.insert(id + 1, '李四' + id)
      this.insert(id + 2, '王五' + id)
    })
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
    return PictureDBHelper.insert(this.table, cv)
  }

  /**
   * @Description:查询集合数
   * @returns
   */
  findAllCount(succeed: (response: number) => void) {
    PictureDBHelper.queryItemData<number>(`select count(*) from ${this.table}`, Number, succeed)
  }

  /**
   * @Description:查询名称集合
   * @returns
   */
  findAllName(succeed: (userList: string[]) => void) {
    PictureDBHelper.queryListData<string>(`select name from ${this.table}`, String, succeed)
  }

  /**
   * @Description:查询单个名称
   * @returns
   */
  findOneName(succeed: (name: string) => void) {
    PictureDBHelper.queryItemData<string>(`select name from ${this.table}`, String, succeed)
  }

  /**
   * @Description:查询所有数据
   * @returns
   */
  findAllUser(succeed: (userList: User[]) => void) {
    PictureDBHelper.queryListData<User>(`select * from ${this.table}`, User, succeed)
  }

  /**
   * @Description:查询单个数据
   * @returns
   */
  findOneUser(succeed: (name: User) => void) {
    PictureDBHelper.queryItemData<User>(`select * from ${this.table}`, User, succeed)
  }

  /**
   * @description 删除所有数据
   * @returns
   */
  deleteAll(): Promise<void> {
    return PictureDBHelper.execSQL(`delete from ${this.table} `)
  }
}

export const userDao2 = new UserDao2()
