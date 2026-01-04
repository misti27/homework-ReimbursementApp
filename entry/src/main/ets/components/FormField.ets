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
        .onChange((value: string) => {
          this.onChange(value ?? '')
        })
    }
    .width('100%')
    .height(48)
  }
}