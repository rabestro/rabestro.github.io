---
title: "WhiteBox Testing: Rotate Image"
date: 2023-09-02 16:09:06 +0300
categories: [AI, Testing]
tags: [ai, testing, java, junit, assertj]
mermaid: false
---
{% raw %}

## The system prompt used

```plain
When you use assertions follow these rules:
- use `assertThat()` assertion
- add a customized message to assertions to better explain what we are expecting
- be concise by chaining multiple assertions
- put each chaining method on a separate line
```

## The AI Conversation Log

👤 Hi, who are you?

🤖 Hello! I am an AI trained to act as a lead Java developer with significant experience in unit testing. I can help you create unit tests for your Java code, suggest test cases, and generate test code using JUnit 5 and AssertJ assertions. If you have any questions or need assistance with unit testing, feel free to ask!

👤 What rules do you follow when writing an assertion?

🤖 When writing assertions, I follow these rules:

1. Use `assertThat()` assertion: I prefer using AssertJ's `assertThat()` method for assertions, as it provides a fluent and readable API for expressing expectations.

2. Add a customized message to assertions: To better explain what we are expecting, I include a custom message in the assertion. This message should be clear and concise, describing the expected outcome.

3. Be concise by chaining multiple assertions: When multiple assertions are related to the same object or result, I chain them together using AssertJ's fluent API. This makes the test code more readable and easier to understand.

4. Put each chaining method on a separate line: To improve readability, I place each method in the assertion chain on a new line. This makes it easier to see the sequence of expectations and quickly identify any issues.

Here's an example of an assertion following these rules:

```java
assertThat(actualResult)
    .as("The sum of %d and %d should be %d", a, b, expectedResult)
    .isEqualTo(expectedResult)
    .isNotNegative()
    .isLessThanOrEqualTo(maxValue);
```

In this example, the `actualResult` is being compared to the `expectedResult`, and additional assertions are chained to ensure the result is not negative and is less than or equal to a maximum value. The custom message provides context for the expected outcome.

👤 Nice, let's write a unit test for the method:

```java
package leetcode.p48;

class Solution {
    public void rotate(int[][] matrix) {
        for (int a = matrix.length / 2 - 1; a >= 0; a--) {
            int b = matrix.length - 1 - a;
            for (int i = matrix.length - a * 2 - 2; i >= 0; i--) {
                int tmp = matrix[a][a + i];
                matrix[a][a + i] = matrix[b - i][a];
                matrix[b - i][a] = matrix[b][b - i];
                matrix[b][b - i] = matrix[a + i][b];
                matrix[a + i][b] = tmp;
            }
        }
    }
}
```

🤖 To create unit tests for the `rotate` method, we'll first analyze the code and identify test cases using techniques such as Edge Coverage, Branch Coverage, Condition Coverage, Multiple Condition coverage, Path coverage, and State coverage.

The `rotate` method takes a 2D integer array (matrix) as input and rotates it 90 degrees clockwise in-place. Here are some test cases we can consider:

1. Test Case 1: Empty matrix
2. Test Case 2: 1x1 matrix
3. Test Case 3: 2x2 matrix
4. Test Case 4: 3x3 matrix
5. Test Case 5: 4x4 matrix

Please confirm if these test cases are good, and I'll generate the test code.

👤 Let's add another 5 by 5 matrix

🤖 Great, I've added a test case for a 5x5 matrix. Here are the updated test cases:

1. Test Case 1: Empty matrix
2. Test Case 2: 1x1 matrix
3. Test Case 3: 2x2 matrix
4. Test Case 4: 3x3 matrix
5. Test Case 5: 4x4 matrix
6. Test Case 6: 5x5 matrix

Please confirm if these test cases are good, and I'll generate the test code.

👤 please print the test cases as cards

🤖 Here are the test cases as cards:

**Test Case 1: Empty matrix**
- Input: `{}`
- Expected Output: `{}`

**Test Case 2: 1x1 matrix**
- Input: `{{1}}`
- Expected Output: `{{1}}`

**Test Case 3: 2x2 matrix**
- Input: `{{1, 2}, {3, 4}}`
- Expected Output: `{{3, 1}, {4, 2}}`

**Test Case 4: 3x3 matrix**
- Input: `{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}`
- Expected Output: `{{7, 4, 1}, {8, 5, 2}, {9, 6, 3}}`

**Test Case 5: 4x4 matrix**
- Input: `{{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}, {13, 14, 15, 16}}`
- Expected Output: `{{13, 9, 5, 1}, {14, 10, 6, 2}, {15, 11, 7, 3}, {16, 12, 8, 4}}`

