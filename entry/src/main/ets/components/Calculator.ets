import { ExpenseItem } from '../models/FormData'

@Component
export struct Calculator {
  @Prop targetIndex: number = -1
  @Consume('expenseList') expenseList: ExpenseItem[]
  onClose: () => void = () => {}

  @State displayValue: string = '0'
  @State currentOperator: string = ''
  @State previousValue: string = ''
  @State shouldResetDisplay: boolean = false

  handleNumberClick(num: string) {
    try {
      if (this.shouldResetDisplay) {
        this.displayValue = num
        this.shouldResetDisplay = false
      } else {
        this.displayValue = this.displayValue === '0' ? num : this.displayValue + num
      }
    } catch (error) {
      console.error('数字输入异常:', error)
    }
  }

  handleOperatorClick(op: string) {
    try {
      if (this.currentOperator && !this.shouldResetDisplay) {
        this.calculate()
      }
      this.previousValue = this.displayValue
      this.currentOperator = op
      this.shouldResetDisplay = true
    } catch (error) {
      console.error('运算符处理异常:', error)
    }
  }

  calculate() {
    try {
      const prev = parseFloat(this.previousValue ?? '0')
      const current = parseFloat(this.displayValue ?? '0')

      if (isNaN(prev) || isNaN(current)) {
        throw new Error('无效的数字')
      }

      let result = 0
      switch (this.currentOperator) {
        case '+':
          result = prev + current
          break
        case '-':
          result = prev - current
          break
        case '×':
          result = prev * current
          break
        case '÷':
          if (current === 0) {
            throw new Error('除数不能为零')
          }
          result = prev / current
          break
        default:
          return
      }

      this.displayValue = result.toFixed(2)
      this.currentOperator = ''
      this.previousValue = '' // 计算完成后清空过程
      this.shouldResetDisplay = true

    } catch (error) {
      console.error('计算异常:', error)
      AlertDialog.show({
        message: `计算错误: ${error}`
      })
      this.clear()
    }
  }

  clear() {
    this.displayValue = '0'
    this.currentOperator = ''
    this.previousValue = ''
    this.shouldResetDisplay = false
  }

  backspace() {
    try {
      if (this.displayValue.length > 1) {
        this.displayValue = this.displayValue.slice(0, -1)
      } else {
        this.displayValue = '0'
      }
    } catch (error) {
      console.error('退格异常:', error)
    }
  }

  handleDecimalPoint() {
    try {
      if (!this.displayValue.includes('.')) {
        this.displayValue += '.'
      }
    } catch (error) {
      console.error('小数点处理异常:', error)
    }
  }

  confirmValue() {
    try {
      if (this.targetIndex >= 0 && this.targetIndex < (this.expenseList?.length ?? 0)) {
        const item = this.expenseList[this.targetIndex]
        if (item) {
          item.amount = this.displayValue
        }
      }
      this.onClose()
      this.clear()
    } catch (error) {
      console.error('确认数值异常:', error)
      AlertDialog.show({ message: '操作失败' })
    }
  }

  build() {
    // 使用 RelativeContainer 实现布局 (符合实验要求)
    RelativeContainer() {
      // 1. 蒙层
      Column()
        .backgroundColor('rgba(0,0,0,0.5)')
        .id('mask')
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .onClick(() => {
          this.onClose()
          this.clear()
        })

      // 2. 计算器主体面板
      Column() {
        // --- 屏幕显示区域 ---
        Column() {
          // 【修复点 1】新增：显示计算过程（如 "100 +"）
          Text(this.currentOperator ? `${this.previousValue} ${this.currentOperator}` : '')
            .width('100%')
            .height(30)
            .fontSize(20)
            .fontColor(Color.Gray)
            .textAlign(TextAlign.End)
            .padding({ right: 20, top: 5 })

          // 主显示（结果或当前输入）
          Text(this.displayValue)
            .width('100%')
            .height(60)
            .fontSize(36)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.End)
            .padding({ right: 20, bottom: 5 })
        }
        .backgroundColor('#f0f0f0')
        .borderRadius({ topLeft: 12, topRight: 12 })
        .width('100%')

        // --- 键盘区域 ---
        Column({ space: 8 }) {
          this.buttonRow(['7', '8', '9', '÷'])
          this.buttonRow(['4', '5', '6', '×'])
          this.buttonRow(['1', '2', '3', '-'])
          this.buttonRow(['C', '0', '←', '+'])

          Flex({ justifyContent: FlexAlign.SpaceEvenly }) {
            Button('.')
              .width('22%')
              .height(50)
              .fontSize(20)
              .backgroundColor('#e0e0e0')
              .onClick(() => this.handleDecimalPoint())

            Button('=')
              .width('22%')
              .height(50)
              .fontSize(20)
              .backgroundColor('#1890ff')
              .fontColor(Color.White)
              .onClick(() => this.calculate())

            Button('确定')
              .width('48%')
              .height(50)
              .fontSize(18)
              .backgroundColor('#52c41a')
              .fontColor(Color.White)
              .onClick(() => this.confirmValue())
          }
          .width('100%')
        }
        .padding(12)
        .layoutWeight(1)
      }
      .width('90%')
      .height(500) // 稍微调高一点以容纳新的一行字
      .backgroundColor(Color.White)
      .borderRadius(12)
      .id('panel')
      // 使用相对定位规则
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        center: { anchor: '__container__', align: VerticalAlign.Center }
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder buttonRow(buttons: string[]) {
    Flex({ justifyContent: FlexAlign.SpaceEvenly }) {
      ForEach(buttons, (btn: string) => {
        Button(btn)
          .width('22%')
          .height(50)
          .fontSize(20)
          .backgroundColor(this.getButtonColor(btn))
          .fontColor(this.getButtonFontColor(btn))
          .onClick(() => this.handleButtonClick(btn))
      })
    }
    .width('100%')
  }

  getButtonColor(btn: string): string {
    if (['+', '-', '×', '÷'].includes(btn)) {
      return '#ff9800'
    }
    if (btn === 'C') {
      return '#ff4d4f'
    }
    return '#e0e0e0'
  }

  getButtonFontColor(btn: string): string {
    if (['+', '-', '×', '÷', 'C'].includes(btn)) {
      return '#ffffff'
    }
    return '#333333'
  }

  handleButtonClick(btn: string) {
    if (btn === 'C') {
      this.clear()
    } else if (btn === '←') {
      this.backspace()
    } else if (['+', '-', '×', '÷'].includes(btn)) {
      this.handleOperatorClick(btn)
    } else {
      this.handleNumberClick(btn)
    }
  }
}