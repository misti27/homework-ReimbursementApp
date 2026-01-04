
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

        ListItem() {
          FormField({
            label: '开始日期',
            value: this.formData.startDate,
            placeholder: '例如: 2024-01-15',
            required: true,
            onChange: (val: string) => {
              this.formData.startDate = val
            }
          })
        }

        ListItem() {
          FormField({
            label: '结束日期',
            value: this.formData.endDate,
            placeholder: '例如: 2024-01-20',
            required: true,
            onChange: (val: string) => {
              this.formData.endDate = val
            }
          })
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
