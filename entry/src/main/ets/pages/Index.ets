import { FormData, ExpenseItem } from '../models/FormData'
import { BaseInfo } from '../components/BaseInfo'
import { ExpenseItemSection } from '../components/ExpenseItem'
import { Calculator } from '../components/Calculator'
import { ActionButtons } from '../components/ActionButtons'
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @Provide('formData') formData: FormData = new FormData()
  @Provide('expenseList') expenseList: ExpenseItem[] = []

  @State showCalculator: boolean = false
  @State calculatorTargetIndex: number = -1

  build() {
    Column() {
      // 顶部标题栏
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

      // 主内容区域
      Scroll() {
        Column({ space: 16 }) {
          // 基本信息组件
          BaseInfo()

          // 费用明细组件
          ExpenseItemSection({
            onShowCalculator: (show: boolean, index: number) => {
              this.showCalculator = show
              this.calculatorTargetIndex = index
            }
          })

          // 操作按钮组件
          // 操作按钮组件
          ActionButtons({
            onShowPreview: (show: boolean) => {
              // 触发跳转逻辑，而不是修改状态
              if (show) {
                this.goToPreviewPage();
              }
            }
          })
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
      .width('100%')

      // 计算器弹窗
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

  // 定义跳转函数
  goToPreviewPage() {
    console.info('准备跳转到预览页...');

    router.pushUrl({
      url: 'pages/Preview',
      params: {
        // 将复杂对象转为字符串传递
        formDataStr: JSON.stringify(this.formData),
        expenseListStr: JSON.stringify(this.expenseList)
      }
    }, router.RouterMode.Standard, (err) => {
      if (err) {
        console.error(`跳转失败 Code: ${err.code}, Message: ${err.message}`);
      } else {
        console.info('跳转成功');
      }
    });
  }

}
