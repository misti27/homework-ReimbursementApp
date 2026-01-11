import { FormData, ExpenseItem, ValidationResult } from '../models/FormData';
import promptAction from '@ohos.promptAction';

@Component
export struct ActionButtons {
  @Consume formData: FormData;
  @Consume expenseList: ExpenseItem[];
  @Link showPreview: boolean;

  build() {
    Row({ space: 15 }) {
      // --- 清空按钮 ---
      Button('清空')
        .backgroundColor('#F5F5F5')
        .fontColor(Color.Red)
        .layoutWeight(1)
        .onClick(() => {
          this.formData = new FormData();
          this.expenseList = [];
          promptAction.showToast({ message: '表单已清空' });
        })

      // --- 预览提交按钮 ---
      Button('预览提交')
        .type(ButtonType.Capsule)
        .layoutWeight(2)
        .onClick(() => {

          // 1. 基础表单校验 (使用类内部的方法)
          const formResult: ValidationResult = this.formData.validate();

          // 如果校验不通过，弹出第一条错误信息
          if (!formResult.isValid) {
            // 取出错误数组中的第一条提示
            const firstError = formResult.errors[0];
            promptAction.showToast({ message: `校验失败：${firstError}` });
            return;
          }


          // 2. 费用明细校验 (逻辑保持在 UI 层)
          // 2.1 检查列表是否为空
          if (!this.expenseList || this.expenseList.length === 0) {
            promptAction.showToast({ message: '校验失败：请至少添加一条费用明细' });
            return;
          }
          // 2.2 检查金额是否合法
          let invalidItemIndex = -1;

          this.expenseList.forEach((item, index) => {
            const amount = item.getAmountNumber();
            // 如果金额是 0 (说明转换失败或输入了0)，标记为非法
            if (amount <= 0) {
              invalidItemIndex = index;
            }
          });

          if (invalidItemIndex !== -1) {
            promptAction.showToast({ message: `校验失败：第 ${invalidItemIndex + 1} 条费用金额无效或为0` });
            return;
          }


          // 3. 全部通过 -> 进入预览
          promptAction.showToast({ message: '校验通过' });
          this.showPreview = true;
        })
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 10, bottom: 20 })
    .backgroundColor(Color.White)
    .shadow({ radius: 10, color: '#0d000000', offsetY: -5 })
  }
}