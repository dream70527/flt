/*
题目: 二叉树的中序遍历
链接: https://leetcode.com/problems/binary-tree-inorder-traversal/
难度: Easy
标签: Stack, Tree, Depth-First Search

题目描述:
给定一个二叉树的根节点 root ，返回它的中序遍历。

解题思路:
中序遍历顺序：左子树 -> 根节点 -> 右子树
可以使用递归或迭代（栈）两种方法实现。

时间复杂度: O(n)
空间复杂度: O(n)
*/

class TreeNode {
  int val;
  TreeNode? left;
  TreeNode? right;
  
  TreeNode([this.val = 0, this.left, this.right]);
}

class Solution {
  // 递归解法
  List<int> inorderTraversal(TreeNode? root) {
    List<int> result = [];
    inorderHelper(root, result);
    return result;
  }
  
  void inorderHelper(TreeNode? root, List<int> result) {
    if (root == null) return;
    
    inorderHelper(root.left, result);  // 左
    result.add(root.val);              // 根
    inorderHelper(root.right, result); // 右
  }
  
  // 迭代解法（使用栈）
  List<int> inorderTraversalIterative(TreeNode? root) {
    List<int> result = [];
    List<TreeNode> stack = [];
    TreeNode? current = root;
    
    while (current != null || stack.isNotEmpty) {
      while (current != null) {
        stack.add(current);
        current = current.left;
      }
      
      current = stack.removeLast();
      result.add(current.val);
      current = current.right;
    }
    
    return result;
  }
}

void main() {
  Solution solution = Solution();
  
  // 创建测试二叉树:     1
  //                    \
  //                     2
  //                    /
  //                   3
  TreeNode root = TreeNode(1);
  root.right = TreeNode(2);
  root.right!.left = TreeNode(3);
  
  print("递归解法: ${solution.inorderTraversal(root)}"); // [1, 3, 2]
  print("迭代解法: ${solution.inorderTraversalIterative(root)}"); // [1, 3, 2]
}