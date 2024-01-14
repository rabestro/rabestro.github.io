---
title: "BDD Legal Age Predicate"
date: 2023-12-03 19:59:26 +0300
categories: [AI]
tags: [ai, gpt-4]
mermaid: false
---



## The AI Conversation Log

{% raw %}
👤 Hello!

🤖 Hello! How can I help you today? Do you have a task or a problem that you'd like me to solve?

👤 Create a predicate that returns true if a user is over 18.

The suggested class name:

public final class LegalAgePredicate implements Predicate<LocalDate> 

🤖 To create a predicate that checks if a user is over 18, we need to clarify a few points:

1. The input parameter is a LocalDate, which represents the user's date of birth.
2. The current date should be used to calculate the user's age.

Based on these points, I will suggest test cases for the task.

Test cases:
1. User is exactly 18 years old today.
2. User is one day older than 18 years.
3. User is one day younger than 18 years.
4. User is exactly 19 years old today.
5. User is born today (edge case).

Please confirm if these test cases are good, and then I will proceed with the implementation approach.

👤 Use Clock for mocking date. Create two constructors for the predicate. print test cases in a table format. use concrete dates.

🤖 Thank you for the clarification. I will use the Clock class for mocking the date and create two constructors for the predicate. Here are the test cases in a table format with concrete dates:

| Test Case Description          | Date of Birth | Current Date | Expected Result |
|---------------------------------|---------------|--------------|-----------------|
| User is exactly 18 years old    | 2004-03-01    | 2022-03-01   | true            |
| User is one day older than 18   | 2004-02-28    | 2022-03-01   | true            |
| User is one day younger than 18 | 2004-03-02    | 2022-03-01   | false           |
| User is exactly 19 years old    | 2003-03-01    | 2022-03-01   | true            |
| User is born today (edge case)  | 2022-03-01    | 2022-03-01   | false           |

Please confirm if these test cases are good, and then I will proceed with the implementation approach.

👤 fine. use method source for unit tests

🤖 Great! I will use `@MethodSource` for the unit tests. Here's the test code for the LegalAgePredicate class:

```java
package com.example;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.time.Clock;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("LegalAgePredicate tests")
class LegalAgePredicateAiTest {

    private static Stream<Arguments> legalAgePredicateTestCases() {
        return Stream.of(
                Arguments.of("User is exactly 18 years old", "2004-03-01", "2022-03-01", true),
                Arguments.of("User is one day older than 18", "2004-02-28", "2022-03-01", true),
                Arguments.of("User is one day younger than 18", "2004-03-02", "2022-03-01", false),
                Arguments.of("User is exactly 19 years old", "2003-03-01", "2022-03-01", true),
                Arguments.of("User is born today (edge case)", "2022-03-01", "2022-03-01", false)
        );
    }

    @DisplayName("LegalAgePredicate test cases")
    @ParameterizedTest(name = "[{index}] {0}")
    @MethodSource("legalAgePredicateTestCases")
    void legalAgePredicateTest(String description, String dateOfBirthStr, String currentDateStr, boolean expectedResult) {
        LocalDate dateOfBirth = LocalDate.parse(dateOfBirthStr);
        LocalDate currentDate = LocalDate.parse(currentDateStr);
        Clock clock = Clock.fixed(currentDate.atStartOfDay(ZoneId.systemDefault()).toInstant(), ZoneId.systemDefault());
        LegalAgePredicate legalAgePredicate = new LegalAgePredicate(clock);

        assertThat(legalAgePredicate.test(dateOfBirth))
                .as("Check if user with date of birth %s is over 18 on %s", dateOfBirth, currentDate)
                .isEqualTo(expectedResult);
    }
}
```

Please confirm if the test code is good, and then I will proceed with the implementation of the LegalAgePredicate class.

👤 I prefer to use var inside methods

🤖 I apologize for the oversight. I have updated the test code to use the `var` keyword inside the test method:

```java
package com.example;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.time.Clock;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("LegalAgePredicate tests")
class LegalAgePredicateAiTest {

    private static Stream<Arguments> legalAgePredicateTestCases() {
        return Stream.of(
                Arguments.of("User is exactly 18 years old", "2004-03-01", "2022-03-01", true),
                Arguments.of("User is one day older than 18", "2004-02-28", "2022-03-01", true),
                Arguments.of("User is one day younger than 18", "2004-03-02", "2022-03-01", false),
                Arguments.of("User is exactly 19 years old", "2003-03-01", "2022-03-01", true),
                Arguments.of("User is born today (edge case)", "2022-03-01", "2022-03-01", false)
        );
    }

    @DisplayName("LegalAgePredicate test cases")
    @ParameterizedTest(name = "[{index}] {0}")
    @MethodSource("legalAgePredicateTestCases")
    void legalAgePredicateTest(String description, String dateOfBirthStr, String currentDateStr, boolean expectedResult) {
        var dateOfBirth = LocalDate.parse(dateOfBirthStr);
        var currentDate = LocalDate.parse(currentDateStr);
        var clock = Clock.fixed(currentDate.atStartOfDay(ZoneId.systemDefault()).toInstant(), ZoneId.systemDefault());
        var legalAgePredicate = new LegalAgePredicate(clock);

        assertThat(legalAgePredicate.test(dateOfBirth))
                .as("Check if user with date of birth %s is over 18 on %s", dateOfBirth, currentDate)
                .isEqualTo(expectedResult);
    }
}
```

Please confirm if the test code is good, and then I will proceed with the implementation of the LegalAgePredicate class.

👤 fine

🤖 Great! Now I will implement the LegalAgePredicate class:

