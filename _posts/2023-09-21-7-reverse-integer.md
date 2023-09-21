---
title: "7. Reverse Integer"
date: 2023-09-21 20:04:36 +0300
categories: [AI]
tags: [ai, gpt-4]
mermaid: false
---



## The AI Conversation Log

{% raw %}
👤 class Solution {
    public int reverse(int x) {
        
    }
}

🤖 To create unit tests for the `reverse` method, I need to know the problem statement and any additional information related to the method. Please provide the problem statement and any other relevant information.

👤 Given a signed 32-bit integer x, return x with its digits reversed. If reversing x causes the value to go outside the signed 32-bit integer range [-231, 231 - 1], then return 0.

Assume the environment does not allow you to store 64-bit integers (signed or unsigned).

Example 1:

Input: x = 123
Output: 321

Example 2:

Input: x = -123
Output: -321

Example 3:

Input: x = 120
Output: 21

Constraints:

    -231 <= x <= 231 - 1



🤖 Thank you for providing the problem statement. Based on the given information, I will suggest the following test cases for the `reverse` method:

1. Test Case 1: Positive number within the 32-bit integer range
   Input: x = 123
   Output: 321

2. Test Case 2: Negative number within the 32-bit integer range
   Input: x = -123
   Output: -321

3. Test Case 3: Positive number with trailing zeros
   Input: x = 120
   Output: 21

4. Test Case 4: Negative number with trailing zeros
   Input: x = -120
   Output: -21

5. Test Case 5: Maximum 32-bit integer
   Input: x = 2147483647
   Output: 0

6. Test Case 6: Minimum 32-bit integer
   Input: x = -2147483648
   Output: 0

7. Test Case 7: Zero
   Input: x = 0
   Output: 0

Please confirm if these test cases are good to proceed with generating the test code.

👤 add cases with maximum positive and negative numbers that can be reversed 

🤖 I have added two more test cases for the maximum positive and negative numbers that can be reversed within the 32-bit integer range:

8. Test Case 8: Maximum positive number that can be reversed
   Input: x = 2147447412
   Output: 2147447412

9. Test Case 9: Maximum negative number that can be reversed
   Input: x = -2147447412
   Output: -2147447412

Please confirm if these test cases are good to proceed with generating the test code.

👤 good

🤖 Great! I will now generate the test code for the `reverse` method using the test cases we have discussed.

```java
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import static org.assertj.core.api.Assertions.assertThat;

class SolutionBlackBoxC4Test {

    private final Solution solution = new Solution();

    @DisplayName("Reverse Integer Test:")
    @ParameterizedTest(name = "[{index}] {0}")
    @CsvSource(delimiter = '|', textBlock = """
            Test Case 1: Positive number within the 32-bit integer range | 123          | 321
            Test Case 2: Negative number within the 32-bit integer range | -123         | -321
            Test Case 3: Positive number with trailing zeros             | 120          | 21
            Test Case 4: Negative number with trailing zeros             | -120         | -21
            Test Case 5: Maximum 32-bit integer                          | 2147483647   | 0
            Test Case 6: Minimum 32-bit integer                          | -2147483648  | 0
            Test Case 7: Zero                                            | 0            | 0
            Test Case 8: Maximum positive number that can be reversed    | 2147447412   | 2147447412
            Test Case 9: Maximum negative number that can be reversed    | -2147447412  | -2147447412
    """)
    void reverseIntegerTest(String description, int input, int expectedOutput) {
        var result = solution.reverse(input);
        assertThat(result)
                .withFailMessage("Expected reverse of %d to be %d, but got %d", input, expectedOutput, result)
                .isEqualTo(expectedOutput);
    }
}
```

This test code uses JUnit 5 and AssertJ assertions. It covers all the test cases we have discussed, and it follows the best practices for parameterized tests.

👤 implement solution

🤖 Here's the implementation of the `reverse` method for the `Solution` class:

```java
class Solution {
    public int reverse(int x) {
        int reversed = 0;
        while (x != 0) {
            int pop = x % 10;
            x /= 10;

            if (reversed > Integer.MAX_VALUE / 10 || (reversed == Integer.MAX_VALUE / 10 && pop > 7)) {
                return 0;
            }
            if (reversed < Integer.MIN_VALUE / 10 || (reversed == Integer.MIN_VALUE / 10 && pop < -8)) {
                return 0;
            }

            reversed = reversed * 10 + pop;
        }
        return reversed;
    }
}
```

This implementation checks for overflow and underflow while reversing the integer. It should work correctly with the provided test cases.
{% endraw %}

