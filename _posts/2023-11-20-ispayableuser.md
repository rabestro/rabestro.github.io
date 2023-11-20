---
title: "Implementing the method isPayableUser using the BDD approach"
date: 2023-11-20 11:27:15 +0300
categories: [AI]
tags: [ai, gpt-4]
mermaid: false
---


## The AI Conversation Log

{% raw %}
👤 Hello, 

🤖 Hello! How can I help you today? If you have a task or a problem related to Java development that you'd like me to assist with, please provide a description, and we can get started.

👤 I have to implement a static method for the Service interface, which returns true if the user is over 18 years old.

The classes are:
```java
package com.epam.jmp.dto;

import java.time.LocalDate;

public record User(String name, String surname, LocalDate birthday) {
}
```

and the method signature:

```java
package com.epam.jmp.service.api;

public interface Service {
	static boolean isPayableUser(User user) {}
}
```

🤖 Thank you for providing the details. Let's first clarify any unclear points and specify the test cases we need to cover using the techniques mentioned in the BDD approach.

1. Test cases (Edge Coverage, Branch Coverage, Condition Coverage, Multiple Condition coverage, Path coverage, State coverage):
   - Test case 1.1: User is exactly 18 years old.
   - Test case 1.2: User is younger than 18 years old.
   - Test case 1.3: User is older than 18 years old.
   - Test case 2.1: User is null.

Please confirm if these test cases look good so we can proceed.

👤 fine

🤖 Great! We have the test cases confirmed. Now let's generate the test code using JUnit 5 with AssertJ assertions. We will create a test class `ServiceAiTest` in the same package as the tested code, `com.epam.jmp.service.api`.

```java
package com.epam.jmp.service.api;

import com.epam.jmp.dto.User;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.time.LocalDate;
import java.util.stream.Stream;

import static com.epam.jmp.service.api.Service.isPayableUser;
import static org.assertj.core.api.Assertions.assertThat;

class ServiceAiTest {

    static Stream<Arguments> userTestData() {
        return Stream.of(
            Arguments.of("User is exactly 18 years old.", LocalDate.now().minusYears(18), true),
            Arguments.of("User is younger than 18 years old.", LocalDate.now().minusYears(17), false),
            Arguments.of("User is older than 18 years old.", LocalDate.now().minusYears(19), true),
            Arguments.of("User is null.", null, false)
        );
    }

    @DisplayName("isPayableUser test:")
    @ParameterizedTest(name = "{index}. {0}")
    @MethodSource("userTestData")
    void isPayableUserTest(String description, LocalDate birthday, boolean expectedOutput) {
        var user = birthday != null ? new User("John", "Doe", birthday) : null;
        assertThat(isPayableUser(user)).as("User '%s %s' with birthdate '%s' should return: %b", user == null ? null : user.name(), user == null ? null : user.surname(), birthday, expectedOutput).isEqualTo(expectedOutput);
    }

}
```

Please confirm if the test code looks good, and then I'll provide the implementation for the `isPayableUser` method in the `Service` interface.

👤 The tests should not depend on the system time. Use Clock class to mock LocalDate.now. Suggest how we can create an implementation that allows this test approach. You can suggest any ways to implement this method. Including creating a separate class in which you can mock the clock.

🤖 I understand your concern. In order to test the method without depending on the system time, we can use the `Clock` class and initialize the `User` object with birthdays based on the fixed instant time.

To do this, we can create an implementation of the `Service` interface as a separate class, `UserService`, and allow the clock to be passed to the constructor. This way, we can use a different clock in tests by injecting a mocked clock with a fixed instant time.

Here's the updated `Service` interface and suggested `UserService` implementation:

```java
package com.epam.jmp.service.api;

import com.epam.jmp.dto.User;
import java.time.Clock;

public interface Service {
    boolean isPayableUser(User user);
}

package com.epam.jmp.service;

import com.epam.jmp.dto.User;
import com.epam.jmp.service.api.Service;
import java.time.Clock;
import java.time.LocalDate;

public class UserService implements Service {
    private final Clock clock;

    public UserService(Clock clock) {
        this.clock = clock;
    }

    @Override
    public boolean isPayableUser(User user) {
        if (user == null || user.birthday() == null) {
            return false;
        }
        return LocalDate.now(clock).minusYears(18).isAfter(user.birthday());
    }
}
```

