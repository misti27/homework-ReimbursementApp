import { HistoryRecord } from '../models/HistoryRecord';
import { StorageService } from '../utils/StorageService';

@CustomDialog
export struct HistoryDialog {
  controller?: CustomDialogController

  @StorageLink('appHistoryStr') appHistoryStr: string = '[]'
  @State historyList: HistoryRecord[] = []

  aboutToAppear() {
    this.historyList = StorageService.getHistory();
  }

  build() {
    Column() {
      // --- 标题栏 ---
      Row() {
        Text('历史提交记录')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#182431')

        Text('×')
          .fontSize(28)
          .fontColor('#999999')
          .fontWeight(FontWeight.Regular)
          .onClick(() => {
            this.controller?.close()
          })
          .padding({ left: 10, bottom: 4 })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .padding({ left: 20, right: 20, top: 20, bottom: 10 })

      Divider().color('#F1F3F5').margin({ bottom: 10 })

      // --- 内容区 ---
      if (this.historyList.length === 0) {
        Column({ space: 15 }) {
          Stack() {
            Circle({ width: 60, height: 60 }).fill('#F5F7FA')
            Text('📂').fontSize(30)
          }
          Text('暂无历史记录').fontSize(15).fontColor('#999999')
        }
        .height(200)
        .justifyContent(FlexAlign.Center)
        .width('100%')
      } else {
        List({ space: 12 }) {
          ForEach(this.historyList, (item: HistoryRecord) => {
            ListItem() {
              Row() {
                // 头像
                Stack({ alignContent: Alignment.Center }) {
                  Circle({ width: 40, height: 40 }).fill('#E3F2FD')
                  Text(item.reimburser.substring(0, 1))
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#007DFF')
                }
                .margin({ right: 12 })

                // 中间信息
                Column({ space: 4 }) {
                  Row() {
                    Text(item.reimburser)
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#182431')
                    Text(item.department)
                      .fontSize(10)
                      .fontColor('#666666')
                      .backgroundColor('#F1F3F5')
                      .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                      .borderRadius(4)
                      .margin({ left: 8 })
                  }
                  Text(item.submitDate)
                    .fontSize(12)
                    .fontColor('#999999')
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                // 右侧金额
                Column({ space: 4 }) {
                  Text(`¥${item.totalAmount}`)
                    .fontSize(18)
                    .fontColor('#182431')
                    .fontWeight(FontWeight.Bold)
                  Text('已提交')
                    .fontSize(11)
                    .fontColor('#52C41A')
                }
                .alignItems(HorizontalAlign.End)
              }
              .width('100%')
              .padding(16)
              .backgroundColor('#FFFFFF')
              .borderRadius(12)
              .border({ width: 1, color: '#F5F7FA' })
            }
          })
        }
        .width('100%')
        .height(350)
        .padding({ left: 16, right: 16 })
        .edgeEffect(EdgeEffect.Spring)
      }

      Blank().height(20)
    }
    .width('90%')
    .backgroundColor('#FFFFFF')
    .borderRadius(24)
    .shadow({ radius: 20, color: 'rgba(0,0,0,0.1)', offsetY: 10 })
  }
}