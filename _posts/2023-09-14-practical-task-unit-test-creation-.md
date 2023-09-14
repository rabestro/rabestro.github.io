---
title: "Practical Task. Unit Test Creation "
date: 2023-09-14 14:15:07 +0300
categories: [AI]
tags: [ai, gpt-4]
mermaid: false
---


## The AI Conversation Log

{% raw %}
👤 ```java
public class DiscountCalculator { 
 
    /** 
     * Calculate the total cost after applying a discount. 
     * 
     * @param originalPrice      The original price of the item. 
     * @param discountPercentage The discount percentage (0 to 100). 
     * @return The total cost after discount. 
     * @throws IllegalArgumentException If the input types are invalid or the discount percentage is out of range. 
     */ 
    public static double calculateDiscountedPrice(double originalPrice, double discountPercentage) { 
        if (Double.isNaN(originalPrice) || Double.isNaN(discountPercentage)) { 
            throw new IllegalArgumentException("Invalid input type"); 
        } 
 
        if (discountPercentage < 0 || discountPercentage > 100) { 
            throw new IllegalArgumentException("Discount percentage should be between 0 and 100"); 
        } 
 
        double discount = originalPrice * (discountPercentage / 100); 
        return originalPrice - discount; 
    } 
 
    public static void main(String[] args) { 
        // Example usage 
        double originalPrice = 100.0; 
        double discountPercentage = 20.0; 
        double discountedPrice = calculateDiscountedPrice(originalPrice, discountPercentage); 
        System.out.println("Discounted Price: " + discountedPrice); 
    } 
}
```

🤖 Let's start by analyzing the code snippet and suggesting test cases for the `calculateDiscountedPrice` method.

1. Test case with valid input and no discount:
   - Input: originalPrice = 100.0, discountPercentage = 0.0
   - Expected output: 100.0

2. Test case with valid input and full discount:
   - Input: originalPrice = 100.0, discountPercentage = 100.0
   - Expected output: 0.0

3. Test case with valid input and partial discount:
   - Input: originalPrice = 100.0, discountPercentage = 20.0
   - Expected output: 80.0

4. Test case with valid input and minimum discount percentage:
   - Input: originalPrice = 100.0, discountPercentage = 0.01
   - Expected output: 99.99

5. Test case with valid input and maximum discount percentage:
   - Input: originalPrice = 100.0, discountPercentage = 99.99
   - Expected output: 0.01

6. Test case with invalid input (NaN originalPrice):
   - Input: originalPrice = NaN, discountPercentage = 20.0
   - Expected output: IllegalArgumentException

7. Test case with invalid input (NaN discountPercentage):
   - Input: originalPrice = 100.0, discountPercentage = NaN
   - Expected output: IllegalArgumentException

8. Test case with invalid input (negative discountPercentage):
   - Input: originalPrice = 100.0, discountPercentage = -1.0
   - Expected output: IllegalArgumentException

9. Test case with invalid input (discountPercentage greater than 100):
   - Input: originalPrice = 100.0, discountPercentage = 101.0
   - Expected output: IllegalArgumentException

Please confirm if these test cases are good, and I will proceed with generating the test code.

👤 print in a table format 

🤖 Here are the test cases in a table format:

| Test Case | Description                          | originalPrice | discountPercentage | Expected Output         |
|-----------|--------------------------------------|---------------|--------------------|-------------------------|
| 1         | Valid input, no discount             | 100.0         | 0.0                | 100.0                   |
| 2         | Valid input, full discount           | 100.0         | 100.0              | 0.0                     |
| 3         | Valid input, partial discount        | 100.0         | 20.0               | 80.0                    |
| 4         | Valid input, minimum discount        | 100.0         | 0.01               | 99.99                   |
| 5         | Valid input, maximum discount        | 100.0         | 99.99              | 0.01                    |
| 6         | Invalid input, NaN originalPrice     | NaN           | 20.0               | IllegalArgumentException |
| 7         | Invalid input, NaN discountPercentage| 100.0         | NaN                | IllegalArgumentException |
| 8         | Invalid input, negative discount     | 100.0         | -1.0               | IllegalArgumentException |
| 9         | Invalid input, discount > 100        | 100.0         | 101.0              | IllegalArgumentException |

Please confirm if these test cases are good, and I will proceed with generating the test code.

👤 Analyze generated test cases for compliance with best practices. make sure you consider all possible options for the original price and discount