**Test Case 6: 5x5 matrix**
- Input: `{{1, 2, 3, 4, 5}, {6, 7, 8, 9, 10}, {11, 12, 13, 14, 15}, {16, 17, 18, 19, 20}, {21, 22, 23, 24, 25}}`
- Expected Output: `{{21, 16, 11, 6, 1}, {22, 17, 12, 7, 2}, {23, 18, 13, 8, 3}, {24, 19, 14, 9, 4}, {25, 20, 15, 10, 5}}`

Please let me know if you'd like any changes or if I should proceed with generating the test code.

👤 Print the last test case in a human-readable form

🤖 **Test Case 6: 5x5 matrix**

- Input:
```
1  2  3  4  5
6  7  8  9 10
11 12 13 14 15
16 17 18 19 20
21 22 23 24 25
```

- Expected Output:
```
21 16 11  6  1
22 17 12  7  2
23 18 13  8  3
24 19 14  9  4
25 20 15 10  5
```

This test case rotates a 5x5 matrix 90 degrees clockwise. The input matrix has numbers from 1 to 25 arranged in ascending order, and the expected output matrix shows the result after rotation.

👤 great, we can start writing tests

🤖 I'll generate the test code using JUnit 5 and AssertJ assertions. Here's the test class for the `rotate` method in the `Solution` class:

```java
package leetcode.p48;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import java.util.stream.Stream;
import static org.assertj.core.api.Assertions.assertThat;

class SolutionWhiteBoxC4Test {

    static Stream<Object[]> matrixRotationTestCases() {
        return Stream.of(
                new Object[]{"Empty matrix", new int[][]{}, new int[][]{}},
                new Object[]{"1x1 matrix", new int[][]{{1}}, new int[][]{{1}}},
                new Object[]{"2x2 matrix", new int[][]{{1, 2}, {3, 4}}, new int[][]{{3, 1}, {4, 2}}},
                new Object[]{"3x3 matrix", new int[][]{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}, new int[][]{{7, 4, 1}, {8, 5, 2}, {9, 6, 3}}},
                new Object[]{"4x4 matrix", new int[][]{{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}, {13, 14, 15, 16}}, new int[][]{{13, 9, 5, 1}, {14, 10, 6, 2}, {15, 11, 7, 3}, {16, 12, 8, 4}}},
                new Object[]{"5x5 matrix", new int[][]{{1, 2, 3, 4, 5}, {6, 7, 8, 9, 10}, {11, 12, 13, 14, 15}, {16, 17, 18, 19, 20}, {21, 22, 23, 24, 25}}, new int[][]{{21, 16, 11, 6, 1}, {22, 17, 12, 7, 2}, {23, 18, 13, 8, 3}, {24, 19, 14, 9, 4}, {25, 20, 15, 10, 5}}}
        );
    }

    @DisplayName("Matrix rotation")
    @ParameterizedTest(name = "{index}: {0}")
    @MethodSource("matrixRotationTestCases")
    void testRotate(String description, int[][] inputMatrix, int[][] expectedMatrix) {
        var solution = new Solution();
        solution.rotate(inputMatrix);
        assertThat(inputMatrix)
                .as("The rotated matrix should match the expected matrix")
                .isEqualTo(expectedMatrix);
    }
}
```

This test class contains a parameterized test method `testRotate` that uses the `@MethodSource` annotation to provide test cases. The `matrixRotationTestCases` method returns a stream of test case data, including a description, input matrix, and expected matrix. The test method then calls the `rotate` method on the `Solution` class and asserts that the rotated matrix matches the expected matrix.

👤 I noticed that you sometimes use new `Arguments.of()` and now you use `new Object[]`. What's the difference?

🤖 You're right, I used `new Object[]` in the previous example, but you can also use `Arguments.of()` when providing test cases for parameterized tests in JUnit 5. Both approaches serve the same purpose, which is to provide a set of arguments for each test case in a parameterized test. The main difference is in the way they are constructed and used.

1. `new Object[]`: This is a simple way to create an array of objects that represent the arguments for a test case. It's a plain Java array, and you can include any number of elements in it. When using this approach, you need to make sure that the elements in the array match the expected parameters of the test method.

2. `Arguments.of()`: This is a static factory method provided by the `org.junit.jupiter.params.provider.Arguments` class in JUnit 5. It creates an instance of the `Arguments` interface, which is specifically designed for use with parameterized tests. The `of()` method accepts a variable number of arguments and returns an `Arguments` instance containing those arguments. This approach provides better type safety and is more specific to JUnit 5 parameterized tests.

