@Component
export struct FormField {
  @Prop label: string = ''
  @Prop value: string = ''
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
        .height(40)
        .backgroundColor('#F1F3F5')
        .borderRadius(20)
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