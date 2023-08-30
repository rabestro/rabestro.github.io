---
title: "Improved Prompt: @MethodSource vs @CsvSource"
date: 2023-08-30 20:44:41 +0300
categories: [AI]
tags: [ai]
mermaid: true
---

In a [recent system test](https://rabestro.github.io/posts/whitebox-testing-spiral-matrix/), I encountered a challenge with the script's ability to accurately determine the proper approach for building parameterized tests.

## Identifying the Right Annotation

The primary issue stemmed from the two annotations present in the test framework - `@MethodSource` and `@CsvSource`. Selecting the correct annotation is vital, and I decided to seek help from artificial intelligence (AI) for clear criteria and guidance.

## AI Assistance for Better Test Performance

The AI system not only formulated the criteria for choosing the appropriate annotation but also generated a helpful hint. I incorporated this hint into the initial instructions, which significantly improved the system's performance.

Thanks to the AI's assistance, the method for creating parameterized tests was flawlessly selected. Moreover, the AI explained the rationale behind its decision and shared the criteria applied for making its choice.

## Leveraging AI for Continuous Improvement

This example demonstrates the intriguing capabilities of working with AI, showcasing its potential to refine and improve upon itself. Through this collaboration, the efficiency and accuracy of our processes can be further enhanced.

## The addition to the system prompt.

### Use `@CsvSource` when:
  - The input data and expected results are simple data types, such as integers, strings, or booleans.
  - The test cases can be easily represented as a table with rows and columns.
  - There is no need for complex data structures or custom argument converters.

### Use `@MethodSource` when:
  - The input data or expected results involve complex data types or structures, such as arrays, lists, or custom objects.
  - The test cases require additional logic or computation to generate the input data or expected results.
  - Custom argument converters are needed to convert the input data or expected results from strings to the desired data types.

## The AI Conversation Log

{% raw %}

👤 Hi, who are you?

🤖 Hello! I am an AI trained to act as a lead Java developer with significant experience in unit testing. I can help you create unit tests for your Java code snippets, suggest test cases, and generate test code using JUnit 5 and AssertJ assertions. If you have any code that needs testing, feel free to share it with me, and I'll guide you through the process.

👤 package leetcode.p54;

import java.util.List;
import java.util.stream.IntStream;
import java.util.stream.Stream;

import static java.util.Arrays.stream;
import static java.util.stream.IntStream.range;

class Solution {
    private int rows;
    private int cols;
    private int[][] matrix;

    public List<Integer> spiralOrder(int[][] matrix) {
        rows = matrix.length;
        if (rows == 0) {
            return List.of();
        }
        cols = matrix[0].length;
        if (cols == 0) {
            return List.of();
        }
        this.matrix = matrix;

        return spiralOrder(0).boxed().toList();
    }

    IntStream spiralOrder(int level) {
        if (level > rows - 1 - level || level > cols - 1 - level) {
            return IntStream.empty();
        }
        if (level == rows - 1 - level) {
            return stream(matrix[level], level, cols - level);
        }
        if (level == cols - 1 - level) {
            return range(level, rows - level).map(i -> matrix[i][level]);
        }
        var top = stream(matrix[level], level, cols - level);
        var right = range(level + 1, rows - level)
                .map(i -> matrix[i][cols - 1 - level]);
        var bottom = range(level + 1, cols - level)
                .map(i -> cols - 1 - i)
                .map(i -> matrix[rows - 1 - level][i]);
        var left = range(level + 1, rows - level - 1)
                .map(i -> rows - 1 - i)
                .map(i -> matrix[i][level]);

        return Stream.of(top, right, bottom, left, spiralOrder(level + 1))
                .flatMapToInt(i -> i);
    }
}


🤖 This is a Java class named `Solution` that contains a method `spiralOrder(int[][] matrix)` which takes a 2D integer array `matrix` as input and returns a list of integers representing the elements of the matrix in a spiral order. The class also contains a private method `spiralOrder(int level)` which is a helper method for the main `spiralOrder` method.

Before we proceed with creating test cases, let me know if you need any further clarification on the code or its functionality.

👤 let's go

🤖 Great! Let's start by identifying test cases for the `spiralOrder(int[][] matrix)` method. We'll cover various scenarios to ensure the method works correctly.

1. Empty matrix
2. Matrix with a single element
3. Matrix with a single row
4. Matrix with a single column
5. Square matrix with odd dimensions
6. Square matrix with even dimensions
7. Rectangular matrix with more rows than columns
8. Rectangular matrix with more columns than rows

Please review these test cases and let me know if you'd like to add or modify any of them. Once you confirm, I'll generate the test code for these test cases.

👤 fine

🤖 Great! Now I'll generate the test code for the `spiralOrder(int[][] matrix)` method using JUnit 5 and AssertJ assertions.

```java
package leetcode.p54;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.util.List;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

class SolutionWhiteBoxC4Test {

    private final Solution solution = new Solution();

    @DisplayName("Spiral order of matrix")
    @ParameterizedTest(name = "Test case {index}: {0}")
    @MethodSource("spiralOrderTestCases")
    void spiralOrder(String description, int[][] matrix, List<Integer> expected) {
        var actual = solution.spiralOrder(matrix);
        assertThat(actual).as("Spiral order of matrix for %s should be %s", description, expected).isEqualTo(expected);
    }

    private static Stream<Arguments> spiralOrderTestCases() {
        return Stream.of(
                Arguments.of("Empty matrix", new int[][]{}, List.of()),
                Arguments.of("Matrix with a single element", new int[][]{{1}}, List.of(1)),
                Arguments.of("Matrix with a single row", new int[][]{{1, 2, 3}}, List.of(1, 2, 3)),
                Arguments.of("Matrix with a single column", new int[][]{{1}, {2}, {3}}, List.of(1, 2, 3)),
                Arguments.of("Square matrix with odd dimensions", new int[][]{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}, List.of(1, 2, 3, 6, 9, 8, 7, 4, 5)),
                Arguments.of("Square matrix with even dimensions", new int[][]{{1, 2}, {3, 4}}, List.of(1, 2, 4, 3)),
                Arguments.of("Rectangular matrix with more rows than columns", new int[][]{{1, 2}, {3, 4}, {5, 6}}, List.of(1, 2, 4, 6, 5, 3)),
                Arguments.of("Rectangular matrix with more columns than rows", new int[][]{{1, 2, 3}, {4, 5, 6}}, List.of(1, 2, 3, 6, 5, 4))
        );
    }
}
```

This test class contains a parameterized test method `spiralOrder` that tests the `spiralOrder(int[][] matrix)` method for the given test cases. The test cases are provided by the `spiralOrderTestCases` method using the `@MethodSource` annotation.

You can now run these tests to verify the correctness of the `spiralOrder` method. If you have any questions or need further assistance, please let me know.

👤 Can you explain why you prefer the `@MethodSource` approach over the `@CsvSource`?

🤖 Certainly! In this particular case, I chose to use `@MethodSource` over `@CsvSource` for the following reasons:

1. Complex data types: The input data (2D integer array) and expected results (List of integers) are complex data types that cannot be easily represented as simple strings in a CSV format. `@MethodSource` allows us to directly provide these complex data types as arguments, making it easier to define and understand the test cases.

2. Readability: With `@MethodSource`, we can create a more readable and structured representation of the test cases. Each test case is represented as an `Arguments` object, which clearly separates the description, input data, and expected results. This makes it easier to understand the purpose and expected outcome of each test case.

3. Flexibility: `@MethodSource` provides more flexibility in generating test cases, as it allows us to use Java code to create and manipulate the input data and expected results. This can be particularly useful when dealing with complex data structures or when additional logic is required to generate the test cases.

In summary, `@MethodSource` is a more suitable choice for this scenario due to the complexity of the input data and expected results, as well as the improved readability and flexibility it offers compared to `@CsvSource`.

👤 Please explain when you choose one approach and when the other.

🤖 Certainly! When choosing between `@CsvSource` and `@MethodSource` for parameterized tests, consider the following factors:

Use `@CsvSource` when:
1. The input data and expected results are simple data types, such as integers, strings, or booleans.
2. The test cases can be easily represented as a table with rows and columns.
3. There is no need for complex data structures or custom argument converters.

Use `@MethodSource` when:
1. The input data or expected results involve complex data types or structures, such as arrays, lists, or custom objects.
2. The test cases require additional logic or computation to generate the input data or expected results.
3. Custom argument converters are needed to convert the input data or expected results from strings to the desired data types.

In general, `@CsvSource` is more suitable for simple test cases with basic data types, while `@MethodSource` is better for complex test cases with advanced data structures or additional logic.

Now that you have a better understanding of when to use `@CsvSource` and `@MethodSource`, let's continue with the current test code.

As I mentioned earlier, I have provided you with a test class `SolutionWhiteBoxC4Test` that contains a parameterized test method `spiralOrder` for testing the `spiralOrder(int[][] matrix)` method in the `Solution` class. The test cases are provided using the `@MethodSource` annotation, which is suitable for this scenario due to the complexity of the input data and expected results.

You can now run the tests to verify the correctness of the `spiralOrder` method. If you encounter any issues or need further assistance, please let me know. Additionally, if you have any other code snippets or testing scenarios you'd like help with, feel free to share them.

👤 The code that you generated for the test works perfectly and meets all my requirements.

🤖 I'm glad to hear that the test code meets your requirements and works as expected! If you have any more questions, need further assistance, or have other code snippets that require testing, please don't hesitate to ask. I'm here to help!

{% endraw %}
