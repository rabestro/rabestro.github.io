---
title: "BlackBox Testing: Rotate Image"
date: 2023-08-30 15:52:57 +0300
categories: [AI, Testing]
tags: [ai, java, unit-test, blackbox, array, matrix]
mermaid: true
---


## The AI Conversation Log

{% raw %}

👤 Hello!

🤖 Hello! How can I help you today? Are you looking for assistance with Java development or black box testing?

👤 You are given an n x n 2D matrix representing an image, rotate the image by 90 degrees (clockwise).

🤖 To help you with this problem, I need to know the method signature for the function that rotates the image. Please provide the method signature and any additional information about the input and output format.

👤 

```java
class Solution {
    public void rotate(int[][] matrix) {
        
    }
}
```

🤖 Thank you for providing the method signature. Now, let's analyze the problem statement and create test cases for the `rotate` method.

1. Test Case: Small matrix (2x2)
Input:
```
1 2
3 4
```
Expected Output:
```
3 1
4 2
```

2. Test Case: Medium matrix (3x3)
Input:
```
1 2 3
4 5 6
7 8 9
```
Expected Output:
```
7 4 1
8 5 2
9 6 3
```

3. Test Case: Large matrix (4x4)
Input:
```
 1  2  3  4
 5  6  7  8
 9 10 11 12
13 14 15 16
```
Expected Output:
```
13  9  5  1
14 10  6  2
15 11  7  3
16 12  8  4
```

4. Test Case: Single element matrix (1x1)
Input:
```
1
```
Expected Output:
```
1
```

5. Test Case: Empty matrix (0x0)
Input:
```
(empty)
```
Expected Output:
```
(empty)
```

Please confirm if these test cases are good, and then I will generate the test code for you.

👤 it's fine

🤖 Great! Now I will generate the test code for the `rotate` method using JUnit 5 and AssertJ assertions.

```java
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

class SolutionBlackBoxC4Test {

    @DisplayName("Rotate matrix")
    @ParameterizedTest(name = "Test case {index}: {0}")
    @MethodSource("rotateMatrixTestCases")
    void rotateMatrix(String description, int[][] input, int[][] expectedOutput) {
        var solution = new Solution();
        solution.rotate(input);
        assertThat(input).as("The rotated matrix should match the expected output").isEqualTo(expectedOutput);
    }

    private static Stream<Arguments> rotateMatrixTestCases() {
        return Stream.of(
                Arguments.of("Small matrix (2x2)", new int[][]{{1, 2}, {3, 4}}, new int[][]{{3, 1}, {4, 2}}),
                Arguments.of("Medium matrix (3x3)", new int[][]{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}, new int[][]{{7, 4, 1}, {8, 5, 2}, {9, 6, 3}}),
                Arguments.of("Large matrix (4x4)", new int[][]{{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}, {13, 14, 15, 16}}, new int[][]{{13, 9, 5, 1}, {14, 10, 6, 2}, {15, 11, 7, 3}, {16, 12, 8, 4}}),
                Arguments.of("Single element (1x1)", new int[][]{{1}}, new int[][]{{1}}),
                Arguments.of("Empty matrix (0x0)", new int[][]{}, new int[][]{})
        );
    }
}
```

This test code uses JUnit 5 and AssertJ assertions to test the `rotate` method with the provided test cases. The `rotateMatrix` test method is parameterized and uses the `@MethodSource` annotation to supply the test cases. The test cases are defined in the `rotateMatrixTestCases` method, which returns a stream of `Arguments` objects containing the test case description, input matrix, and expected output matrix.

👤 thanks

🤖 You're welcome! If you have any more questions or need further assistance, feel free to ask. Good luck with your project!

{% endraw %}
