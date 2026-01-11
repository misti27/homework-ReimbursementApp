import { ExpenseItem } from '../models/FormData'
import { ExpenseItemCard } from './ExpenseItemCard'

@Component
export struct ExpenseItemSection {
  @Consume('expenseList') expenseList: ExpenseItem[]

  onShowCalculator: (show: boolean, index: number) => void = () => {}

  @State private watcher: number = 0

  getTotalAmount(): number {
    this.watcher

    try {
      return this.expenseList.reduce((sum, item) => {
        return sum + (item.getAmountNumber ? item.getAmountNumber() : 0)
      }, 0)
    } catch (error) {
      console.error('计算总额异常:', error)
      return 0
    }
  }

  addExpenseItem() {
    try {
      // 创建新对象（构造函数会自动生成 ID）
      const newItem = new ExpenseItem()
      this.expenseList.push(newItem)
    } catch (error) {
      console.error('添加费用项异常:', error)
    }
  }

  deleteExpenseItem(index: number) {
    try {
      if (index >= 0 && index < this.expenseList.length) {
        this.expenseList.splice(index, 1)
      }
    } catch (error) {
      console.error('删除费用项异常:', error)
    }
  }

  build() {
    Column() {
      // 标题栏
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('费用明细')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)

        Row() {
          Text('总计 ')
            .fontSize(12)
            .fontColor('#1677ff')
          Text(`¥${this.getTotalAmount().toFixed(2)}`)
            .fontSize(16)
            .fontColor('#1677ff')
            .fontWeight(FontWeight.Bold)
        }
        .padding({ left: 10, right: 10, top: 6, bottom: 6 })
        .backgroundColor('#e6f4ff')
        .borderRadius(999)
      }

      // 列表区域
      List({ space: 12 }) {
        ForEach(this.expenseList, (item: ExpenseItem, index: number) => {
          ListItem() {
            ExpenseItemCard({
              item: item, // 传递 ObjectLink 对象
              index: index,
              onDelete: () => {
                this.deleteExpenseItem(index)
              },
              onShowCalculator: (idx: number) => {
                this.onShowCalculator(true, idx)
              },
              // 传入一个回调，当子组件数值变化时，刷新父组件状态
              onValueChange: () => {
                this.watcher += 1
              }
            })
          }
        }, (item: ExpenseItem) => item.id) // 确保使用 id 作为 key
      }
      .width('100%')

      // 添加按钮
      Button('添加费用项')
        .width('100%')
        .margin({ top: 12 })
        .backgroundColor('#1677ff')
        .onClick(() => {
          this.addExpenseItem()
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(8)
  }
}
