---
title: "BlackBox Testing: Set Matrix Zeroes"
date: 2023-08-29 11:58:58 +0300
categories: [AI, Testing]
tags: [ai, java, unit-test, black-box, matrix]
mermaid: true
---

## Introduction

In this article, we'll explore a practical example of using artificial intelligence (AI) to generate unit tests based on black box technology. Our test object is a coding problem from the LeetCode website: [Set Matrix Zeroes](https://leetcode.com/problems/set-matrix-zeroes/). Throughout our interaction with AI, we'll discover its ability to suggest useful test cases and present them in an easily readable format.

## AI-Generated Test Cases

Our dialogue with the AI revealed its capacity to offer valuable test cases. What's more, when asked, it provided the cases in a user-friendly format. As our conversation continued, we requested the AI to challenge us with more complex test cases.

## Overcoming Errors with AI

Upon adding the complex test cases, the AI did make a mistake in the last option. However, after drawing attention to the error, the AI promptly corrected it and produced the revised test code. This demonstrates that even with occasional errors, AI can adapt quickly to provide accurate and efficient results.

## Conclusion

The use of artificial intelligence for creating unit tests offers a promising approach to test generation and validation. Through black box technology and a friendly, interactive dialogue, AI can suggest helpful test cases, adapt to specific formatting requests, and improve its performance based on user feedback. The future of AI-guided unit testing holds great potential for increasing testing efficiency and accuracy.


## The AI Conversation Log

👤 Hi, who are you?

🤖 Hello! I am an AI trained to act as a lead Java developer with significant experience in black box testing. I can help you create unit tests for your Java code, analyze problem statements, and suggest test cases using various testing techniques. If you have any questions or need assistance, feel free to ask!

👤 Given an m x n integer matrix matrix, if an element is 0, set its entire row and column to 0's.

🤖 To create test cases for this problem, I need to know the method signature of the function that will be implemented. Please provide the method signature, including the method name, input parameters, and return type.

👤 

```java
package leetcode.p73;

class Solution {
    public void setZeroes(int[][] matrix) {
        
    }
}
```

🤖 Thank you for providing the method signature. Now, let's create test cases for the `setZeroes` method using various testing techniques.

1. Test Case: Empty matrix
   Input: `[][]`
   Expected Outcome: `[][]`

2. Test Case: Single element matrix with non-zero value
   Input: `[[1]]`
   Expected Outcome: `[[1]]`

3. Test Case: Single element matrix with zero value
   Input: `[[0]]`
   Expected Outcome: `[[0]]`

4. Test Case: Matrix with no zeros
   Input: `[[1, 2], [3, 4]]`
   Expected Outcome: `[[1, 2], [3, 4]]`

5. Test Case: Matrix with a single zero
   Input: `[[1, 2, 3], [4, 0, 6], [7, 8, 9]]`
   Expected Outcome: `[[1, 0, 3], [0, 0, 0], [7, 0, 9]]`

6. Test Case: Matrix with multiple zeros
   Input: `[[1, 2, 3], [4, 0, 6], [0, 8, 9]]`
   Expected Outcome: `[[0, 0, 3], [0, 0, 0], [0, 0, 0]]`

7. Test Case: Matrix with all zeros
   Input: `[[0, 0], [0, 0]]`
   Expected Outcome: `[[0, 0], [0, 0]]`

Please confirm if these test cases are good, and then I will generate the test code for you.

👤 please print as cards

🤖 Here are the test cases as cards:

**Test Case 1: Empty matrix**
- Input: `[][]`
- Expected Outcome: `[][]`

**Test Case 2: Single element matrix with non-zero value**
- Input: `[[1]]`
- Expected Outcome: `[[1]]`

**Test Case 3: Single element matrix with zero value**
- Input: `[[0]]`
- Expected Outcome: `[[0]]`

**Test Case 4: Matrix with no zeros**
- Input: `[[1, 2], [3, 4]]`
- Expected Outcome: `[[1, 2], [3, 4]]`

**Test Case 5: Matrix with a single zero**
- Input: `[[1, 2, 3], [4, 0, 6], [7, 8, 9]]`
- Expected Outcome: `[[1, 0, 3], [0, 0, 0], [7, 0, 9]]`

**Test Case 6: Matrix with multiple zeros**
- Input: `[[1, 2, 3], [4, 0, 6], [0, 8, 9]]`
- Expected Outcome: `[[0, 0, 3], [0, 0, 0], [0, 0, 0]]`

**Test Case 7: Matrix with all zeros**
- Input: `[[0, 0], [0, 0]]`
- Expected Outcome: `[[0, 0], [0, 0]]`

> We can ask AI to format the answer in a way that suits our reading preferences.
{: .prompt-tip }

👤 Add more cases with a non-square matrix. Could you print the matrices in a more human-readable form? 

🤖 Sure, I will add more test cases with non-square matrices and present the matrices in a more human-readable form.

**Test Case 1: Empty matrix**
- Input:
  ```
  []
  ```
- Expected Outcome:
  ```
  []
  ```

**Test Case 2: Single element matrix with non-zero value**
- Input:
  ```
  [1]
  ```
- Expected Outcome:
  ```
  [1]
  ```

**Test Case 3: Single element matrix with zero value**
- Input:
  ```
  [0]
  ```
- Expected Outcome:
  ```
  [0]
  ```

**Test Case 4: Matrix with no zeros**
- Input:
  ```
  [1, 2]
  [3, 4]
  ```
