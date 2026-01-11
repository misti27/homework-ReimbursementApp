// entry/src/main/ets/pages/Index.ets
import { FormData, ExpenseItem } from '../models/FormData';
import { BaseInfo } from '../components/BaseInfo';
import { ExpenseItemSection } from '../components/ExpenseItem';
import { ActionButtons } from '../components/ActionButtons';
import { Preview } from './Preview';
import { Calculator } from '../components/Calculator'; // 【新增】引入计算器

// 【新增】定义历史记录的数据结构（需适配 Preview.ets 中保存的格式）
interface HistoryRecord {
  id: number;
  submitDate: string;
  totalAmount: string;
  department: string;
  reimburser: string;
}

// 【新增】历史记录弹窗组件
@CustomDialog
struct HistoryDialog {
  controller?: CustomDialogController
  @StorageLink('appHistoryStr') appHistoryStr: string = '[]'
  @State historyList: HistoryRecord[] = []

  aboutToAppear() {
    try {
      // 解析存储的 JSON 字符串
      const parsed: object = JSON.parse(this.appHistoryStr);
      if (Array.isArray(parsed)) {
        this.historyList = parsed as HistoryRecord[];
      }
    } catch (e) {
      this.historyList = [];
    }
  }

  build() {
    Column() {
      Text('历史提交记录')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 15 })

      if (this.historyList.length === 0) {
        Column() {
          Text('暂无历史记录')
            .fontSize(16)
            .fontColor(Color.Gray)
        }
        .height(100)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 10 }) {
          ForEach(this.historyList, (item: HistoryRecord) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item.submitDate)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                  Blank()
                  Text(`¥${item.totalAmount}`)
                    .fontSize(16)
                    .fontColor('#ff4d4f')
                    .fontWeight(FontWeight.Bold)
                }
                .width('100%')

                Row() {
                  Text(`${item.reimburser} | ${item.department}`)
                    .fontSize(12)
                    .fontColor(Color.Gray)
                    .margin({ top: 4 })
                }
                .width('100%')
              }
              .width('100%')
              .padding(12)
              .backgroundColor('#f5f5f5')
              .borderRadius(8)
            }
          })
        }
        .width('100%')
        .height(300)
        .padding({ left: 16, right: 16 })
      }

      Button('关闭')
        .width('80%')
        .margin({ top: 15, bottom: 20 })
        .onClick(() => {
          this.controller?.close()
        })
    }
    .width('90%')
    .backgroundColor(Color.White)
    .borderRadius(16)
  }
}

@Entry
@Component
struct Index {
  @Provide formData: FormData = new FormData();
  @Provide expenseList: ExpenseItem[] = [];

  // 核心状态：控制显示预览还是编辑
  @State showPreview: boolean = false;

  // 【新增】计算器相关状态
  @State showCalculator: boolean = false;
  @State currentExpenseIndex: number = -1;

  // 【新增】注册历史记录弹窗控制器
  dialogController: CustomDialogController = new CustomDialogController({
    builder: HistoryDialog(),
    autoCancel: true,
    alignment: DialogAlignment.Center
  })

  onPageShow() {
    const shouldClear = AppStorage.get<boolean>('shouldClearForm');
    if (shouldClear) {
      this.formData = new FormData();
      this.expenseList = [];
      AppStorage.set('shouldClearForm', false);
    }
  }

  build() {
    // 【修改】使用 Stack 布局，以便计算器层可以覆盖在页面上方
    Stack() {
      // --- 底层：主页面内容 ---
      Column() {
        // 使用条件渲染实现“页面切换”效果
        if (this.showPreview) {
          // --- 预览模式 ---
          Preview({
            formData: $formData,
            expenseList: $expenseList,
            showPreview: $showPreview
          })
            .transition(TransitionEffect.OPACITY.animation({ duration: 300 }))

        } else {
          // --- 编辑模式 (原主页内容) ---
          Column() {
            // 1. 标题栏
            Row() {
              Text('商务差旅报销')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)

              Blank()

              // 历史记录按钮
              Text('历史记录')
                .fontSize(14)
                .fontColor('#007DFF')
                .onClick(() => {
                  // 【修改】点击打开弹窗
                  this.dialogController.open()
                })
            }
            .width('100%')
            .height(50)
            .padding({ left: 20, right: 20 })
            .backgroundColor('#fff')
            .shadow({ radius: 2, color: '#f0f0f0', offsetY: 1 })
            .zIndex(1)

            // 2. 表单内容区
            Scroll() {
              Column({ space: 20 }) {
                BaseInfo() // 内部 @Consume 自动获取数据

                // 【修改】传递 onShowCalculator 回调
                ExpenseItemSection({
                  onShowCalculator: (show: boolean, index: number) => {
                    this.currentExpenseIndex = index;
                    this.showCalculator = true;
                  }
                })

                Blank().height(80)
              }
              .padding({ top: 15, bottom: 15 })
            }
            .layoutWeight(1)
            .scrollBar(BarState.Off)
            .align(Alignment.Top)

            // 3. 底部操作栏
            ActionButtons({ showPreview: $showPreview })
          }
          .height('100%')
          .backgroundColor('#F1F3F5')
          .transition(TransitionEffect.OPACITY.animation({ duration: 300 }))
        }
      }
      .height('100%')
      .width('100%')

      // --- 顶层：计算器组件 ---
      // 当需要在当前页面显示计算器时渲染
      if (!this.showPreview && this.showCalculator) {
        Calculator({
          targetIndex: this.currentExpenseIndex,
          onClose: () => {
            this.showCalculator = false;
          }
        })
          .zIndex(999) // 确保显示在最上层
          .transition(TransitionEffect.OPACITY.animation({ duration: 200 }))
      }
    }
    .height('100%')
    .width('100%')
  }
}