Now, we can update the test cases to use the custom `UserService` and a fixed `Clock`:

```java
package com.epam.jmp.service.api;

import com.epam.jmp.dto.User;
import com.epam.jmp.service.UserService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

class ServiceAiTest {

    private static final Clock FIXED_CLOCK = Clock.fixed(Instant.parse("2023-01-01T00:00:00.00Z"), ZoneId.of("UTC"));
    private static final Service userService = new UserService(FIXED_CLOCK);

    static Stream<Arguments> userTestData() {
        return Stream.of(
            Arguments.of("User is exactly 18 years old.", LocalDate.of(2005, 1, 1), true),
            Arguments.of("User is younger than 18 years old.", LocalDate.of(2006, 1, 2), false),
            Arguments.of("User is older than 18 years old.", LocalDate.of(2003, 12, 31), true),
            Arguments.of("User is null.", null, false)
        );
    }

    @DisplayName("isPayableUser test:")
    @ParameterizedTest(name = "{index}. {0}")
    @MethodSource("userTestData")
    void isPayableUserTest(String description, LocalDate birthday, boolean expectedOutput) {
        var user = birthday != null ? new User("John", "Doe", birthday) : null;
        assertThat(userService.isPayableUser(user)).as("User '%s %s' with birthdate '%s' should return: %b", user == null ? null : user.name(), user == null ? null : user.surname(), birthday, expectedOutput).isEqualTo(expectedOutput);
    }
}
```
As shown, we've injected a fixed `Clock` instance to the `UserService` so it doesn't depend on the system time. Please let me know if this solution is acceptable, and we can continue from there.

👤 We don't have access to the User class, and therefore we can't change it. However, we can add a predicate class alongside the Service interface. For example, it can be class implementing Predicate<User> and this class can have Clock filed. In static method we can use this class and for testing we can add second constructor to the predicate class and mock clock.

🤖 I see. In that case, let's create a separate `UserPayablePredicate` class that implements `Predicate<User>` and allows mocking of the `Clock` field. We will update the `Service` interface by adding a default method and using the `UserPayablePredicate` class.

Here is the new implementation of the `Service` interface and the `UserPayablePredicate` class:

```java
package com.epam.jmp.service.api;

import com.epam.jmp.dto.User;

import java.util.function.Predicate;

public interface Service {
    default boolean isPayableUser(User user) {
        return new UserPayablePredicate().test(user);
    }
}

package com.epam.jmp.service.api;

import com.epam.jmp.dto.User;

import java.time.Clock;
import java.time.LocalDate;
import java.util.function.Predicate;

public class UserPayablePredicate implements Predicate<User> {
    private final Clock clock;

    public UserPayablePredicate() {
        this.clock = Clock.systemDefaultZone();
    }

    public UserPayablePredicate(Clock clock) {
        this.clock = clock;
    }

    @Override
    public boolean test(User user) {
        if (user == null || user.birthday() == null) {
            return false;
        }
        return LocalDate.now(clock).minusYears(18).isAfter(user.birthday());
    }
}
```

Now, let's update the test cases to use the custom `UserPayablePredicate` with a fixed `Clock`:

```java
package com.epam.jmp.service.api;

import com.epam.jmp.dto.User;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

class ServiceAiTest {

    private static final Clock FIXED_CLOCK = Clock.fixed(Instant.parse("2023-01-01T00:00:00.00Z"), ZoneId.of("UTC"));

    static Stream<Arguments> userTestData() {
        return Stream.of(
            Arguments.of("User is exactly 18 years old.", LocalDate.of(2005, 1, 1), true),
            Arguments.of("User is younger than 18 years old.", LocalDate.of(2006, 1, 2), false),
            Arguments.of("User is older than 18 years old.", LocalDate.of(2003, 12, 31), true),
            Arguments.of("User is null.", null, false)
        );
    }

    @DisplayName("isPayableUser test:")
    @ParameterizedTest(name = "{index}. {0}")
    @MethodSource("userTestData")
    void isPayableUserTest(String description, LocalDate birthday, boolean expectedOutput) {
        var user = birthday != null ? new User("John", "Doe", birthday) : null;
        var predicate = new UserPayablePredicate(FIXED_CLOCK);
        assertThat(predicate.test(user)).as("User '%s %s' with birthdate '%s' should return: %b", user == null ? null : user.name(), user == null ? null : user.surname(), birthday, expectedOutput).isEqualTo(expectedOutput);
    }
}
```

