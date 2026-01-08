// entry/src/main/ets/pages/Preview.ets
import { FormData, ExpenseItem } from '../models/FormData';
import promptAction from '@ohos.promptAction';

class HistoryRecord {
  id: number = 0;
  submitDate: string = '';
  totalAmount: string = '';
  department: string = '';
  reimburser: string = ''; // 对应出差人
}

@Component
export struct Preview {
  // 使用 @Link 接收主页传来的数据引用
  @Link formData: FormData;
  @Link expenseList: ExpenseItem[];
  @Link showPreview: boolean; // 控制显隐的开关

  // 提交并保存历史记录
  submitForm() {
    // 1. 获取现有历史记录 (保持原有逻辑)
    let historyStr: string = AppStorage.Get<string>('appHistoryStr') || '[]';
    let historyList: HistoryRecord[] = [];

    try {
      // JSON.parse 返回的是 any，需要手动映射或断言，这里简单处理异常
      let parsed = JSON.parse(historyStr) as HistoryRecord[];
      if (Array.isArray(parsed)) {
        historyList = parsed;
      }    } catch (e) {
      historyList = [];
    }

    // 2. 计算总额
    let totalAmount = 0;
    this.expenseList.forEach(item => {
      // 满足作业要求：数值转换异常处理
      try {
        let val = parseFloat(item.amount || '0');
        if (!isNaN(val)) totalAmount += val;
      } catch (e) {
        console.error('Calculation error');
      }
    });

    let newRecord = new HistoryRecord();
    newRecord.id = new Date().getTime();
    newRecord.submitDate = new Date().toLocaleDateString();
    newRecord.totalAmount = totalAmount.toFixed(2);
    newRecord.department = this.formData.department || '';
    newRecord.reimburser = this.formData.travelerName;
    // 3. 保存
    historyList.unshift(newRecord);
    AppStorage.SetOrCreate('appHistoryStr', JSON.stringify(historyList));

    promptAction.showToast({ message: '提交成功！' });

    // 4. 清空表单
    this.formData = new FormData();
    this.expenseList = [];

    // 5. 关键：修改状态，返回编辑页
    this.showPreview = false;
  }

  build() {
    Column() {
      // --- 顶部标题 ---
      Row() {
        Text('报销单预览')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .height(50)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#F1F3F5')

      // --- 内容列表 ---
      List({ space: 15 }) {
        // 卡片1：基本信息
        ListItem() {
          Column({ space: 10 }) {
            Text('基本信息').fontWeight(FontWeight.Bold).fontSize(16)
            Divider()
            this.InfoRow('出差人', this.formData.travelerName)
            this.InfoRow('部门', this.formData.department)
            this.InfoRow('出差事由', this.formData.purpose)
            this.InfoRow('时间范围', `${this.formData.startDate} 至 ${this.formData.endDate}`)
            this.InfoRow('目的地', this.formData.travelCity)
          }
          .width('100%')
          .padding(15)
          .backgroundColor(Color.White)
          .borderRadius(10)
          .shadow({ radius: 5, color: '#1a000000', offsetY: 2 })
        }

        // 卡片2：费用明细
        ListItem() {
          Column({ space: 10 }) {
            Text('费用明细').fontWeight(FontWeight.Bold).fontSize(16)
            Divider()

            if (this.expenseList.length === 0) {
              Text('无费用明细').fontColor(Color.Gray)
            } else {
              ForEach(this.expenseList, (item: ExpenseItem) => {
                Row() {
                  Column() {
                    Text(item.type).fontWeight(FontWeight.Medium)
                  }
                  .alignItems(HorizontalAlign.Start)
                  Blank()
                  Text(`¥ ${item.amount}`).fontWeight(FontWeight.Bold).fontColor('#007DFF')
                }
                .width('100%')
                .padding({ top: 5, bottom: 5 })
              })
            }
            Divider().margin({ top: 10 })
            // 总计
            Row() {
              Text('总计金额').fontWeight(FontWeight.Bold)
              Blank()
              Text(`¥ ${this.calculateTotal()}`).fontSize(18).fontColor('#E84026').fontWeight(FontWeight.Bold)
            }
          }
          .width('100%')
          .padding(15)
          .backgroundColor(Color.White)
          .borderRadius(10)
          .shadow({ radius: 5, color: '#1a000000', offsetY: 2 })
        }
      }
      .layoutWeight(1)
      .padding(15)

      // --- 底部按钮 ---
      Row({ space: 20 }) {
        Button('返回修改')
          .backgroundColor('#F5F5F5')
          .fontColor('#333')
          .layoutWeight(1)
          .onClick(() => {
            // 直接修改 Link 变量返回
            this.showPreview = false;
          })

        Button('确认提交')
          .type(ButtonType.Capsule)
          .layoutWeight(1)
          .onClick(() => {
            this.submitForm();
          })
      }
      .width('100%')
      .padding(15)
      .backgroundColor(Color.White)
      .shadow({ radius: 10, color: '#0d000000', offsetY: -5 })
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
  }

  @Builder InfoRow(label: string, value: string) {
    Row() {
      Text(label).width(80).fontColor(Color.Gray)
      Text(value || '-').layoutWeight(1) // 简单使用 || 处理空显示
    }
    .width('100%')
  }

  calculateTotal(): string {
    let total = 0;
    this.expenseList.forEach(item => {
      let val = parseFloat(item.amount || '0');
      if (!isNaN(val)) total += val;
    });
    return total.toFixed(2);
  }
}