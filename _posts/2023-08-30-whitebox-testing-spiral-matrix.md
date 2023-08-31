---
title: "The problem of choosing the proper annotation. MethodSource vs. CsvSource"
date: 2023-08-30 18:09:29 +0300
categories: [AI, Testing]
tags: [ai, java, unit-test, whitebox, array, matrix]
---


## The AI Conversation Log

{% raw %}

👤 Hi, who are you?

🤖 Hello! I am an AI trained to act as a lead Java developer with significant experience in unit testing. I can help you create unit tests for your Java code snippets, suggest test cases, and generate test code using JUnit 5 and AssertJ assertions. If you have any questions or need assistance, feel free to ask!

👤 

```java
package leetcode.p54;

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
```

🤖 This is a Java class named `Solution` that contains a method `spiralOrder(int[][] matrix)` which takes a 2D integer array `matrix` as input and returns a list of integers representing the elements of the matrix in a spiral order. The class also contains a helper method `spiralOrder(int level)` which takes an integer `level` as input and returns an `IntStream` of the elements in the spiral order for the given level.

Now, let's analyze the code and suggest test cases for the `spiralOrder(int[][] matrix)` method. We will consider edge cases, branch coverage, and different scenarios to ensure the method works correctly.

1. Empty matrix
2. Matrix with only one row
3. Matrix with only one column
4. Square matrix with odd dimensions
5. Square matrix with even dimensions
6. Rectangular matrix with more rows than columns
7. Rectangular matrix with more columns than rows

Please confirm if these test cases are good, and then I will generate the test code.

👤 it's fine

🤖 Great! Now I will generate the test code using JUnit 5 and AssertJ assertions for the `spiralOrder(int[][] matrix)` method.

```java
package leetcode.p54;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class SolutionWhiteBoxC4Test {

    private final Solution solution = new Solution();

    @Test
    @DisplayName("Empty matrix")
    void emptyMatrix() {
        int[][] matrix = new int[][]{};
        List<Integer> expectedResult = List.of();
        var actualResult = solution.spiralOrder(matrix);
        assertThat(actualResult).isEqualTo(expectedResult);
    }

    @DisplayName("Spiral order of matrix")
    @ParameterizedTest(name = "{index}. {0}")
    @CsvSource(delimiter = '|', textBlock = """
            Matrix with only one row    | {{1, 2, 3}}                     | {1, 2, 3}
            Matrix with only one column | {{1}, {2}, {3}}                | {1, 2, 3}
            Square matrix with odd dimensions | {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}} | {1, 2, 3, 6, 9, 8, 7, 4, 5}
            Square matrix with even dimensions | {{1, 2}, {3, 4}} | {1, 2, 4, 3}
            Rectangular matrix with more rows than columns | {{1, 2}, {3, 4}, {5, 6}} | {1, 2, 4, 6, 5, 3}
            Rectangular matrix with more columns than rows | {{1, 2, 3}, {4, 5, 6}} | {1, 2, 3, 6, 5, 4}
        """)
    void spiralOrder(String description, int[][] matrix, List<Integer> expectedResult) {
        var actualResult = solution.spiralOrder(matrix);
        assertThat(actualResult).isEqualTo(expectedResult);
    }
}
```

This test code includes a test for the empty matrix scenario and a parameterized test for the other scenarios. The parameterized test uses the `@CsvSource` annotation to provide input data and expected results for each test case.

👤 Can you provide some insight into your decision to utilize the CsvSource annotation?

🤖 Certainly! I chose to use the `@CsvSource` annotation for the parameterized test because it allows us to easily define multiple test cases with different input data and expected results in a concise and readable format. It's a convenient way to provide multiple test cases for a single test method, which is especially useful when testing various scenarios for a method like `spiralOrder(int[][] matrix)`.

The `@CsvSource` annotation takes a delimiter and a text block containing the test cases. In this case, I used the pipe character '|' as the delimiter to separate the columns, and a text block to define the test cases. Each line in the text block represents a test case, with the first column being the description of the scenario, the second column containing the input matrix, and the third column containing the expected result.

Using `@CsvSource` in this way makes it easy to add, modify, or remove test cases as needed, and it keeps the test code clean and organized. Additionally, it improves the readability of the test code by providing a clear overview of the different scenarios being tested and their corresponding input data and expected results.

👤 When I ran the test I got a message:
> "org.junit.jupiter.api.extension.ParameterResolutionException: Error converting parameter at index 1: No implicit conversion to convert object of type java.lang.String to type [[I"


🤖 I apologize for the oversight. It seems that the `@CsvSource` annotation is not able to implicitly convert the input data from String to a 2D integer array (int[][]). To resolve this issue, we can create a custom argument converter and use the `@ConvertWith` annotation to apply it to the appropriate parameters.

