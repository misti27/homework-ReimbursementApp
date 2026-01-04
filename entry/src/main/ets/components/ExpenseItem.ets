import { ExpenseItem } from '../models/FormData'
import { ExpenseItemCard } from './ExpenseItemCard'

@Component
export struct ExpenseItemSection {
  @Consume('expenseList') expenseList: ExpenseItem[]
  onShowCalculator: (show: boolean, index: number) => void = () => {}

  getTotalAmount(): number {
    try {
      return this.expenseList?.reduce((sum, item) => {
        return sum + (item?.getAmountNumber() ?? 0)
      }, 0) ?? 0
    } catch (error) {
      console.error('计算总额异常:', error)
      return 0
    }
  }

  addExpenseItem() {
    try {
      const newItem = new ExpenseItem()
      this.expenseList.push(newItem)
    } catch (error) {
      console.error('添加费用项异常:', error)
      AlertDialog.show({ message: '添加失败，请重试' })
    }
  }

  deleteExpenseItem(index: number) {
    try {
      if (index >= 0 && index < (this.expenseList?.length ?? 0)) {
        this.expenseList.splice(index, 1)
      }
    } catch (error) {
      console.error('删除费用项异常:', error)
      AlertDialog.show({ message: '删除失败，请重试' })
    }
  }

  build() {
    Column() {
      Flex({
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }) {
        Text('费用明细')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)

        Text(`总计: ¥${this.getTotalAmount().toFixed(2)}`)
          .fontSize(16)
          .fontColor('#1890ff')
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .margin({ bottom: 12 })

      List({ space: 12 }) {
        ForEach(this.expenseList, (item: ExpenseItem, index: number) => {
          ListItem() {
            ExpenseItemCard({
              item: item,
              index: index,
              onDelete: () => {
                this.deleteExpenseItem(index)
              },
              onShowCalculator: (idx: number) => {
                this.onShowCalculator(true, idx)
              }
            })
          }
        }, (item: ExpenseItem) => item.id)
      }
      .width('100%')

      Button('添加费用项')
        .width('100%')
        .margin({ top: 12 })
        .backgroundColor('#52c41a')
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
