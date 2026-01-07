import { FormData } from '../models/FormData'
import { FormField, DateFormField } from './FormField'

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

        // 1. 出差人
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

        // 2. 部门
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

        // 3. 出差事由
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

        // 4. 开始日期 (使用 DateFormField)
        ListItem() {
          DateFormField({
            label: '开始日期',
            value: this.formData.startDate,
            placeholder: '请选择日期',
            required: true,
            onDateClick: () => {
              DatePickerDialog.show({
                start: new Date(2000, 0, 1),
                end: new Date(2100, 11, 31),
                onAccept: (value: DatePickerResult) => {
                  const year = value.year
                  const month = String((value.month ?? 0) + 1).padStart(2, '0')
                  const day = String(value.day).padStart(2, '0')
                  this.formData.startDate = `${year}-${month}-${day}`
                }
              })
            }
          })
        }

        // 5. 结束日期 (使用 DateFormField)
        ListItem() {
          DateFormField({
            label: '结束日期',
            value: this.formData.endDate,
            placeholder: '请选择日期',
            required: true,
            onDateClick: () => {
              DatePickerDialog.show({
                start: new Date(2000, 0, 1),
                end: new Date(2100, 11, 31),
                onAccept: (value: DatePickerResult) => {
                  const year = value.year
                  const month = String((value.month ?? 0) + 1).padStart(2, '0')
                  const day = String(value.day).padStart(2, '0')
                  this.formData.endDate = `${year}-${month}-${day}`
                }
              })
            }
          })
        }

        // 6. 出差城市
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