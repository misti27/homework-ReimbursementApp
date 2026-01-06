import { FormData } from '../models/FormData'
import { FormField } from './FormField'

@Component
export struct BaseInfo {
  @Consume('formData') formData: FormData

  build() {
    Column() {
      Text('基本信息')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 12 })

      List({ space: 12 }) {

        ListItem() {
          FormField({
            label: '出差人',
            value: this.formData.travelerName,
            placeholder: '请输入姓名',
            required: true,
            onChange: (val: string) => {
              this.formData.travelerName = val
            }
          })
        }

        ListItem() {
          FormField({
            label: '部门',
            value: this.formData.department,
            placeholder: '请输入部门',
            required: true,
            onChange: (val: string) => {
              this.formData.department = val
            }
          })
        }

        ListItem() {
          FormField({
            label: '出差事由',
            value: this.formData.purpose,
            placeholder: '请输入出差事由',
            required: true,
            onChange: (val: string) => {
              this.formData.purpose = val
            }
          })
        }

        // ===== 开始日期 =====
        ListItem() {
          Row() {
            Text('开始日期')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .width(80)

            Text(this.formData.startDate || '请选择日期')
              .fontSize(14)
              .onClick(() => {
                DatePickerDialog.show({
                  start: new Date(2000, 0, 1),
                  end: new Date(2100, 11, 31),
                  onAccept: (value: DatePickerResult) => {
                    const year = value.year
                    const month = String((value.month??0) + 1).padStart(2, '0')
                    const day = String(value.day).padStart(2, '0')

                    this.formData.startDate = `${year}-${month}-${day}`
                  }
                })
              })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
        }

        // ===== 结束日期 =====
        ListItem() {
          Row() {
            Text('结束日期')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .width(80)

            Text(this.formData.endDate || '请选择日期')
              .fontSize(14)
              .onClick(() => {
                DatePickerDialog.show({
                  start: new Date(2000, 0, 1),
                  end: new Date(2100, 11, 31),
                  onAccept: (value: DatePickerResult) => {
                    const year = value.year
                    const month = String((value.month??0) + 1).padStart(2, '0')
                    const day = String(value.day).padStart(2, '0')

                    this.formData.endDate = `${year}-${month}-${day}`
                  }
                })
              })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
        }

        ListItem() {
          FormField({
            label: '出差城市',
            value: this.formData.travelCity,
            placeholder: '请输入城市',
            onChange: (val: string) => {
              this.formData.travelCity = val
            }
          })
        }
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(8)
      .padding(16)
    }
    .width('100%')
  }
}
