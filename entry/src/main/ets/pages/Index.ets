import { FormData, ExpenseItem, HistoryRecord } from '../models/FormData'
import { BaseInfo } from '../components/BaseInfo'
import { ExpenseItemSection } from '../components/ExpenseItem'
import { Calculator } from '../components/Calculator'
import { ActionButtons } from '../components/ActionButtons'
import router from '@ohos.router';

// --- 1. 定义历史记录弹窗组件 ---
@CustomDialog
struct HistoryDialog {
  // 由 controller 控制弹窗开关
  controller?: CustomDialogController
  @State historyList: HistoryRecord[] = []

  aboutToAppear() {
    // 加载数据
    const str = AppStorage.Get<string>('appHistoryStr') || '[]'
    try {
      this.historyList = JSON.parse(str)
    } catch (e) {
      this.historyList = []
    }
  }

  // 格式化时间
  formatTime(ts: number): string {
    const date = new Date(ts)
    return `${date.getMonth() + 1}-${date.getDate()} ${date.getHours()}:${date.getMinutes().toString().padStart(2, '0')}`
  }

  build() {
    Column() {
      // 弹窗标题
      Text('提交历史记录')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })

      if (this.historyList.length === 0) {
        // 空状态
        Column() {
          Text('暂无历史记录').fontColor('#999').margin({ top: 30 })
        }
        .height(150)
        .width('100%')
      } else {
        // 列表
        List() {
          ForEach(this.historyList, (item: HistoryRecord) => {
            ListItem() {
              Row() {
                Column({ space: 4 }) {
                  Text(item.summary) // 显示 "张三 - 北京"
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                  Text(this.formatTime(item.timestamp))
                    .fontSize(12)
                    .fontColor('#999')
                }
                .alignItems(HorizontalAlign.Start)

                Blank()

                Text(`¥${item.totalAmount.toFixed(2)}`)
                  .fontSize(16)
                  .fontColor('#ff4d4f')
                  .fontWeight(FontWeight.Bold)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              .backgroundColor(Color.White)
            }
          })
        }
        .width('100%')
        .height(300) // 限制列表高度
        .divider({ strokeWidth: 1, color: '#f0f0f0' })
      }

      // 关闭按钮
      Button('关闭')
        .width('80%')
        .margin({ top: 20, bottom: 20 })
        .onClick(() => {
          this.controller?.close()
        })
    }
    .backgroundColor(Color.White)
    .borderRadius(16)
    .width('90%')
  }
}

// --- 2. Index 主页面 ---
@Entry
@Component
struct Index {
  @Provide('formData') formData: FormData = new FormData()
  @Provide('expenseList') expenseList: ExpenseItem[] = []

  @State showCalculator: boolean = false
  @State calculatorTargetIndex: number = -1

  // 注册弹窗控制器
  historyDialogController: CustomDialogController = new CustomDialogController({
    builder: HistoryDialog(),
    autoCancel: true,
    alignment: DialogAlignment.Center
  })

  // 【核心逻辑】页面显示时，检查是否需要清空表单
  onPageShow() {
    const shouldClear = AppStorage.Get<boolean>('shouldClearForm')
    if (shouldClear) {
      // 1. 重置数据
      this.formData = new FormData()
      this.expenseList = []

      // 2. 重置标记，防止无限清空
      AppStorage.SetOrCreate('shouldClearForm', false)

      // 可选：给个轻提示
      console.info('表单已自动清空')
    }
  }

  // 跳转逻辑
  goToPreviewPage() {
    router.pushUrl({
      url: 'pages/Preview',
      params: {
        formDataStr: JSON.stringify(this.formData),
        expenseListStr: JSON.stringify(this.expenseList)
      }
    }, router.RouterMode.Standard, (err) => {
      if (err) console.error(`跳转失败: ${err.message}`)
    })
  }

  build() {
    Column() {
      // 1. 顶部标题栏
      Row() {
        Text('商务差旅报销系统')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .width('100%')
      .height(56)
      .backgroundColor('#1890ff')
      .justifyContent(FlexAlign.Center)

      // 2. 主内容区域 (Scroll)
      Scroll() {
        Column({ space: 16 }) {
          BaseInfo()

          ExpenseItemSection({
            onShowCalculator: (show: boolean, index: number) => {
              this.showCalculator = show
              this.calculatorTargetIndex = index
            }
          })

          ActionButtons({
            onShowPreview: (show: boolean) => {
              if (show) this.goToPreviewPage()
            }
          })
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1) // 让内容区占据中间剩余空间
      .width('100%')

      // 3. 【新增】底部历史记录入口
      Column() {
        Divider().color('#e8e8e8')
        Row() {
          Text('提交历史记录')
            .fontSize(14)
            .fontColor('#666')

        }
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.White)
        .onClick(() => {
          // 打开弹窗
          this.historyDialogController.open()
        })
      }
      .width('100%')

      // 计算器弹窗 (保持原样)
      if (this.showCalculator) {
        Calculator({
          targetIndex: this.calculatorTargetIndex,
          onClose: () => {
            this.showCalculator = false
          }
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}