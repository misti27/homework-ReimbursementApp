import { FormData, ExpenseItem } from '../models/FormData';
import { HistoryRecord } from '../models/HistoryRecord';
import promptAction from '@ohos.promptAction';
import { StorageService } from '../utils/StorageService';

@Component
export struct Preview {
  @Link formData: FormData;
  @Link expenseList: ExpenseItem[];
  @Link showPreview: boolean;

  // 计算总金额
  private calculateTotal(): string {
    let total = 0;
    this.expenseList.forEach(item => {
      // 转换金额，如果为空默认为 '0'
      let val = parseFloat(item.amount || '0');
      if (!isNaN(val)) total += val;
    });
    // 保留两位小数，返回字符串
    return total.toFixed(2);
  }

  // 提交并保存历史记录
  submitForm() {
    let newRecord = new HistoryRecord();

    newRecord.id = new Date().getTime().toString(); // 转为 string
    newRecord.submitDate = new Date().toLocaleDateString();
    newRecord.totalAmount = this.calculateTotal();
    newRecord.department = this.formData.department ?? '';
    newRecord.reimburser = this.formData.travelerName ?? '';

    // 调用保存方法，并接收返回值
    const isSuccess = StorageService.saveRecord(newRecord);

    // 判断结果
    if (isSuccess) {
      promptAction.showToast({ message: '提交成功' });

      // 清空表单
      this.formData = new FormData();
      this.expenseList = [];

      // 返回编辑页
      this.showPreview = false;
    } else {
      console.warn('保存失败，保留现场');
    }

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
              // 调用封装好的计算方法
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
      Text(value || '-').layoutWeight(1)
    }
    .width('100%')
  }
}