Both approaches are valid, and you can choose the one that you find more convenient or readable. In the previous example, I used `new Object[]` for simplicity, but you can replace it with `Arguments.of()` if you prefer. Here's the updated `matrixRotationTestCases` method using `Arguments.of()`:

```java
static Stream<Arguments> matrixRotationTestCases() {
    return Stream.of(
            Arguments.of("Empty matrix", new int[][]{}, new int[][]{}),
            Arguments.of("1x1 matrix", new int[][]{{1}}, new int[][]{{1}}),
            Arguments.of("2x2 matrix", new int[][]{{1, 2}, {3, 4}}, new int[][]{{3, 1}, {4, 2}}),
            Arguments.of("3x3 matrix", new int[][]{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}, new int[][]{{7, 4, 1}, {8, 5, 2}, {9, 6, 3}}),
            Arguments.of("4x4 matrix", new int[][]{{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}, {13, 14, 15, 16}}, new int[][]{{13, 9, 5, 1}, {14, 10, 6, 2}, {15, 11, 7, 3}, {16, 12, 8, 4}}),
            Arguments.of("5x5 matrix", new int[][]{{1, 2, 3, 4, 5}, {6, 7, 8, 9, 10}, {11, 12, 13, 14, 15}, {16, 17, 18, 19, 20}, {21, 22, 23, 24, 25}}, new int[][]{{21, 16, 11, 6, 1}, {22, 17, 12, 7, 2}, {23, 18, 13, 8, 3}, {24, 19, 14, 9, 4}, {25, 20, 15, 10, 5}})
    );
}
```

The test method signature remains the same, and the test cases will work as expected with either approach.

👤 How about static `arguments` method of Arguments class?

🤖 Yes, the `Arguments` class also provides a static `arguments` method, which is an alternative to the `of()` method for creating instances of the `Arguments` interface. The `arguments` method works similarly to the `of()` method, accepting a variable number of arguments and returning an `Arguments` instance containing those arguments.

Here's the updated `matrixRotationTestCases` method using the `Arguments.arguments()` method:

```java
import org.junit.jupiter.params.provider.Arguments;

static Stream<Arguments> matrixRotationTestCases() {
    return Stream.of(
            Arguments.arguments("Empty matrix", new int[][]{}, new int[][]{}),
            Arguments.arguments("1x1 matrix", new int[][]{{1}}, new int[][]{{1}}),
            Arguments.arguments("2x2 matrix", new int[][]{{1, 2}, {3, 4}}, new int[][]{{3, 1}, {4, 2}}),
            Arguments.arguments("3x3 matrix", new int[][]{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}, new int[][]{{7, 4, 1}, {8, 5, 2}, {9, 6, 3}}),
            Arguments.arguments("4x4 matrix", new int[][]{{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}, {13, 14, 15, 16}}, new int[][]{{13, 9, 5, 1}, {14, 10, 6, 2}, {15, 11, 7, 3}, {16, 12, 8, 4}}),
            Arguments.arguments("5x5 matrix", new int[][]{{1, 2, 3, 4, 5}, {6, 7, 8, 9, 10}, {11, 12, 13, 14, 15}, {16, 17, 18, 19, 20}, {21, 22, 23, 24, 25}}, new int[][]{{21, 16, 11, 6, 1}, {22, 17, 12, 7, 2}, {23, 18, 13, 8, 3}, {24, 19, 14, 9, 4}, {25, 20, 15, 10, 5}})
    );
}
```

Both `Arguments.of()` and `Arguments.arguments()` methods can be used interchangeably, and the choice between them is a matter of personal preference or coding style. The test method signature remains the same, and the test cases will work as expected with either approach.

👤 Which method would be preferable if we use the latest version of JUnit?

🤖 In the latest version of JUnit 5, both `Arguments.of()` and `Arguments.arguments()` methods are available and can be used interchangeably. However, the `Arguments.of()` method is more commonly used and recommended in the JUnit 5 documentation and examples.

Using `Arguments.of()` is preferable because it is more concise and provides better readability. Additionally, it is more consistent with the naming conventions used in other JUnit 5 parameterized test sources, such as `EnumSource`, `ValueSource`, and `CsvSource`.

So, for the latest version of JUnit 5, I recommend using `Arguments.of()` when providing test cases for parameterized tests.

👤 Thanks for the clarification and well written test.

🤖 You're welcome! I'm glad you found the test and clarification helpful. If you have any more questions or need assistance with unit testing or any other Java-related topics, please feel free to ask. I'm here to help!

{% endraw %}
