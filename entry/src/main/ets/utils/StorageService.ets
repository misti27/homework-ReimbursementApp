import promptAction from '@ohos.promptAction';
import { HistoryRecord } from '../models/HistoryRecord'; // 确保路径正确

export class StorageService {
  private static readonly KEY = 'appHistoryStr';

  static getHistory(): HistoryRecord[] {
    let result: HistoryRecord[] = [];
    try {
      const jsonStr = AppStorage.Get<string>(StorageService.KEY);

      if (!jsonStr || jsonStr === '[]') {
        return [];
      }

      const parsed: object = JSON.parse(jsonStr) as object;

      if (Array.isArray(parsed)) {
        // 这里使用 'as' 强制转换为我们需要的数组类型
        result = parsed as HistoryRecord[];
      }
    } catch (e) {
      console.error('StorageService 读取失败:', JSON.stringify(e));
      promptAction.showToast({ message: '读取历史记录异常' });
      return [];
    }
    return result;
  }

  static saveRecord(record: HistoryRecord): boolean {
    try {
      const currentList = StorageService.getHistory();
      currentList.unshift(record);
      const newJsonStr = JSON.stringify(currentList);
      AppStorage.SetOrCreate(StorageService.KEY, newJsonStr);

      return true;
    } catch (e) {
      console.error('StorageService 保存失败:', JSON.stringify(e));
      // 失败时弹窗提示具体原因
      promptAction.showToast({ message: '保存失败，请检查存储空间' });

      return false;
    }
  }

  static clearHistory(): void {
    try {
      AppStorage.SetOrCreate(StorageService.KEY, '[]');
      promptAction.showToast({ message: '历史记录已清空' });
    } catch (e) {
      console.error('StorageService 清空失败:', JSON.stringify(e));
    }
  }
}