import { FormData, ExpenseItem, HistoryRecord } from '../models/FormData'
import router from '@ohos.router'

// 初始化持久化存储，key 为 'appHistoryStr'，默认值为空数组的 JSON
PersistentStorage.PersistProp('appHistoryStr', '[]')
// 初始化提交成功标记
AppStorage.SetOrCreate('submitSuccess', false)

@Entry
@Component
struct Preview {
  @State formData: FormData = new FormData()
  @State expenseList: ExpenseItem[] = []

  aboutToAppear() {
    try {
      const params = router.getParams() as Record<string, Object>;

      if (params) {
        // 1. 还原 FormData
        if (params['formDataStr']) {
          const jsonStr = params['formDataStr'] as string;
          const plainObj = JSON.parse(jsonStr) as Record<string, Object>;
          // 调用我们刚才写的构造函数
          this.formData = new FormData(plainObj);
        }

        // 2. 还原 ExpenseList
        if (params['expenseListStr']) {
          const jsonStr = params['expenseListStr'] as string;
          const plainArray = JSON.parse(jsonStr) as Array<Record<string, Object>>;

          this.expenseList = plainArray.map((itemData) => {
            // 调用构造函数，传入 itemData，这样 ID 不会变，且方法会恢复
            return new ExpenseItem(itemData);
          });
        }
      }
    } catch (error) {
      console.error('解析失败', error);
    }
  }

  // 获取总金额（原有方法）
  getTotalAmount(): number {
    return this.expenseList.reduce((sum, item) => {
      return sum + (item.getAmountNumber ? item.getAmountNumber() : 0)
    }, 0)
  }

  confirmSubmit() {
    try {
      // 1. 构建新的历史记录对象
      const newRecord: HistoryRecord = {
        id: Date.now().toString(),
        timestamp: Date.now(),
        totalAmount: this.getTotalAmount(),
        // 再次序列化，确保只存数据，不存类的方法
        summary: `${this.formData.travelerName || '未命名'} - ${this.formData.travelCity || '未知城市'}`,
        formDataStr: JSON.stringify(this.formData),
        expenseListStr: JSON.stringify(this.expenseList)
      }

      // 2. 获取现有的历史记录
      let historyStr = AppStorage.Get<string>('appHistoryStr') || '[]'
      let historyList = JSON.parse(historyStr) as HistoryRecord[]

      // 3. 添加新记录到头部
      historyList.unshift(newRecord)

      // 4. 保存回持久化存储
      AppStorage.SetOrCreate('appHistoryStr', JSON.stringify(historyList))

      // 5. 设置全局标记：告诉 Index 页面“我已经提交成功了，请清空表单”
      AppStorage.SetOrCreate('submitSuccess', true)

      // 6. 弹窗并返回
      AlertDialog.show({
        message: '提交成功！已保存到历史记录。',
        confirm: {
          value: '回到首页',
          action: () => {
            // 清空表单，返回 Index 页面
            AppStorage.SetOrCreate('shouldClearForm', true)
            router.back({ url: 'pages/Index' })
          }
        }
      })

    } catch (error) {
      console.error('保存历史记录失败:', error)
      AlertDialog.show({ message: '提交失败: ' + error.message })
    }
  }

  @Builder previewItem(label: string, value: string, highlight: boolean = false) {
    Flex({
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Start
    }) {
      Text(label + ':')
        .fontSize(15)
        .fontColor('#666')
        .width('35%')

      Text(value)
        .fontSize(15)
        .fontWeight(highlight ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(highlight ? '#1890ff' : '#333')
        .textAlign(TextAlign.End)
        .maxLines(3)
        .width('63%')
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .margin({ bottom: 8 })
  }

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Button('返回')
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .fontColor(Color.White)
          .onClick(() => {
            router.back()
          })

        Text('报销预览')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('').width(60) // 占位
      }
      .width('100%')
      .height(56)
      .backgroundColor('#1890ff')
      .padding({ left: 16, right: 16 })

      // 内容区域
      Scroll() {
        Column({ space: 16 }) {
          // 基本信息卡片
          Column() {
            Text('基本信息')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 12 })

            this.previewItem('出差人', this.formData.travelerName)
            this.previewItem('部门', this.formData.department)
            this.previewItem('出差事由', this.formData.purpose)
            this.previewItem('开始日期', this.formData.startDate)
            this.previewItem('结束日期', this.formData.endDate)
            this.previewItem('出差城市', this.formData.travelCity || '未填写')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(8)

          // 费用明细卡片
          Column() {
            Text('费用明细')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 12 })

            ForEach(this.expenseList, (item: ExpenseItem, index: number) => {
              Column({ space: 8 }) {
                Text(`${index + 1}. ${item.type}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .alignSelf(ItemAlign.Start)
                this.previewItem('金额', `¥${item.getAmountNumber().toFixed(2)}`)
                this.previewItem('备注', item.remarks || '无')
              }
              .width('100%')
              .padding(12)
              .backgroundColor('#f5f5f5')
              .borderRadius(8)
              .margin({ bottom: 8 })
            })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(8)

          // 总金额卡片
          Column() {
            this.previewItem('总金额', `¥${this.getTotalAmount().toFixed(2)}`, true)
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#e6f7ff')
          .borderRadius(8)

          // 底部按钮
          Flex({
            justifyContent: FlexAlign.SpaceEvenly,
            alignItems: ItemAlign.Center
          }) {
            Button('取消')
              .width('45%')
              .height(48)
              .fontSize(16)
              .backgroundColor('#d9d9d9')
              .fontColor('#333')
              .onClick(() => {
                router.back()
              })

            Button('确认提交')
              .width('45%')
              .height(48)
              .fontSize(16)
              .backgroundColor('#52c41a')
              .fontColor(Color.White)
              .onClick(() => {
                this.confirmSubmit()
              })
          }
          .width('100%')
          .margin({ top: 16, bottom: 24 })
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}