This solution should fulfill your requirements, as it doesn't depend on the system time and allows using a mocked `Clock` in test cases. Please let me know if this solution works for your use case.

👤 I prefer to separate a test case where the user is null and create a separate test method for it. also add a test case where user is not null but birthday is null. 

🤖 Understood, let's separate the test case where the user is null and where the user's birthday is null into their own test methods. We will also need to adjust the `UserPayablePredicate` class to handle the case when the user's birthday is null.

Here is the updated `UserPayablePredicate` class:

```java
package com.epam.jmp.service.api;

import com.epam.jmp.dto.User;
import java.time.Clock;
import java.time.LocalDate;
import java.util.function.Predicate;

public class UserPayablePredicate implements Predicate<User> {
    private final Clock clock;

    public UserPayablePredicate() {
        this.clock = Clock.systemDefaultZone();
    }

    public UserPayablePredicate(Clock clock) {
        this.clock = clock;
    }

    @Override
    public boolean test(User user) {
        if (user == null || user.birthday() == null) {
            return false;
        }
        return LocalDate.now(clock).minusYears(18).isAfter(user.birthday());
    }
}
```

Here is the updated `ServiceAiTest` class:

```java
package com.epam.jmp.service.api;

import com.epam.jmp.dto.User;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

class ServiceAiTest {
    private static final Clock FIXED_CLOCK = Clock.fixed(Instant.parse("2023-01-01T00:00:00.00Z"), ZoneId.of("UTC"));

    static Stream<Arguments> userTestData() {
        return Stream.of(
            Arguments.of("User is exactly 18 years old.", LocalDate.of(2005, 1, 1), true),
            Arguments.of("User is younger than 18 years old.", LocalDate.of(2006, 1, 2), false),
            Arguments.of("User is older than 18 years old.", LocalDate.of(2003, 12, 31), true)
        );
    }

    @DisplayName("isPayableUser test:")
    @ParameterizedTest(name = "{index}. {0}")
    @MethodSource("userTestData")
    void isPayableUserTest(String description, LocalDate birthday, boolean expectedOutput) {
        var user = new User("John", "Doe", birthday);
        var predicate = new UserPayablePredicate(FIXED_CLOCK);
        assertThat(predicate.test(user)).as("User '%s %s' with birthdate '%s' should return: %b", user.name(), user.surname(), birthday, expectedOutput).isEqualTo(expectedOutput);
    }

    @Test
    @DisplayName("isPayableUser should return false when User is null")
    void isPayableUser_ShouldReturnFalse_WhenUserIsNull() {
        var predicate = new UserPayablePredicate(FIXED_CLOCK);
        assertThat(predicate.test(null)).as("For NULL user should return: false").isFalse();
    }

    @Test
    @DisplayName("isPayableUser should return false when User birthday is null")
    void isPayableUser_ShouldReturnFalse_WhenUserBirthdayIsNull() {
        var user = new User("John", "Doe", null);
        var predicate = new UserPayablePredicate(FIXED_CLOCK);
        assertThat(predicate.test(user)).as("User '%s %s' with NULL birthdate should return: false", user.name(), user.surname()).isFalse();
    }
}
```

We now have separate test methods for the cases where either the user or the user's birthday is null. Please let me know if these changes are satisfactory.

👤 The tests are good but the implementation is wrong when the user has exactly 18 years. The test case fails if a user has a birthday today and is 18. Also use constant instead of magic number 18.

🤖 Thank you for pointing that out. To fix the issue, we need to adjust the implementation to check if a user is at least 18 years old instead of being older than 18.

