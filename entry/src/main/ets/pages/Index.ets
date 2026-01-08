// entry/src/main/ets/pages/Index.ets
import { FormData, ExpenseItem } from '../models/FormData';
import { BaseInfo } from '../components/BaseInfo';
import { ExpenseItemSection } from '../components/ExpenseItem'; // 确认此组件导出的名字
import { ActionButtons } from '../components/ActionButtons';
import { Preview } from './Preview'; // 引入同一目录下的 Preview 组件

@Entry
@Component
struct Index {
  @Provide formData: FormData = new FormData();
  @Provide expenseList: ExpenseItem[] = [];

  // 核心状态：控制显示预览还是编辑
  @State showPreview: boolean = false;

  // 这里的 onPageShow 逻辑其实可以简化了，因为页面不跳转了
  // 但为了保留从历史记录弹窗可能的操作习惯，保留也无妨
  onPageShow() {
    const shouldClear = AppStorage.Get<boolean>('shouldClearForm');
    if (shouldClear) {
      this.formData = new FormData();
      this.expenseList = [];
      AppStorage.Set('shouldClearForm', false);
    }
  }

  build() {
    Column() {
      // 使用条件渲染实现“页面切换”效果
      if (this.showPreview) {
        // --- 预览模式 ---
        // 使用 $ 传递引用，实现 @Link 双向绑定
        Preview({
          formData: $formData,
          expenseList: $expenseList,
          showPreview: $showPreview
        })
        // 添加一个转场动画让切换更自然
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

            // 可以在这里加回你的历史记录按钮
            Text('历史记录')
              .fontSize(14)
              .fontColor('#007DFF')
              .onClick(() => {
                // 如果你有 CustomDialogController，在这里调用 open()
                // this.dialogController.open()
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

              ExpenseItemSection() // 内部 @Consume 自动获取数据

              Blank().height(80)
            }
            .padding({ top: 15, bottom: 15 })
          }
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .align(Alignment.Top)

          // 3. 底部操作栏
          // 关键：把 $showPreview 传进去，让按钮能控制开关
          ActionButtons({ showPreview: $showPreview })
        }
        .height('100%')
        .backgroundColor('#F1F3F5')
        .transition(TransitionEffect.OPACITY.animation({ duration: 300 }))
      }
    }
    .height('100%')
    .width('100%')
  }
}