🤖 After analyzing the test cases, I found that we need to add more test cases to cover all possible options for the original price and discount. Here are the additional test cases:

10. Test case with valid input and original price as zero:
   - Input: originalPrice = 0.0, discountPercentage = 20.0
   - Expected output: 0.0

11. Test case with valid input and original price as a negative value:
   - Input: originalPrice = -100.0, discountPercentage = 20.0
   - Expected output: -80.0

12. Test case with valid input and original price as the minimum positive value (Double.MIN_VALUE):
   - Input: originalPrice = Double.MIN_VALUE, discountPercentage = 20.0
   - Expected output: Double.MIN_VALUE * 0.8

13. Test case with valid input and original price as the maximum positive value (Double.MAX_VALUE):
   - Input: originalPrice = Double.MAX_VALUE, discountPercentage = 20.0
   - Expected output: Double.MAX_VALUE * 0.8

Here is the updated table with all test cases:

| Test Case | Description                          | originalPrice      | discountPercentage | Expected Output         |
|-----------|--------------------------------------|--------------------|--------------------|-------------------------|
| 1         | Valid input, no discount             | 100.0              | 0.0                | 100.0                   |
| 2         | Valid input, full discount           | 100.0              | 100.0              | 0.0                     |
| 3         | Valid input, partial discount        | 100.0              | 20.0               | 80.0                    |
| 4         | Valid input, minimum discount        | 100.0              | 0.01               | 99.99                   |
| 5         | Valid input, maximum discount        | 100.0              | 99.99              | 0.01                    |
| 6         | Invalid input, NaN originalPrice     | NaN                | 20.0               | IllegalArgumentException |
| 7         | Invalid input, NaN discountPercentage| 100.0              | NaN                | IllegalArgumentException |
| 8         | Invalid input, negative discount     | 100.0              | -1.0               | IllegalArgumentException |
| 9         | Invalid input, discount > 100        | 100.0              | 101.0              | IllegalArgumentException |
| 10        | Valid input, original price as zero  | 0.0                | 20.0               | 0.0                     |
| 11        | Valid input, negative original price | -100.0             | 20.0               | -80.0                   |
| 12        | Valid input, min positive price      | Double.MIN_VALUE   | 20.0               | Double.MIN_VALUE * 0.8  |
| 13        | Valid input, max positive price      | Double.MAX_VALUE   | 20.0               | Double.MAX_VALUE * 0.8  |

Please confirm if these test cases are good, and I will proceed with generating the test code.

👤 I think there are enough test cases. generate test code and make sure you follow all good practices

🤖 Here is the test code for the `DiscountCalculator` class, following the best practices:

```java
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ValueSource;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatIllegalArgumentException;

@DisplayName("DiscountCalculator WhiteBoxC4Test")
class DiscountCalculatorWhiteBoxC4Test {

    @DisplayName("Valid input test cases:")
    @ParameterizedTest(name = "[{index}] originalPrice: {0}, discountPercentage: {1} -> expectedOutput: {2}")
    @CsvSource({
            "100.0, 0.0, 100.0",
            "100.0, 100.0, 0.0",
            "100.0, 20.0, 80.0",
            "100.0, 0.01, 99.99",
            "100.0, 99.99, 0.01",
            "0.0, 20.0, 0.0",
            "-100.0, 20.0, -80.0",
            "Double.MIN_VALUE, 20.0, Double.MIN_VALUE * 0.8",
            "Double.MAX_VALUE, 20.0, Double.MAX_VALUE * 0.8"
    })
    void validInputTestCases(double originalPrice, double discountPercentage, double expectedOutput) {
        double result = DiscountCalculator.calculateDiscountedPrice(originalPrice, discountPercentage);
        assertThat(result).isEqualTo(expectedOutput);
    }

    @DisplayName("Invalid input test cases:")
    @ParameterizedTest(name = "[{index}] originalPrice: {0}, discountPercentage: {1}")
    @CsvSource({
            "NaN, 20.0",
            "100.0, NaN",
            "100.0, -1.0",
            "100.0, 101.0"
    })
    void invalidInputTestCases(double originalPrice, double discountPercentage) {
        assertThatIllegalArgumentException()
                .isThrownBy(() -> DiscountCalculator.calculateDiscountedPrice(originalPrice, discountPercentage));
    }
}
```

This test code uses JUnit 5 and AssertJ assertions, follows the best practices for parameterized tests, and covers all the test cases we discussed.