Also, replacing the number 18 with a clearly named constant would indeed make the code more readable and maintainable. Let's name our constant `LEGAL_AGE`.

Here is the improved `UserPayablePredicate` class:

```java
package com.epam.jmp.service.api;

import com.epam.jmp.dto.User;
import java.time.Clock;
import java.time.LocalDate;
import java.util.function.Predicate;

public class UserPayablePredicate implements Predicate<User> {
    private static final int LEGAL_AGE = 18;

    private final Clock clock;

    public UserPayablePredicate() {
        this.clock = Clock.systemDefaultZone();
    }

    public UserPayablePredicate(Clock clock) {
        this.clock = clock;
    }

    @Override
    public boolean test(User user) {
        if (user == null || user.birthday() == null) {
            return false;
        }
        return !LocalDate.now(clock).minusYears(LEGAL_AGE).isBefore(user.birthday());
    }
}
```

With this implementation, the predicate will return `true` when the user is at least 18 years old and `false` when the user is younger than 18. It will also handle the case when the user's birthday is exactly 18 years ago from now.

Please kindly evaluate this new implementation.

👤 fine! Now generate the Service class with a static method that uses the instance of this predicate. You may define a constant in the interface or create a predicate inside the static method. Suggest what is better.  

🤖 Both options can be valid depending on the use case, but considering that the `UserPayablePredicate` does not have any state aside from the `Clock`, it would be more efficient to define a constant for the default predicate instance in the `Service` interface. This way, we can reuse the same default predicate instance in multiple invocations of the static method, minimizing object creation overhead.

Here's the suggested `Service` interface with a static method using the constant `UserPayablePredicate`:

```java
package com.epam.jmp.service.api;

import com.epam.jmp.dto.User;

public interface Service {
    UserPayablePredicate DEFAULT_PREDICATE = new UserPayablePredicate();

    static boolean isPayableUser(User user) {
        return DEFAULT_PREDICATE.test(user);
    }
}
```

With this implementation, you can call the `isPayableUser` static method, and it will use the constant `UserPayablePredicate`. This approach provides better performance and maintains clean code.

Let me know if you have any questions or concerns about this implementation.

👤 I'm not satisfied with the method names. Can you suggest more readable names for the constant and for the predicate please?

🤖 Of course, let's improve the naming to make it more readable and understandable.

For the constant `UserPayablePredicate`, we can rename it to `DEFAULT_PAYABLE_USER_PREDICATE`, making it clear that it represents the default instance of the predicate for checking if a user is payable.

For the predicate class, we can rename it to `IsPayableUserPredicate`, which immediately clarifies its purpose – testing if a given user is payable.

Here's the updated `Service` interface and `IsPayableUserPredicate` class with the improved names:

```java
package com.epam.jmp.service.api;

import com.epam.jmp.dto.User;

public interface Service {
    IsPayableUserPredicate DEFAULT_PAYABLE_USER_PREDICATE = new IsPayableUserPredicate();

    static boolean isPayableUser(User user) {
        return DEFAULT_PAYABLE_USER_PREDICATE.test(user);
    }
}

package com.epam.jmp.service.api;

import com.epam.jmp.dto.User;
import java.time.Clock;
import java.time.LocalDate;
import java.util.function.Predicate;

public class IsPayableUserPredicate implements Predicate<User> {
    private static final int LEGAL_AGE = 18;

    private final Clock clock;

    public IsPayableUserPredicate() {
        this.clock = Clock.systemDefaultZone();
    }

    public IsPayableUserPredicate(Clock clock) {
        this.clock = clock;
    }

    @Override
    public boolean test(User user) {
        if (user == null || user.birthday() == null) {
            return false;
        }
        return !LocalDate.now(clock).minusYears(LEGAL_AGE).isBefore(user.birthday());
    }
}
```

These new names should make the code more readable and easier to understand. Please let me know if these changes are satisfactory or if you have any other suggestions.

👤 ok, don't force yourself to come up with names, I'll take it upon myself. Thank you for your work!

🤖 You're welcome! I'm glad I could help. If you need any further assistance or have any questions, feel free to reach out. Good luck with your project, and have a great day!
{% endraw %}
