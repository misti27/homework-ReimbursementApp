// src/main/ets/components/FormField.ets

@Component
export struct FormField {
  @Prop label: string = ''
  @Prop value: string = '' // 【重要】改回 @Prop，解决报错
  @Prop placeholder: string = ''
  @Prop required: boolean = false
  onChange: (value: string) => void = () => {}

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.SpaceBetween
    }) {
      Row() {
        if (this.required) {
          Text('*')
            .fontSize(16)
            .fontColor('#ff4d4f')
            .margin({ right: 4 })
        }
        Text(this.label)
          .fontSize(16)
          .width(80)
      }

      TextInput({
        placeholder: this.placeholder,
        text: this.value
      })
        .width('60%')
        .height(40) // 确保高度一致
        .backgroundColor('#F1F3F5') // 统一背景色
        .borderRadius(20) // 统一圆角
        .onChange((value: string) => {
          this.onChange(value)
        })
    }
    .width('100%')
    .height(48)
  }
}

/**
 * 日期选择组件（DateFormField）
 * 保持不变，它使用 @Prop 是正确的
 */
@Component
export struct DateFormField {
  @Prop label: string = ''
  @Prop value: string = ''
  @Prop placeholder: string = ''
  @Prop required: boolean = false
  onDateClick: () => void = () => {}

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.SpaceBetween
    }) {
      Row() {
        if (this.required) {
          Text('*')
            .fontSize(16)
            .fontColor('#ff4d4f')
            .margin({ right: 4 })
        }
        Text(this.label)
          .fontSize(16)
          .width(80)
      }

      Row() {
        Text(this.value || this.placeholder)
          .fontSize(16)
          .fontColor(this.value ? '#182431' : '#999999')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('60%')
      .height(40)
      .backgroundColor('#F1F3F5')
      .borderRadius(20)
      .padding({ left: 16, right: 16 })
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        this.onDateClick()
      })
    }
    .width('100%')
    .height(48)
  }
}