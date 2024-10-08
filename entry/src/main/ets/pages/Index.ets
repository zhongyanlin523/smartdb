import sql from 'smartdb'
import { User, userDao } from '../UserDao'
import router from '@ohos.router'

@Entry
@Component
struct Index {
  insertId: number = 2000

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        Button("插入数据").onClick(() => {
          try {
            this.insert()
          } catch (e) {
            sql.Logger.error(e)
          }
        })
        Button("插入数据(事务)").onClick(() => {
          try {
            this.randomGenInsertId()
            userDao.execTransactional(this.insertId)
          } catch (e) {
            sql.Logger.error(e)
          }
        })
      }.width('100%').margin({ bottom: '10vp' })

      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        Button("查找单一实体类数据").onClick(() => {
          userDao.findOneUser((user: User) => {
            sql.Logger.info('数据 =' + user.id + ' name = ' + user.name)
          })
        })

        Button("查找多条实体类数据").onClick(() => {
          userDao.findAllUser((userList: User[]) => {
            userList.forEach((user: User) => {
              sql.Logger.info('多条数据 =' + user.id + ' name = ' + user.name)
            })
          })
        })

        Button("查找所有数据count").onClick(() => {
          userDao.findAllCount((result) => {
            sql.Logger.info(JSON.stringify(result))
          })
        })

        Button("查找单一名称数据").onClick(() => {
          userDao.findOneName((name: string) => {
            sql.Logger.info('数据 =' + name)
          })
        })

        Button("查找多条名称数据").onClick(() => {
          userDao.findAllName((userList: string[]) => {
            userList.forEach((name: string) => {
              sql.Logger.info('多条数据 =' + name)
            })
          })
        })
      }.width('100%').margin({ bottom: '10vp' })


      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        Button("删除所有数据").onClick(() => {
          userDao.deleteAll().then((result) => {
            sql.Logger.info("删除成功")
          })
        })
      }.width('100%').margin({ bottom: '10vp' })

      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        Button("多db测试").onClick(() => {
          router.pushUrl({ url: "pages/MultiDbPage" })
        })
      }.width('100%').margin({ bottom: '10vp' })
    }
  }

  randomGenInsertId() {
    this.insertId = Math.floor(Math.random() * 100_000_100)
  }

  async insert() {
    this.randomGenInsertId()
    sql.Logger.info("开始插入：" + this.insertId)
    let isSuccess = await userDao.insert(this.insertId, "name" + this.insertId)
    sql.Logger.info("是否插入成功=" + isSuccess)
  }
}

