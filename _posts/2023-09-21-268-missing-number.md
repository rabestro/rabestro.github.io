---
title: "268. Missing Number"
date: 2023-09-21 19:33:28 +0300
categories: [AI, Development]
tags: [ai, gpt-4, leetcode, black-box-testing, solution]
mermaid: false
---

## The AI Conversation Log

{% raw %}
👤 

```java
class Solution {
    public int missingNumber(int[] nums) {
        
    }
}
```

🤖 To create unit tests for the `missingNumber` method, I need to know the problem statement and any additional information related to the method. Please provide the problem statement and any other relevant information.

👤 
```plain
Given an array nums containing n distinct numbers in the range [0, n], return the only number in the range that is missing from the array.

Example 1:

Input: nums = [3,0,1]
Output: 2
Explanation: n = 3 since there are 3 numbers, so all numbers are in the range [0,3]. 2 is the missing number in the range since it does not appear in nums.

Example 2:

Input: nums = [0,1]
Output: 2
Explanation: n = 2 since there are 2 numbers, so all numbers are in the range [0,2]. 2 is the missing number in the range since it does not appear in nums.

Example 3:

Input: nums = [9,6,4,2,3,5,7,0,1]
Output: 8
Explanation: n = 9 since there are 9 numbers, so all numbers are in the range [0,9]. 8 is the missing number in the range since it does not appear in nums.

Constraints:
    n == nums.length
    1 <= n <= 104
    0 <= nums[i] <= n
    All the numbers of nums are unique.
```

🤖 Thank you for providing the problem statement. Based on the given information, I will suggest the following test cases for the `missingNumber` method:

1. Test Case 1: Normal case with a small array
   Input: nums = [3, 0, 1]
   Expected Output: 2

2. Test Case 2: Normal case with a small array
   Input: nums = [0, 1]
   Expected Output: 2

3. Test Case 3: Normal case with a larger array
   Input: nums = [9, 6, 4, 2, 3, 5, 7, 0, 1]
   Expected Output: 8

4. Test Case 4: Array with only one element
   Input: nums = [0]
   Expected Output: 1

5. Test Case 5: Array with only one element
   Input: nums = [1]
   Expected Output: 0

6. Test Case 6: Array with all elements in ascending order
   Input: nums = [0, 1, 2, 3, 4, 5, 6, 8, 9]
   Expected Output: 7

7. Test Case 7: Array with all elements in descending order
   Input: nums = [9, 8, 7, 6, 5, 4, 3, 1, 0]
   Expected Output: 2

Please confirm if these test cases are good to proceed with generating the test code.

👤 fine

🤖 Great! I will now generate the test code for the `missingNumber` method using the suggested test cases and following the rules and best practices.

```java
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.MethodSource;
import static org.assertj.core.api.Assertions.assertThat;

class SolutionBlackBoxC4Test {

    private final Solution solution = new Solution();

    @DisplayName("Test missingNumber method:")
    @ParameterizedTest(name = "[{index}] {0}")
    @CsvSource(delimiter = '|', textBlock = """
            Test case with a small array                 | 3,0,1               | 2
            Test case with a small array                 | 0,1                 | 2
            Test case with a larger array                | 9,6,4,2,3,5,7,0,1   | 8
            Array with only one element                  | 0                   | 1
            Array with only one element                  | 1                   | 0
            Array with all elements in ascending order   | 0,1,2,3,4,5,6,8,9   | 7
            Array with all elements in descending order  | 9,8,7,6,5,4,3,1,0   | 2
    """)
    void testMissingNumber(String description, String input, int expectedOutput) {
        int[] nums = toIntArray(input);
        int result = solution.missingNumber(nums);
        assertThat(result).as("The missing number in the range should be %d", expectedOutput).isEqualTo(expectedOutput);
    }

    private int[] toIntArray(String input) {
        String[] parts = input.split(",");
        int[] nums = new int[parts.length];
        for (int i = 0; i < parts.length; i++) {
            nums[i] = Integer.parseInt(parts[i]);
        }
        return nums;
    }
}
```

This test code uses JUnit 5 and AssertJ assertions. It includes a parameterized test with the suggested test cases and a helper method `toIntArray` to convert the input string to an integer array.

👤 Implement solution

🤖 Here's an implementation of the `missingNumber` method for the `Solution` class:

```java
class Solution {
    public int missingNumber(int[] nums) {
        int n = nums.length;
        int expectedSum = n * (n + 1) / 2;
        int actualSum = 0;
        
        for (int num : nums) {
            actualSum += num;
        }
        
        return expectedSum - actualSum;
    }
}
```

This implementation calculates the expected sum of the numbers in the range [0, n] using the formula `n * (n + 1) / 2`. Then, it calculates the actual sum of the numbers in the input array `nums`. Finally, it returns the difference between the expected sum and the actual sum, which is the missing number in the range.
{% endraw %}