Here's the updated test code with a custom argument converter for the 2D integer array:

```java
package leetcode.p54;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.converter.ArgumentConversionException;
import org.junit.jupiter.params.converter.SimpleArgumentConverter;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ConvertWith;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class SolutionWhiteBoxC4Test {

    private final Solution solution = new Solution();

    @Test
    @DisplayName("Empty matrix")
    void emptyMatrix() {
        int[][] matrix = new int[][]{};
        List<Integer> expectedResult = List.of();
        var actualResult = solution.spiralOrder(matrix);
        assertThat(actualResult).isEqualTo(expectedResult);
    }

    @DisplayName("Spiral order of matrix")
    @ParameterizedTest(name = "{index}. {0}")
    @CsvSource(delimiter = '|', textBlock = """
            Matrix with only one row    | {{1, 2, 3}}                     | {1, 2, 3}
            Matrix with only one column | {{1}, {2}, {3}}                | {1, 2, 3}
            Square matrix with odd dimensions | {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}} | {1, 2, 3, 6, 9, 8, 7, 4, 5}
            Square matrix with even dimensions | {{1, 2}, {3, 4}} | {1, 2, 4, 3}
            Rectangular matrix with more rows than columns | {{1, 2}, {3, 4}, {5, 6}} | {1, 2, 4, 6, 5, 3}
            Rectangular matrix with more columns than rows | {{1, 2, 3}, {4, 5, 6}} | {1, 2, 3, 6, 5, 4}
        """)
    void spiralOrder(String description,
                     @ConvertWith(MatrixConverter.class) int[][] matrix,
                     @ConvertWith(ListConverter.class) List<Integer> expectedResult) {
        var actualResult = solution.spiralOrder(matrix);
        assertThat(actualResult).isEqualTo(expectedResult);
    }

    static class MatrixConverter extends SimpleArgumentConverter {
        @Override
        protected Object convert(Object source, Class<?> targetType) throws ArgumentConversionException {
            if (source instanceof String && targetType == int[][].class) {
                String[] rows = ((String) source).replaceAll("[{}]", "").split("},\\s*{");
                int[][] matrix = new int[rows.length][];
                for (int i = 0; i < rows.length; i++) {
                    String[] elements = rows[i].split(",\\s*");
                    matrix[i] = new int[elements.length];
                    for (int j = 0; j < elements.length; j++) {
                        matrix[i][j] = Integer.parseInt(elements[j]);
                    }
                }
                return matrix;
            }
            throw new IllegalArgumentException("Conversion failed");
        }
    }

    static class ListConverter extends SimpleArgumentConverter {
        @Override
        protected Object convert(Object source, Class<?> targetType) throws ArgumentConversionException {
            if (source instanceof String && targetType == List.class) {
                String[] elements = ((String) source).replaceAll("[{}]", "").split(",\\s*");
                List<Integer> list = new ArrayList<>(elements.length);
                for (String element : elements) {
                    list.add(Integer.parseInt(element));
                }
                return list;
            }
            throw new IllegalArgumentException("Conversion failed");
        }
    }
}
```

I've added two custom argument converters, `MatrixConverter` and `ListConverter`, to handle the conversion of the input data from String to a 2D integer array (int[][]) and from String to a List<Integer>, respectively. The `@ConvertWith` annotation is used to apply these converters to the appropriate parameters in the `spiralOrder` test method.

👤 Consider using an `@MethodSource` annotation 

🤖 Sure! Using an `@MethodSource` annotation is a great alternative to `@CsvSource` when dealing with complex data types. It allows us to define a separate method that provides the test cases as a Stream of Arguments. This way, we can create the input data and expected results directly as Java objects, avoiding the need for custom argument converters.

Here's the updated test code using `@MethodSource`:

