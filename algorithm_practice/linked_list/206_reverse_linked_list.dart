/*
题目: 反转链表
链接: https://leetcode.com/problems/reverse-linked-list/
难度: Easy
标签: Linked List

题目描述:
给你单链表的头节点 head ，请你反转链表，并返回反转后的链表。

解题思路:
使用三个指针：prev（前一个节点）、current（当前节点）、next（下一个节点）
迭代过程中改变链表的指向方向。

时间复杂度: O(n)
空间复杂度: O(1)
*/

class ListNode {
  int val;
  ListNode? next;
  
  ListNode([this.val = 0, this.next]);
}

class Solution {
  ListNode? reverseList(ListNode? head) {
    ListNode? prev = null;
    ListNode? current = head;
    
    while (current != null) {
      ListNode? next = current.next;
      current.next = prev;
      prev = current;
      current = next;
    }
    
    return prev;
  }
  
  // 递归解法
  ListNode? reverseListRecursive(ListNode? head) {
    if (head == null || head.next == null) {
      return head;
    }
    
    ListNode? newHead = reverseListRecursive(head.next);
    head.next!.next = head;
    head.next = null;
    
    return newHead;
  }
}

void main() {
  Solution solution = Solution();
  
  // 创建测试链表: 1 -> 2 -> 3 -> 4 -> 5
  ListNode head = ListNode(1);
  head.next = ListNode(2);
  head.next!.next = ListNode(3);
  head.next!.next!.next = ListNode(4);
  head.next!.next!.next!.next = ListNode(5);
  
  print("原链表: 1 -> 2 -> 3 -> 4 -> 5");
  
  ListNode? reversed = solution.reverseList(head);
  print("反转后: 5 -> 4 -> 3 -> 2 -> 1");
}