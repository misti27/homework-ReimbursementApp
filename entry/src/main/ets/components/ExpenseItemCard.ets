import { ExpenseItem } from '../models/FormData'

@Component
export struct ExpenseItemCard {
  @ObjectLink item: ExpenseItem
  @Prop index: number = 0
  onDelete: () => void = () => {}
  onShowCalculator: (index: number) => void = () => {}
  onValueChange: () => void = () => {}

  @State expenseTypes: string[] = ['交通费', '住宿费', '餐饮费', '其他']
  @State showTypePicker: boolean = false

  build() {
    Column({ space: 12 }) {
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

      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center
      }) {
        Text('类型:')
          .fontSize(14)
          .width(60)

        Button() {
          Text(this.item.type)
            .fontSize(14)
            .fontColor('#333')
        }
        .type(ButtonType.Normal) // 设为普通按钮样式
        .layoutWeight(1)
        .backgroundColor('#f0f0f0')
        .height(32)
        .borderRadius(4)
        .onClick(() => {
          animateTo({ duration: 200 }, () => {
            this.showTypePicker = !this.showTypePicker
          })
        })
      }

      if (this.showTypePicker) {
        Column() {
          ForEach(this.expenseTypes, (type: string) => {
            Button(type)
              .width('100%')
              .backgroundColor(this.item.type === type ? '#1890ff' : '#f0f0f0')
              .fontColor(this.item.type === type ? Color.White : '#333')
              .margin({ top: 4 })
              .onClick(() => {
                this.item.type = type
                this.showTypePicker = false
              })
          })
        }
        .width('100%')
        .padding(8)
        .backgroundColor('#fafafa')
        .borderRadius(4)
      }

      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center
      }) {
        Text('金额:')
          .fontSize(14)
          .width(60)

        TextInput({
          placeholder: '0.00',
          text: $$this.item.amount
        })
          .type(InputType.Number)
          .layoutWeight(1)
          .onChange((value: string) => {
            try {
              this.onValueChange()
            } catch (error) {
              console.error('金额输入异常:', error)
            }
          })

        Button('计算器')
          .fontSize(12)
          .height(32)
          .margin({ left: 8 })
          .backgroundColor('#1890ff')
          .onClick(() => {
            this.onShowCalculator(this.index)
          })
      }

      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Start
      }) {
        Text('备注:')
          .fontSize(14)
          .width(60)
          .margin({ top: 8 })

        TextInput({
          placeholder: '请输入备注',
          text: this.item.remarks
        })
          .layoutWeight(1)
          .onChange((value: string) => {
            this.item.remarks = value ?? ''
          })
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#fafafa')
    .borderRadius(8)
  }
}