- Expected Outcome:
  ```
  [1, 2]
  [3, 4]
  ```

**Test Case 5: Matrix with a single zero**
- Input:
  ```
  [1, 2, 3]
  [4, 0, 6]
  [7, 8, 9]
  ```
- Expected Outcome:
  ```
  [1, 0, 3]
  [0, 0, 0]
  [7, 0, 9]
  ```

**Test Case 6: Matrix with multiple zeros**
- Input:
  ```
  [1, 2, 3]
  [4, 0, 6]
  [0, 8, 9]
  ```
- Expected Outcome:
  ```
  [0, 0, 3]
  [0, 0, 0]
  [0, 0, 0]
  ```

**Test Case 7: Matrix with all zeros**
- Input:
  ```
  [0, 0]
  [0, 0]
  ```
- Expected Outcome:
  ```
  [0, 0]
  [0, 0]
  ```

**Test Case 8: Non-square matrix with no zeros**
- Input:
  ```
  [1, 2, 3]
  [4, 5, 6]
  ```
- Expected Outcome:
  ```
  [1, 2, 3]
  [4, 5, 6]
  ```

**Test Case 9: Non-square matrix with a single zero**
- Input:
  ```
  [1, 2, 3, 4]
  [5, 0, 7, 8]
  ```
- Expected Outcome:
  ```
  [1, 0, 3, 4]
  [0, 0, 0, 0]
  ```

**Test Case 10: Non-square matrix with multiple zeros**
- Input:
  ```
  [1, 2, 3]
  [4, 0, 6]
  [7, 8, 9]
  [0, 10, 11]
  ```
- Expected Outcome:
  ```
  [0, 2, 3]
  [0, 0, 0]
  [0, 8, 9]
  [0, 0, 0]
  ```

Please confirm if these test cases are good, and then I will generate the test code for you.

> It's essential to review the results of artificial intelligence, as it can make mistakes in calculating expected outcomes. 
> In this case, the AI made a mistake in the last test case.
{: .prompt-danger } 

👤 check the last case please

🤖 Apologies for the mistake in the last test case. Here's the corrected version:

**Test Case 10: Non-square matrix with multiple zeros**
- Input:
  ```
  [1,  2,  3]
  [4,  0,  6]
  [7,  8,  9]
  [0, 10, 11]
  ```
- Expected Outcome:
  ```
  [0,  0,  3]
  [0,  0,  0]
  [0,  0,  9]
  [0,  0,  0]
  ```

Please confirm if these test cases are good, and then I will generate the test code for you.

👤 they are perfect

🤖 Great! Now I will generate the test code using JUnit 5 and AssertJ assertions.

{% raw %}

```java
package leetcode.p73;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

class SolutionBlackBoxC4Test {

    @DisplayName("Set Zeroes")
    @ParameterizedTest(name = "Test case {index}: {0}")
    @MethodSource("testCases")
    void setZeroes(String description, int[][] input, int[][] expected) {
        var solution = new Solution();
        solution.setZeroes(input);
        assertThat(input)
                .as("Matrix after setting zeroes should match the expected matrix")
                .isEqualTo(expected);
    }

    private static Stream<Arguments> testCases() {
        return Stream.of(
                Arguments.of("Empty matrix",
                             new int[][]{},
                             new int[][]{}),
                Arguments.of("Single element matrix with non-zero value",
                             new int[][]{{1}},
                             new int[][]{{1}}),
                Arguments.of("Single element matrix with zero value",
                             new int[][]{{0}},
                             new int[][]{{0}}),
                Arguments.of("Matrix with no zeros",
                             new int[][]{{1, 2}, {3, 4}},
                             new int[][]{{1, 2}, {3, 4}}),
                Arguments.of("Matrix with a single zero",
                             new int[][]{{1, 2, 3}, {4, 0, 6}, {7, 8, 9}},
                             new int[][]{{1, 0, 3}, {0, 0, 0}, {7, 0, 9}}),
                Arguments.of("Matrix with multiple zeros",
                             new int[][]{{1, 2, 3}, {4, 0, 6}, {0, 8, 9}},
                             new int[][]{{0, 0, 3}, {0, 0, 0}, {0, 0, 0}}),
                Arguments.of("Matrix with all zeros",
                             new int[][]{{0, 0}, {0, 0}},
                             new int[][]{{0, 0}, {0, 0}}),
                Arguments.of("Non-square matrix with no zeros",
                             new int[][]{{1, 2, 3}, {4, 5, 6}},
                             new int[][]{{1, 2, 3}, {4, 5, 6}}),
                Arguments.of("Non-square matrix with a single zero",
                             new int[][]{{1, 2, 3, 4}, {5, 0, 7, 8}},
                             new int[][]{{1, 0, 3, 4}, {0, 0, 0, 0}}),
                Arguments.of("Non-square matrix with multiple zeros",
                             new int[][]{{1, 2, 3}, {4, 0, 6}, {7, 8, 9}, {0, 10, 11}},
                             new int[][]{{0, 0, 3}, {0, 0, 0}, {0, 0, 9}, {0, 0, 0}})
        );
    }
}
```

{% endraw %}

This test code uses JUnit 5 and AssertJ assertions to test the `setZeroes` method with the provided test cases. You can copy and paste this code into your project to run the tests.

👤 The tests are good, thank you!

🤖 You're welcome! I'm glad the tests are good. If you have any more questions or need further assistance, feel free to ask. Good luck with your project!
