# 算法练习项目

## 项目结构

```
algorithm_practice/
├── README.md                    # 项目说明文档
├── template.dart               # 代码模板
├── array/                      # 数组相关算法
│   └── 001_two_sum.dart
├── string/                     # 字符串算法
├── linked_list/                # 链表算法
│   └── 206_reverse_linked_list.dart
├── stack_queue/                # 栈和队列
├── tree/                       # 树结构算法
│   └── 094_binary_tree_inorder_traversal.dart
├── graph/                      # 图算法
├── dynamic_programming/        # 动态规划
├── backtracking/              # 回溯算法
├── greedy/                    # 贪心算法
├── sorting/                   # 排序算法
├── binary_search/             # 二分查找
├── math/                      # 数学题
├── bit_manipulation/          # 位运算
├── design/                    # 设计题
└── contest/                   # 竞赛题目
```

## 使用说明

### 1. 创建新题目
复制 `template.dart` 到相应分类目录下，按照以下格式命名：
```
题号_题目英文名.dart
例如: 001_two_sum.dart
```

### 2. 代码规范
- 每个文件包含完整的题目信息（链接、难度、标签）
- 写明解题思路和复杂度分析
- 提供测试用例验证代码正确性
- 如有多种解法，提供不同实现

### 3. 学习路径推荐

#### 第一阶段：基础数据结构 (1-2个月)
1. **数组 (Array)**
   - 两数之和、三数之和
   - 数组去重、旋转数组
   - 滑动窗口问题

2. **字符串 (String)**
   - 字符串反转、回文判断
   - 字符串匹配、最长公共前缀

3. **链表 (Linked List)**
   - 链表反转、合并链表
   - 环形链表检测
   - 删除节点、链表排序

#### 第二阶段：线性结构 (2-3个月)
4. **栈和队列 (Stack & Queue)**
   - 有效括号、逆波兰表达式
   - 队列实现栈、栈实现队列
   - 滑动窗口最大值

#### 第三阶段：树和图 (2-3个月)
5. **树 (Tree)**
   - 二叉树遍历（前中后序）
   - 二叉搜索树操作
   - 树的深度、路径问题

6. **图 (Graph)**
   - BFS、DFS遍历
   - 最短路径算法
   - 拓扑排序

#### 第四阶段：进阶算法 (3-4个月)
7. **动态规划 (Dynamic Programming)**
   - 斐波那契数列、爬楼梯
   - 背包问题、最长子序列
   - 股票买卖问题

8. **回溯算法 (Backtracking)**
   - 全排列、组合问题
   - N皇后、数独求解
   - 子集生成

#### 第五阶段：优化技巧 (2-3个月)
9. **贪心算法 (Greedy)**
   - 区间调度、活动选择
   - 最小生成树

10. **二分查找 (Binary Search)**
    - 基本二分查找
    - 查找边界、旋转数组搜索

### 4. 刷题建议

- **每日计划**: 1-3题，循序渐进
- **时间控制**: 每题限时30-45分钟
- **复习机制**: 一周后重做，一月后再做
- **记录笔记**: 记录易错点和优化思路

### 5. 运行代码

```bash
# 运行单个文件
dart run algorithm_practice/array/001_two_sum.dart

# 编译并运行
dart compile exe algorithm_practice/array/001_two_sum.dart
./algorithm_practice/array/001_two_sum.exe
```

### 6. 推荐资源

- **LeetCode**: https://leetcode.com/
- **LeetCode中文**: https://leetcode.cn/
- **算法可视化**: https://visualgo.net/
- **Dart语言官方文档**: https://dart.dev/

## 进度追踪

在每个分类目录下可以创建 `progress.md` 来记录刷题进度：

```markdown
# 数组类题目进度

- [x] 001. 两数之和 (Easy) - 2024/01/01
- [ ] 015. 三数之和 (Medium)
- [ ] 011. 盛最多水的容器 (Medium)
```

祝你刷题愉快！💪