```java
package leetcode.p54;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.util.List;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

class SolutionWhiteBoxC4Test {

    private final Solution solution = new Solution();

    @Test
    @DisplayName("Empty matrix")
    void emptyMatrix() {
        int[][] matrix = new int[][]{};
        List<Integer> expectedResult = List.of();
        var actualResult = solution.spiralOrder(matrix);
        assertThat(actualResult).isEqualTo(expectedResult);
    }

    @DisplayName("Spiral order of matrix")
    @ParameterizedTest(name = "{index}. {0}")
    @MethodSource("spiralOrderTestCases")
    void spiralOrder(String description, int[][] matrix, List<Integer> expectedResult) {
        var actualResult = solution.spiralOrder(matrix);
        assertThat(actualResult).isEqualTo(expectedResult);
    }

    static Stream<Arguments> spiralOrderTestCases() {
        return Stream.of(
                Arguments.of("Matrix with only one row", new int[][]{{1, 2, 3}}, List.of(1, 2, 3)),
                Arguments.of("Matrix with only one column", new int[][]{{1}, {2}, {3}}, List.of(1, 2, 3)),
                Arguments.of("Square matrix with odd dimensions", new int[][]{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}, List.of(1, 2, 3, 6, 9, 8, 7, 4, 5)),
                Arguments.of("Square matrix with even dimensions", new int[][]{{1, 2}, {3, 4}}, List.of(1, 2, 4, 3)),
                Arguments.of("Rectangular matrix with more rows than columns", new int[][]{{1, 2}, {3, 4}, {5, 6}}, List.of(1, 2, 4, 6, 5, 3)),
                Arguments.of("Rectangular matrix with more columns than rows", new int[][]{{1, 2, 3}, {4, 5, 6}}, List.of(1, 2, 3, 6, 5, 4))
        );
    }
}
```

In this version, I've replaced the `@CsvSource` annotation with the `@MethodSource` annotation and provided a method named `spiralOrderTestCases()` that returns a `Stream<Arguments>`. Each `Arguments` object contains the description, input matrix, and expected result for a test case. The `spiralOrder` test method now takes the input data and expected results directly as Java objects, so there's no need for custom argument converters.

👤 Kindly review your generated test to ensure it aligns with the initial instructions provided.

🤖 I apologize for not following the initial instructions closely. I will now revise the test code to adhere to the guidelines provided. Here's the updated test code using JUnit 5, AssertJ assertions, and the `@MethodSource` annotation:

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
    @ParameterizedTest(name = "{index}. {0}")
    @MethodSource("spiralOrderTestCases")
    void spiralOrder(String description, int[][] matrix, List<Integer> expectedResult) {
        var actualResult = solution.spiralOrder(matrix);
        assertThat(actualResult).isEqualTo(expectedResult);
    }

    static Stream<Arguments> spiralOrderTestCases() {
        return Stream.of(
                Arguments.of("Empty matrix", new int[][]{}, List.of()),
                Arguments.of("Matrix with only one row", new int[][]{{1, 2, 3}}, List.of(1, 2, 3)),
                Arguments.of("Matrix with only one column", new int[][]{{1}, {2}, {3}}, List.of(1, 2, 3)),
                Arguments.of("Square matrix with odd dimensions", new int[][]{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}, List.of(1, 2, 3, 6, 9, 8, 7, 4, 5)),
                Arguments.of("Square matrix with even dimensions", new int[][]{{1, 2}, {3, 4}}, List.of(1, 2, 4, 3)),
                Arguments.of("Rectangular matrix with more rows than columns", new int[][]{{1, 2}, {3, 4}, {5, 6}}, List.of(1, 2, 4, 6, 5, 3)),
                Arguments.of("Rectangular matrix with more columns than rows", new int[][]{{1, 2, 3}, {4, 5, 6}}, List.of(1, 2, 3, 6, 5, 4))
        );
    }
}
```

In this updated test code, I have:

1. Removed the separate test method for the empty matrix scenario and included it as a test case in the `spiralOrderTestCases()` method.
2. Used the `@MethodSource` annotation to provide test cases for the `spiralOrder` test method.
3. Removed the custom argument converters, as they are not needed with the `@MethodSource` annotation.
4. Followed the naming conventions and guidelines specified in the initial instructions.

Please let me know if there are any other changes or improvements needed.

> This is not the first time artificial intelligence has chosen the wrong way for parameterized tests. I came up with the idea of asking him to formulate rules himself that will improve the choice of the right approach for parameterized tests in the future.
{: .prompt-info } 

👤 What should I add to the initial statement to make choosing between `@CsvSource` and `@MethodSource` more efficient?

🤖 To make the decision-making process more efficient when choosing between `@CsvSource` and `@MethodSource`, you can add the following guidelines to the initial statement:

1. Use `@CsvSource` when:
   - The input data and expected results are simple data types, such as integers, strings, or booleans.
   - The test cases can be easily represented as a table with rows and columns.
   - There is no need for complex data structures or custom argument converters.

2. Use `@MethodSource` when:
   - The input data or expected results involve complex data types or structures, such as arrays, lists, or custom objects.
   - The test cases require additional logic or computation to generate the input data or expected results.
   - Custom argument converters are needed to convert the input data or expected results from strings to the desired data types.

By adding these guidelines to the initial statement, it will be easier to determine which annotation to use based on the complexity of the input data and expected results, as well as the requirements of the test cases.

👤 I thank you for your work and see you next time!

🤖 You're welcome! I'm glad I could help. If you have any more questions or need assistance in the future, don't hesitate to ask. Have a great day!

{% endraw %}
