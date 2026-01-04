import { FormData, ExpenseItem } from '../models/FormData'

@Component
export struct ActionButtons {
  @Consume('formData') formData: FormData
  @Consume('expenseList') expenseList: ExpenseItem[]
  onShowPreview: (show: boolean) => void = () => {}

  handleSubmit() {
    try {
      const validation = this.formData?.validate() ?? { isValid: false, errors: ['表单数据无效'] }

      if (!validation.isValid) {
        AlertDialog.show({
          message: validation.errors.join('\n')
        })
        return
      }

      if ((this.expenseList?.length ?? 0) === 0) {
        AlertDialog.show({ message: '请至少添加一项费用明细' })
        return
      }

      this.onShowPreview(true)

    } catch (error) {
      console.error('提交处理异常:', error)
      AlertDialog.show({ message: '提交失败，请重试' })
    }
  }

  handleReset() {
    AlertDialog.show({
      message: '确定要清空表单吗？',
      primaryButton: {
        value: '确定',
        action: () => {
          try {
            this.formData.travelerName = ''
            this.formData.department = ''
            this.formData.purpose = ''
            this.formData.startDate = ''
            this.formData.endDate = ''
            this.formData.travelCity = ''
            this.expenseList.splice(0, this.expenseList.length)
          } catch (error) {
            console.error('重置表单异常:', error)
          }
        }
      },
      secondaryButton: {
        value: '取消',
        action: () => {}
      }
    })
  }

  build() {
    Flex({
      justifyContent: FlexAlign.SpaceEvenly,
      alignItems: ItemAlign.Center
    }) {
      Button('预览提交')
        .width('45%')
        .height(48)
        .fontSize(16)
        .backgroundColor('#1890ff')
        .onClick(() => this.handleSubmit())

      Button('清空表单')
        .width('45%')
        .height(48)
        .fontSize(16)
        .backgroundColor('#ff4d4f')
        .onClick(() => this.handleReset())
    }
    .width('100%')
    .margin({ top: 24, bottom: 16 })
  }
}