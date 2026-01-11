export class FormData {
  travelerName: string = ''
  department: string = ''
  purpose: string = ''
  startDate: string = ''
  endDate: string = ''
  travelCity: string = ''

  // 构造函数：支持从 JSON 对象还原数据
  constructor(data?: Record<string, Object>) {
    if (data) {
      // 从 JSON 对象中提取数据，使用 ?? 运算符提供默认值防止 null/undefined
      this.travelerName = (data['travelerName'] as string) ?? ''
      this.department = (data['department'] as string) ?? ''
      this.purpose = (data['purpose'] as string) ?? ''
      this.startDate = (data['startDate'] as string) ?? ''
      this.endDate = (data['endDate'] as string) ?? ''
      this.travelCity = (data['travelCity'] as string) ?? ''
    }
  }

  validate(): ValidationResult {
    const errors: string[] = []

    try {
      if (!(this.travelerName?.trim())) {
        errors.push('出差人姓名不能为空')
      }
      if (!(this.department?.trim())) {
        errors.push('部门不能为空')
      }
      if (!(this.purpose?.trim())) {
        errors.push('出差事由不能为空')
      }
      if (!this.startDate) {
        errors.push('开始日期不能为空')
      }
      if (!this.endDate) {
        errors.push('结束日期不能为空')
      }

      return {
        isValid: errors.length === 0,
        errors: errors
      }
    } catch (error) {
      console.error('表单验证异常:', error)
      return {
        isValid: false,
        errors: ['表单验证过程出现异常']
      }
    }
  }
}

@Observed
export class ExpenseItem {
  id: string = ''
  type: string = '交通费'
  amount: string = ''
  remarks: string = ''

  // 【修改】构造函数：区分“新建”和“还原”两种情况
  constructor(data?: Record<string, Object>) {
    if (data) {
      // 情况1：从 JSON 还原（预览页面使用），直接恢复原有的 ID 和数据
      this.id = (data['id'] as string) ?? ''
      this.type = (data['type'] as string) ?? '交通费'
      this.amount = (data['amount'] as string) ?? ''
      this.remarks = (data['remarks'] as string) ?? ''
    } else {
      // 情况2：新建对象（Index页面添加费用使用），生成新 ID
      // 这里保留你原来的 ID 生成逻辑
      this.id = Date.now().toString() + Math.random().toString(36).substr(2, 9)
    }
  }

  // 【保留】原有的金额获取逻辑，完全不变
  getAmountNumber(): number {
    try {
      const num = parseFloat(this.amount ?? '0')
      if (isNaN(num) || num < 0) {
        return 0
      }
      return num
    } catch (error) {
      console.error('金额转换异常:', error)
      return 0
    }
  }
}

export interface ValidationResult {
  isValid: boolean
  errors: string[]
}

