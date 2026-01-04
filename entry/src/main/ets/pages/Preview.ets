import { FormData, ExpenseItem } from '../models/FormData'
import router from '@ohos.router'

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

  // 获取总金额
  getTotalAmount(): number {
    return this.expenseList.reduce((sum, item) => {
      // 此时 item 是真正的 ExpenseItem 实例，方法可以调用
      return sum + (item.getAmountNumber ? item.getAmountNumber() : 0)
    }, 0)
  }

  confirmSubmit() {
    AlertDialog.show({
      message: '报销申请提交成功！',
      confirm: {
        value: '确定',
        action: () => {
          router.back()
        }
      }
    })
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