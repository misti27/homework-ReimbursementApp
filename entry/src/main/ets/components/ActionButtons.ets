// entry/src/main/ets/components/ActionButtons.ets
import { FormData, ExpenseItem } from '../models/FormData';
import promptAction from '@ohos.promptAction';

@Component
export struct ActionButtons {
  @Consume formData: FormData;
  @Consume expenseList: ExpenseItem[];

  // 新增：接收主页传来的状态控制
  @Link showPreview: boolean;

  build() {
    Row({ space: 15 }) {
      // 清空按钮
      Button('清空')
        .backgroundColor('#F5F5F5')
        .fontColor(Color.Red)
        .layoutWeight(1)
        .onClick(() => {
          this.formData = new FormData();
          this.expenseList = [];
          promptAction.showToast({ message: '表单已清空' });
        })

      // 预览提交按钮
      Button('预览提交')
        .type(ButtonType.Capsule)
        .layoutWeight(2)
        .onClick(() => {
          // 1. 校验逻辑
          if (this.formData.validate()) {
            if (this.expenseList.length === 0) {
              promptAction.showToast({ message: '请至少添加一条费用明细' });
              return;
            }

            // 2. 关键：切换到预览模式，不再使用 router.pushUrl
            this.showPreview = true;

          } else {
            promptAction.showToast({ message: '请完善必填信息 (*)' });
          }
        })
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 10, bottom: 20 })
    .backgroundColor(Color.White)
    .shadow({ radius: 10, color: '#0d000000', offsetY: -5 })
  }
}