```java
package com.example;

import java.time.Clock;
import java.time.LocalDate;
import java.time.Period;
import java.util.function.Predicate;

/**
 * A predicate that checks if a user is over 18 years old based on their date of birth.
 */
public final class LegalAgePredicate implements Predicate<LocalDate> {

    private static final int LEGAL_AGE = 18;
    private final Clock clock;

    /**
     * Creates a LegalAgePredicate with the system default clock.
     */
    public LegalAgePredicate() {
        this(Clock.systemDefaultZone());
    }

    /**
     * Creates a LegalAgePredicate with the specified clock.
     *
     * @param clock the clock to use for calculating the current date
     */
    public LegalAgePredicate(Clock clock) {
        this.clock = clock;
    }

    /**
     * Tests if the user with the given date of birth is over 18 years old.
     *
     * @param dateOfBirth the user's date of birth
     * @return true if the user is over 18 years old, false otherwise
     */
    @Override
    public boolean test(LocalDate dateOfBirth) {
        var currentDate = LocalDate.now(clock);
        var age = Period.between(dateOfBirth, currentDate).getYears();
        return age >= LEGAL_AGE;
    }
}
```

This implementation includes two constructors, one with the system default clock and another with a specified clock for mocking the date. The `test` method calculates the user's age based on their date of birth and the current date, and returns true if the user is over 18 years old.

Please let me know if you have any questions or need further assistance.

👤 Thank you for your greate work!

🤖 You're welcome! I'm glad I could help. If you have any more questions or need assistance with other tasks, feel free to ask. Have a great day!


👤 Can you rewrite unit test for Spock Framework and add some more test cases

🤖 Sure! I will rewrite the unit test for the Spock Framework and add more test cases. Here's the updated test code using Spock:

```groovy
package com.example

import spock.lang.Specification
import spock.lang.Unroll

import java.time.Clock
import java.time.LocalDate
import java.time.ZoneId

class LegalAgePredicateSpockTest extends Specification {

    @Unroll
    def "LegalAgePredicate test cases: #description"() {
        given:
        LocalDate dateOfBirth = LocalDate.parse(dateOfBirthStr)
        LocalDate currentDate = LocalDate.parse(currentDateStr)
        Clock clock = Clock.fixed(currentDate.atStartOfDay(ZoneId.systemDefault()).toInstant(), ZoneId.systemDefault())
        LegalAgePredicate legalAgePredicate = new LegalAgePredicate(clock)

        expect:
        legalAgePredicate.test(dateOfBirth) == expectedResult

        where:
        description         | dateOfBirthStr | currentDateStr | expectedResult
        "User is exactly 18 years old"    | "2004-03-01"    | "2022-03-01"   | true
        "User is one day older than 18"   | "2004-02-28"    | "2022-03-01"   | true
        "User is one day younger than 18" | "2004-03-02"    | "2022-03-01"   | false
        "User is exactly 19 years old"    | "2003-03-01"    | "2022-03-01"   | true
        "User is born today (edge case)"  | "2022-03-01"    | "2022-03-01"   | false
        "User is exactly 17 years old"    | "2005-03-01"    | "2022-03-01"   | false
        "User is exactly 20 years old"    | "2002-03-01"    | "2022-03-01"   | true
        "User is born on a leap year"     | "2000-02-29"    | "2022-03-01"   | true
    }
}
```

I have added three more test cases:
1. User is exactly 17 years old.
2. User is exactly 20 years old.
3. User is born on a leap year.

Please let me know if you have any questions or need further assistance.

👤 1. I prefer to use def inside methods. 
2. Add a separate test method to test default constructor. Groovy can access private fields. 

🤖 I apologize for the oversight. I have updated the Spock test to use `def` inside the test method and added a separate test method to test the default constructor. Here's the updated test code:

```groovy
package com.example

import spock.lang.Specification
import spock.lang.Unroll

import java.time.Clock
import java.time.LocalDate
import java.time.ZoneId

class LegalAgePredicateSpockTest extends Specification {

    @Unroll
    def "LegalAgePredicate test cases: #description"() {
        given:
        def dateOfBirth = LocalDate.parse(dateOfBirthStr)
        def currentDate = LocalDate.parse(currentDateStr)
        def clock = Clock.fixed(currentDate.atStartOfDay(ZoneId.systemDefault()).toInstant(), ZoneId.systemDefault())
        def legalAgePredicate = new LegalAgePredicate(clock)

        expect:
        legalAgePredicate.test(dateOfBirth) == expectedResult

        where:
        description         | dateOfBirthStr | currentDateStr | expectedResult
        "User is exactly 18 years old"    | "2004-03-01"    | "2022-03-01"   | true
        "User is one day older than 18"   | "2004-02-28"    | "2022-03-01"   | true
        "User is one day younger than 18" | "2004-03-02"    | "2022-03-01"   | false
        "User is exactly 19 years old"    | "2003-03-01"    | "2022-03-01"   | true
        "User is born today (edge case)"  | "2022-03-01"    | "2022-03-01"   | false
        "User is exactly 17 years old"    | "2005-03-01"    | "2022-03-01"   | false
        "User is exactly 20 years old"    | "2002-03-01"    | "2022-03-01"   | true
        "User is born on a leap year"     | "2000-02-29"    | "2022-03-01"   | true
    }

    def "LegalAgePredicate default constructor test"() {
        given:
        def legalAgePredicate = new LegalAgePredicate()

        expect:
        legalAgePredicate.clock == Clock.systemDefaultZone()
    }
}
```

In the updated test code, I have used `def` inside the test method and added a separate test method called "LegalAgePredicate default constructor test" to test the default constructor. This test checks if the `clock` field of the LegalAgePredicate instance is equal to the system default clock.

Please let me know if you have any questions or need further assistance.
{% endraw %}