👤 some test fails:
1. 
org.opentest4j.AssertionFailedError: 
expected: 0.01
 but was: 0.010000000000005116
Expected :0.01
Actual   :0.010000000000005116

2. org.junit.jupiter.api.extension.ParameterResolutionException: Error converting parameter at index 0: Failed to convert String "Double.MIN_VALUE" to type java.lang.Double

Consider using a method source. use appropriate assertions for double values 

🤖 Apologies for the oversight. I will update the test code to use `@MethodSource` for handling complex data types and use appropriate assertions for double values.

Here is the updated test code:

```java
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;

import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatIllegalArgumentException;
import static org.assertj.core.api.Assertions.within;

@DisplayName("DiscountCalculator WhiteBoxC4Test")
class DiscountCalculatorWhiteBoxC4Test {

    static Stream<Object[]> validInputTestCases() {
        return Stream.of(
                new Object[]{"100.0, 0.0, 100.0", 100.0, 0.0, 100.0},
                new Object[]{"100.0, 100.0, 0.0", 100.0, 100.0, 0.0},
                new Object[]{"100.0, 20.0, 80.0", 100.0, 20.0, 80.0},
                new Object[]{"100.0, 0.01, 99.99", 100.0, 0.01, 99.99},
                new Object[]{"100.0, 99.99, 0.01", 100.0, 99.99, 0.01},
                new Object[]{"0.0, 20.0, 0.0", 0.0, 20.0, 0.0},
                new Object[]{"-100.0, 20.0, -80.0", -100.0, 20.0, -80.0},
                new Object[]{"Double.MIN_VALUE, 20.0, Double.MIN_VALUE * 0.8", Double.MIN_VALUE, 20.0, Double.MIN_VALUE * 0.8},
                new Object[]{"Double.MAX_VALUE, 20.0, Double.MAX_VALUE * 0.8", Double.MAX_VALUE, 20.0, Double.MAX_VALUE * 0.8}
        );
    }

    @DisplayName("Valid input test cases:")
    @ParameterizedTest(name = "[{index}] {0}")
    @MethodSource("validInputTestCases")
    void validInputTestCases(String description, double originalPrice, double discountPercentage, double expectedOutput) {
        double result = DiscountCalculator.calculateDiscountedPrice(originalPrice, discountPercentage);
        assertThat(result).isCloseTo(expectedOutput, within(1e-10));
    }

    static Stream<Object[]> invalidInputTestCases() {
        return Stream.of(
                new Object[]{"NaN, 20.0", Double.NaN, 20.0},
                new Object[]{"100.0, NaN", 100.0, Double.NaN},
                new Object[]{"100.0, -1.0", 100.0, -1.0},
                new Object[]{"100.0, 101.0", 100.0, 101.0}
        );
    }

    @DisplayName("Invalid input test cases:")
    @ParameterizedTest(name = "[{index}] {0}")
    @MethodSource("invalidInputTestCases")
    void invalidInputTestCases(String description, double originalPrice, double discountPercentage) {
        assertThatIllegalArgumentException()
                .isThrownBy(() -> DiscountCalculator.calculateDiscountedPrice(originalPrice, discountPercentage));
    }
}
```

This updated test code uses `@MethodSource` for handling complex data types and uses the `isCloseTo` assertion with a specified precision for comparing double values.

👤 ensure you follow best practices for method source. add test case description, use Arguments.of

🤖 Apologies for the oversight. I will update the test code to follow the best practices for `@MethodSource`, including adding test case descriptions and using `Arguments.of`.

Here is the updated test code:

