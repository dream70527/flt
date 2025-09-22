/*
题目: 两数之和
链接: https://leetcode.com/problems/two-sum/
难度: Easy
标签: Array, Hash Table

题目描述:
给定一个整数数组 nums 和一个整数目标值 target，请你在该数组中找出 和为目标值 target 的那 两个 整数，并返回它们的数组下标。

解题思路:
使用哈希表存储已遍历过的数字及其索引，对于每个数字，检查target减去当前数字的差值是否在哈希表中。

时间复杂度: O(n)
空间复杂度: O(n)
*/

class Solution {
  List<int> twoSum(List<int> nums, int target) {
    Map<int, int> map = {};
    
    for (int i = 0; i < nums.length; i++) {
      int complement = target - nums[i];
      
      if (map.containsKey(complement)) {
        return [map[complement]!, i];
      }
      
      map[nums[i]] = i;
    }
    
    return [];
  }
}

void main() {
  Solution solution = Solution();
  
  // 测试用例1
  print("测试用例1: ${solution.twoSum([2, 7, 11, 15], 9)}"); // [0, 1]
  
  // 测试用例2
  print("测试用例2: ${solution.twoSum([3, 2, 4], 6)}"); // [1, 2]
  
  // 测试用例3
  print("测试��例3: ${solution.twoSum([3, 3], 6)}"); // [0, 1]
}