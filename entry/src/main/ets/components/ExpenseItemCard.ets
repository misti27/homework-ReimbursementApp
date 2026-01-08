import { ExpenseItem } from '../models/FormData'

@Component
export struct ExpenseItemCard {
  @ObjectLink item: ExpenseItem
  @Prop index: number = 0

  // 回调函数
  onDelete: () => void = () => {}
  onShowCalculator: (index: number) => void = () => {}
  onValueChange: () => void = () => {}

  // 下拉选项
  private typeOptions: SelectOption[] = [
    { value: '交通费' },
    { value: '住宿费' },
    { value: '餐饮费' },
    { value: '其他' }
  ]

  build() {
    Column({ space: 12 }) {
      // --- 1. 标题栏 + 删除按钮 ---
      Flex({
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }) {
        Text(`费用项 ${this.index + 1}`)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)

        Button('删除')
          .fontSize(14)
          .height(32)
          .backgroundColor('#ff4d4f')
          .onClick(() => {
            this.onDelete()
          })
      }
      .width('100%')

      // --- 2. 费用类型 (使用 Select) ---
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center
      }) {
        Text('类型:')
          .fontSize(14)
          .width(60)

        Select(this.typeOptions)
          .value(this.item.type) // 显示当前值
          .selected(this.getSelectedIndex())
          .font({ size: 14 })
          .fontColor('#333')
          .selectedOptionFont({ size: 16, weight: FontWeight.Medium })
          .optionFont({ size: 14 })
          .height(32)
          .backgroundColor('#f0f0f0')
          .borderRadius(4)
          .layoutWeight(1)
          .onSelect((index: number, value: string) => {
            this.item.type = value
          })
      }

      // --- 3. 金额输入 + 计算器按钮 ---
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center
      }) {
        Text('金额:')
          .fontSize(14)
          .width(60)

        TextInput({
          placeholder: '0.00',
          text: $$this.item.amount // 双向绑定
        })
          .type(InputType.Normal)
          .layoutWeight(1)
          .height(32)
          .backgroundColor('#f0f0f0')
          .borderRadius(4)
          .onChange((value: string) => {
            this.onValueChange()
          })

        Button('计算器')
          .fontSize(12)
          .height(32)
          .margin({ left: 8 })
          .backgroundColor('#1890ff')
          .onClick(() => {
            // 点击时触发父组件的回调
            this.onShowCalculator(this.index)
          })
      }

      // --- 4. 备注输入 ---
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center
      }) {
        Text('备注:')
          .fontSize(14)
          .width(60)

        TextInput({
          placeholder: '请输入备注 (选填)',
          text: this.item.remarks
        })
          .layoutWeight(1)
          .height(32)
          .backgroundColor('#f0f0f0')
          .borderRadius(4)
          .onChange((value: string) => {
            this.item.remarks = value
          })
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#fafafa')
    .borderRadius(8)
    .shadow({ radius: 4, color: '#1a000000', offsetY: 1 })
  }

  private getSelectedIndex(): number {
    let index = this.typeOptions.findIndex(opt => opt.value === this.item.type)
    return index >= 0 ? index : 0
  }
}