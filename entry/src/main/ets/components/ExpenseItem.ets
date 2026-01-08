import { ExpenseItem } from '../models/FormData'
import { ExpenseItemCard } from './ExpenseItemCard'
import { Calculator } from './Calculator'

// --- 定义计算器弹窗包装器 ---
@CustomDialog
struct CalculatorDialogWrapper {
  controller?: CustomDialogController
  // @Prop，确保每次打开弹窗时能接收到最新的索引值
  @Prop targetIndex: number = -1

  build() {
    // 引用 Calculator 组件
    Calculator({
      targetIndex: this.targetIndex,
      onClose: () => {
        this.controller?.close()
      }
    })
  }
}

@Component
export struct ExpenseItemSection {
  @Consume('expenseList') expenseList: ExpenseItem[]

  // 记录当前正在计算哪一项
  @State currentCalcIndex: number = -1
  // 辅助变量，用于强制刷新总金额（如果需要）
  @State private watcher: number = 0

  // --- 初始化弹窗控制器 ---
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CalculatorDialogWrapper({
      // 传递 this.currentCalcIndex。
      // 由于上面改为了 @Prop，当组件内的 currentCalcIndex 变化时，弹窗内的数据也会更新。
      targetIndex: this.currentCalcIndex
    }),
    customStyle: true, // 使用自定义样式（透明背景）
    alignment: DialogAlignment.Center,
    autoCancel: false
  })

  // 计算总金额
  getTotalAmount(): number {
    this.watcher // 依赖收集
    try {
      return this.expenseList.reduce((sum, item) => {
        return sum + (item.getAmountNumber ? item.getAmountNumber() : 0)
      }, 0)
    } catch (error) {
      return 0
    }
  }

  // 添加新费用项
  addExpenseItem() {
    try {
      // 使用无参构造函数
      const newItem = new ExpenseItem()
      // 手动初始化默认值
      newItem.type = '交通费'
      newItem.amount = ''
      newItem.remarks = ''

      this.expenseList.push(newItem)
    } catch (error) {
      console.error('添加失败:', error)
    }
  }

  // 删除费用项
  deleteExpenseItem(index: number) {
    try {
      if (index >= 0 && index < this.expenseList.length) {
        this.expenseList.splice(index, 1)
      } else {
        throw new Error("Index out of bounds") // 模拟抛出异常以满足作业逻辑要求
      }
    } catch (error) {
      console.error('删除费用项异常:', error)
    }
  }

  build() {
    Column() {
      // 标题栏
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

      // 列表区域
      List({ space: 12 }) {
        ForEach(this.expenseList, (item: ExpenseItem, index: number) => {
          ListItem() {
            ExpenseItemCard({
              item: item,
              index: index,
              // 删除回调
              onDelete: () => {
                this.deleteExpenseItem(index)
              },
              // 计算器回调：更新索引并打开弹窗
              onShowCalculator: (idx: number) => {
                // 1. 先更新状态
                this.currentCalcIndex = idx
                // 2. 再打开弹窗 (由于 @Prop 绑定，弹窗内部会获取到新的 idx)
                this.dialogController.open()
              },
              // 数值变化回调：刷新总金额
              onValueChange: () => {
                this.watcher += 1
              }
            })
          }
        }, (item: ExpenseItem) => item.id) // 使用 ID 作为唯一键
      }
      .width('100%')

      // 添加按钮
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