```java
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatIllegalArgumentException;
import static org.assertj.core.api.Assertions.within;

@DisplayName("DiscountCalculator WhiteBoxC4Test")
class DiscountCalculatorWhiteBoxC4Test {

    static Stream<Arguments> validInputTestCases() {
        return Stream.of(
                Arguments.of("100.0, 0.0, 100.0", 100.0, 0.0, 100.0),
                Arguments.of("100.0, 100.0, 0.0", 100.0, 100.0, 0.0),
                Arguments.of("100.0, 20.0, 80.0", 100.0, 20.0, 80.0),
                Arguments.of("100.0, 0.01, 99.99", 100.0, 0.01, 99.99),
                Arguments.of("100.0, 99.99, 0.01", 100.0, 99.99, 0.01),
                Arguments.of("0.0, 20.0, 0.0", 0.0, 20.0, 0.0),
                Arguments.of("-100.0, 20.0, -80.0", -100.0, 20.0, -80.0),
                Arguments.of("Double.MIN_VALUE, 20.0, Double.MIN_VALUE * 0.8", Double.MIN_VALUE, 20.0, Double.MIN_VALUE * 0.8),
                Arguments.of("Double.MAX_VALUE, 20.0, Double.MAX_VALUE * 0.8", Double.MAX_VALUE, 20.0, Double.MAX_VALUE * 0.8)
        );
    }

    @DisplayName("Valid input test cases:")
    @ParameterizedTest(name = "[{index}] {0}")
    @MethodSource("validInputTestCases")
    void validInputTestCases(String description, double originalPrice, double discountPercentage, double expectedOutput) {
        double result = DiscountCalculator.calculateDiscountedPrice(originalPrice, discountPercentage);
        assertThat(result).isCloseTo(expectedOutput, within(1e-10));
    }

    static Stream<Arguments> invalidInputTestCases() {
        return Stream.of(
                Arguments.of("NaN, 20.0", Double.NaN, 20.0),
                Arguments.of("100.0, NaN", 100.0, Double.NaN),
                Arguments.of("100.0, -1.0", 100.0, -1.0),
                Arguments.of("100.0, 101.0", 100.0, 101.0)
        );
    }

    @DisplayName("Invalid input test cases:")
    @ParameterizedTest(name = "[{index}] {0}")
    @MethodSource("invalidInputTestCases")
    void invalidInputTestCases(String description, double originalPrice, double discountPercentage) {
        assertThatIllegalArgumentException()
                .isThrownBy(() -> DiscountCalculator.calculateDiscountedPrice(originalPrice, discountPercentage));
    }
}
```

This updated test code follows the best practices for `@MethodSource`, including adding test case descriptions and using `Arguments.of`.

👤 all tests pass. I want to improve test case descriptions

🤖 I have updated the test case descriptions to provide more context and clarity. Here is the revised test code:

```java
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatIllegalArgumentException;
import static org.assertj.core.api.Assertions.within;

@DisplayName("DiscountCalculator WhiteBoxC4Test")
class DiscountCalculatorWhiteBoxC4Test {

    static Stream<Arguments> validInputTestCases() {
        return Stream.of(
                Arguments.of("No discount (0%)", 100.0, 0.0, 100.0),
                Arguments.of("Full discount (100%)", 100.0, 100.0, 0.0),
                Arguments.of("Partial discount (20%)", 100.0, 20.0, 80.0),
                Arguments.of("Minimum discount (0.01%)", 100.0, 0.01, 99.99),
                Arguments.of("Maximum discount (99.99%)", 100.0, 99.99, 0.01),
                Arguments.of("Original price is zero", 0.0, 20.0, 0.0),
                Arguments.of("Negative original price", -100.0, 20.0, -80.0),
                Arguments.of("Minimum positive original price", Double.MIN_VALUE, 20.0, Double.MIN_VALUE * 0.8),
                Arguments.of("Maximum positive original price", Double.MAX_VALUE, 20.0, Double.MAX_VALUE * 0.8)
        );
    }

    @DisplayName("Valid input test cases:")
    @ParameterizedTest(name = "[{index}] {0}")
    @MethodSource("validInputTestCases")
    void validInputTestCases(String description, double originalPrice, double discountPercentage, double expectedOutput) {
        double result = DiscountCalculator.calculateDiscountedPrice(originalPrice, discountPercentage);
        assertThat(result).isCloseTo(expectedOutput, within(1e-10));
    }

    static Stream<Arguments> invalidInputTestCases() {
        return Stream.of(
                Arguments.of("NaN original price", Double.NaN, 20.0),
                Arguments.of("NaN discount percentage", 100.0, Double.NaN),
                Arguments.of("Negative discount percentage", 100.0, -1.0),
                Arguments.of("Discount percentage greater than 100", 100.0, 101.0)
        );
    }

    @DisplayName("Invalid input test cases:")
    @ParameterizedTest(name = "[{index}] {0}")
    @MethodSource("invalidInputTestCases")
    void invalidInputTestCases(String description, double originalPrice, double discountPercentage) {
        assertThatIllegalArgumentException()
                .isThrownBy(() -> DiscountCalculator.calculateDiscountedPrice(originalPrice, discountPercentage));
    }
}
```

The test case descriptions are now more informative and easier to understand.
{% endraw %}
