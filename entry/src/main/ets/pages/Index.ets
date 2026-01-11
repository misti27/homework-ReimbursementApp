// entry/src/main/ets/pages/Index.ets
import { FormData, ExpenseItem } from '../models/FormData';
import { BaseInfo } from '../components/BaseInfo';
import { ExpenseItemSection } from '../components/ExpenseItem';
import { ActionButtons } from '../components/ActionButtons';
import { Preview } from './Preview';
import { Calculator } from '../components/Calculator';
import { HistoryDialog } from '../components/HistoryDialog';
import { HistoryRecord } from '../models/HistoryRecord';

PersistentStorage.PersistProp('appHistoryStr', '[]');

@Entry
@Component
struct Index {
  @Provide formData: FormData = new FormData();
  @Provide expenseList: ExpenseItem[] = [];
  @State showPreview: boolean = false;
  // 计算器相关状态
  @State showCalculator: boolean = false;
  @State currentExpenseIndex: number = -1;

  // 注册历史记录弹窗控制器
  dialogController: CustomDialogController = new CustomDialogController({
    builder: HistoryDialog(),
    customStyle: true,
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
    // 使用 Stack 布局，以便计算器层可以覆盖在页面上方
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
          // --- 编辑模式  ---
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

                // 传递 onShowCalculator 回调
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