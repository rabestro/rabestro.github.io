---
title: "Conquering Test Case Challenges with AI: A Journey with Pig Latin Translations"
date: 2023-09-02 21:20:29 +0300
categories: [AI, Testing]
tags: [ai, testing, java, unit-test, junit, exercism]
mermaid: false
---
{% raw %}

Imagine having an experienced assistant who can generate high-quality unit tests following all the best practices. Over a series of experiments, I've been working with an AI to achieve this goal. Recently, I explored a task from the Exercism website, where the objective was to create a Pig Latin translation program in Java. You can find it [here](https://exercism.org/tracks/java/exercises/pig-latin).

In this blog post, I will share my conversation with the AI and discuss the exciting learning experiences we encountered together.

## The Task: Pig Latin Translation

The task was to implement a program that translates English text into Pig Latin. For this purpose, I provided the AI with the problem statement and method signature. Subsequently, we discussed different test cases to ensure comprehensive coverage and took time to address any errors or shortcomings.

## Collaboration with the AI

Our dialog started with the AI suggesting initial test cases based on the provided problem statement. As we built upon the test cases, I suggested additional cases to cover more scenarios. The AI made only a minor error in one of the test case descriptions, which we quickly fixed together.

When generating the test code, it became evident that the AI had made an error in handling empty strings. I engaged in a discussion with the AI to understand the cause of the issue, eventually finding a solution that prevented such issues in the future.

Throughout the process, the AI showed its capabilities in creating modular tests. With continuous feedback and collaboration, the AI is bound to become better over time.

## Lessons Learned

1. **Human-machine collaboration**: Effective communication between humans and machines can be incredibly productive in generating high-quality test cases while addressing and rectifying errors.

2. **Continuous improvement**: AI, with the ongoing support of humans, can learn from its mistakes and progressively refine its testing abilities.

3. **In-depth understanding**: Exploring the dynamics of AI and testing techniques reveal insights that can help both humans and machines improve their skills and understanding.

## The Future of Testing with AI

As AI progresses, it will only become better at generating modular tests and adapting to changes in best practices. Our interaction illustrates how essential it is for humans and machines to collaborate, providing valuable insights to guide AI improvements.

In conclusion, this experiment demonstrates not only the power of combining human expertise with AI technology in creating unit tests but also the importance of reciprocal learning between humans and machines.

Below is the full conversation log with the AI for your reference:

## The AI Conversation Log

👤 Hi, who are you?

🤖 Hello! I am an AI trained to act as a lead Java developer with significant experience in black box testing. I can help you create unit tests for your Java code, analyze problem statements, and suggest test cases. If you have any questions or need assistance, feel free to ask!

👤 What information do you need to create a unit test?

🤖 To create a unit test, I need the following information:

1. Method signature: The method's name, return type, and input parameters.
2. Problem statement: A clear description of what the method is supposed to do, including any constraints or assumptions.
3. Relevant classes and data structures: Any additional classes, interfaces, or data structures that are used in the method or are relevant to the problem.
4. Examples: Sample input and output values to help understand the problem and expected behavior.

Once I have this information, I can analyze the problem statement and suggest test cases to cover various scenarios. After confirming the test cases, I can generate the test code using Java 17 and JUnit 5 framework with AssertJ assertions.

👤 What practices do you use?

🤖 When creating unit tests, I follow best practices and techniques to ensure comprehensive test coverage and maintainable test code. Some of these practices include:

1. Edge Coverage: Testing the boundary values of input parameters to ensure the method handles edge cases correctly.
2. Branch Coverage: Ensuring that each branch in the code is executed at least once by the test cases.
3. Condition Coverage: Testing all possible outcomes of each condition in the code.
4. Multiple Condition Coverage: Testing all possible combinations of conditions in the code.
5. Path Coverage: Ensuring that all possible execution paths in the code are covered by the test cases.
6. State Coverage: Testing the method's behavior in different states of the system or object.

In addition to these testing techniques, I follow best practices for writing test code, such as:

- Using Java 17 and taking advantage of its features.
- Using JUnit 5 framework with AssertJ assertions for a powerful and expressive testing experience.
- Writing self-documenting, parameterized, and readable test code.
- Customizing display names for parameterized tests.
- Using `@DisplayName` annotation to provide a display name for the test class or test method.
- Placing the test class in the same package as the tested code.
- Using `var` keyword instead of the fully qualified type name inside test methods.
- Separating null or edge test cases into separate test methods.

For assertions, I follow these guidelines:

- Using the `assertThat()` assertion.
- Adding a customized message to clearly explain the expected outcome.
- Keeping it concise by chaining multiple assertions.
- Placing each chaining method on a separate line.

👤 Fine, the method signature is:
```java
public final class PigLatinTranslator {
    public String translate(String sentence) {
```

🤖 Thank you for providing the method signature. Now, I need the problem statement, which should include a clear description of what the `translate` method is supposed to do, any constraints or assumptions, and any relevant examples. This information will help me understand the expected behavior and suggest appropriate test cases.

👤 Instructions

Implement a program that translates from English to Pig Latin.

Pig Latin is a made-up children's language that's intended to be confusing. It obeys a few simple rules (below), but when it's spoken quickly it's really difficult for non-children (and non-native speakers) to understand.

 - **Rule 1**: If a word begins with a vowel sound, add an "ay" sound to the end of the word. Please note that "xr" and "yt" at the beginning of a word make vowel sounds (e.g. "xray" -> "xrayay", "yttria" -> "yttriaay").
 - **Rule 2**: If a word begins with a consonant sound, move it to the end of the word and then add an "ay" sound to the end of the word. Consonant sounds can be made up of multiple consonants, a.k.a. a consonant cluster (e.g. "chair" -> "airchay").
 - **Rule 3**: If a word starts with a consonant sound followed by "qu", move it to the end of the word, and then add an "ay" sound to the end of the word (e.g. "square" -> "aresquay").
 - **Rule 4**: If a word contains a "y" after a consonant cluster or as the second letter in a two letter word it makes a vowel sound (e.g. "rhythm" -> "ythmrhay", "my" -> "ymay").

There are a few more rules for edge cases, and there are regional variants too.

See http://en.wikipedia.org/wiki/Pig_latin for more details.

🤖 Thank you for providing the problem statement. Based on the provided information, I will suggest test cases to cover various scenarios for the `translate` method in the `PigLatinTranslator` class.

Test Cases:

1. Test case with a single word starting with a vowel sound.
   Input: "apple"
   Expected Output: "appleay"

2. Test case with a single word starting with "xr".
   Input: "xray"
   Expected Output: "xrayay"

3. Test case with a single word starting with "yt".
   Input: "yttria"
   Expected Output: "yttriaay"

4. Test case with a single word starting with a consonant sound.
   Input: "chair"
   Expected Output: "airchay"

5. Test case with a single word starting with a consonant sound followed by "qu".
   Input: "square"
   Expected Output: "aresquay"

6. Test case with a single word containing a "y" after a consonant cluster.
   Input: "rhythm"
   Expected Output: "ythmrhay"

7. Test case with a two-letter word containing "y" as the second letter.
   Input: "my"
   Expected Output: "ymay"

8. Test case with a sentence containing multiple words.
   Input: "apple chair square rhythm my"
   Expected Output: "appleay airchay aresquay ythmrhay ymay"

9. Test case with an empty string.
   Input: ""
   Expected Output: ""

Please confirm if these test cases cover the expected scenarios, and then I will proceed with generating the test code.

👤 I prefer to see test cases in a table format 

🤖 Sure, here are the test cases in a table format:

| Test Case No. | Description                                      | Input                 | Expected Output       |
|---------------|--------------------------------------------------|-----------------------|-----------------------|
| 1             | Single word starting with a vowel sound          | "apple"               | "appleay"             |
| 2             | Single word starting with "xr"                   | "xray"                | "xrayay"              |
| 3             | Single word starting with "yt"                   | "yttria"              | "yttriaay"            |
| 4             | Single word starting with a consonant sound      | "chair"               | "airchay"             |
| 5             | Single word starting with consonant sound + "qu" | "square"              | "aresquay"            |
| 6             | Single word with "y" after a consonant cluster   | "rhythm"              | "ythmrhay"            |
| 7             | Two-letter word with "y" as the second letter    | "my"                  | "ymay"                |
| 8             | Sentence with multiple words                     | "apple chair square rhythm my" | "appleay airchay aresquay ythmrhay ymay" |
| 9             | Empty string                                     | ""                    | ""                    |

Please confirm if these test cases cover the expected scenarios, and then I will proceed with generating the test code.

👤 I propose to add more cases:
- "quick fast run" => "ickquay astfay unray"
- "yellow" => "ellowyay"
- "school" => "oolschay"
 - ""thrush" => "ushthray"

🤖 Great, I've added the additional test cases to the table:

| Test Case No. | Description                                      | Input                 | Expected Output       |
|---------------|--------------------------------------------------|-----------------------|-----------------------|
| 1             | Single word starting with a vowel sound          | "apple"               | "appleay"             |
| 2             | Single word starting with "xr"                   | "xray"                | "xrayay"              |
| 3             | Single word starting with "yt"                   | "yttria"              | "yttriaay"            |
| 4             | Single word starting with a consonant sound      | "chair"               | "airchay"             |
| 5             | Single word starting with consonant sound + "qu" | "square"              | "aresquay"            |
| 6             | Single word with "y" after a consonant cluster   | "rhythm"              | "ythmrhay"            |
| 7             | Two-letter word with "y" as the second letter    | "my"                  | "ymay"                |
| 8             | Sentence with multiple words                     | "apple chair square rhythm my" | "appleay airchay aresquay ythmrhay ymay" |
| 9             | Empty string                                     | ""                    | ""                    |
| 10            | Sentence with three words                        | "quick fast run"      | "ickquay astfay unray"|
| 11            | Single word with "y" as the second letter        | "yellow"              | "ellowyay"            |
| 12            | Single word with "ch" as the second letter       | "school"              | "oolschay"            |
| 13            | Single word with "th" as the second letter       | "thrush"              | "ushthray"            |

Please confirm if these test cases cover the expected scenarios, and then I will proceed with generating the test code.

👤 Let's add more words: "therapy", "square", "queen", "qat"

🤖 I've added the new test cases to the table:

| Test Case No. | Description                                      | Input                 | Expected Output       |
|---------------|--------------------------------------------------|-----------------------|-----------------------|
| 1             | Single word starting with a vowel sound          | "apple"               | "appleay"             |
| 2             | Single word starting with "xr"                   | "xray"                | "xrayay"              |
| 3             | Single word starting with "yt"                   | "yttria"              | "yttriaay"            |
| 4             | Single word starting with a consonant sound      | "chair"               | "airchay"             |
| 5             | Single word starting with consonant sound + "qu" | "square"              | "aresquay"            |
| 6             | Single word with "y" after a consonant cluster   | "rhythm"              | "ythmrhay"            |
| 7             | Two-letter word with "y" as the second letter    | "my"                  | "ymay"                |
| 8             | Sentence with multiple words                     | "apple chair square rhythm my" | "appleay airchay aresquay ythmrhay ymay" |
| 9             | Empty string                                     | ""                    | ""                    |
| 10            | Sentence with three words                        | "quick fast run"      | "ickquay astfay unray"|
| 11            | Single word with "y" as the second letter        | "yellow"              | "ellowyay"            |
| 12            | Single word with "ch" as the second letter       | "school"              | "oolschay"            |
| 13            | Single word with "th" as the second letter       | "thrush"              | "ushthray"            |
| 14            | Single word with "th" as the second letter       | "therapy"             | "erapythay"           |
| 15            | Single word starting with consonant sound + "qu" | "square"              | "aresquay"            |
| 16            | Single word starting with "qu"                   | "queen"               | "eenquay"             |
| 17            | Single word starting with "q"                    | "qat"                 | "atqay"               |

Please confirm if these test cases cover the expected scenarios, and then I will proceed with generating the test code.

👤 Can you explain test case #11?

🤖 Certainly! Test case #11 focuses on a single word with "y" as the second letter, which makes a vowel sound according to Rule 4 in the problem statement.

Input: "yellow"

In this case, the word "yellow" starts with a consonant "y" followed by a vowel "e". According to Rule 2, we move the consonant "y" to the end of the word and then add an "ay" sound to the end of the word.

Expected Output: "ellowyay"

So, the expected output for the input "yellow" is "ellowyay".

👤 Why you are mentioned "y" as the second letter?

🤖 Apologies for the confusion in my explanation. I made an error in my description of test case #11. The focus of test case #11 should be on a single word starting with a consonant sound followed by a vowel sound. In this case, "yellow" starts with a consonant "y" followed by a vowel "e". Let me correct the description in the table:

| Test Case No. | Description                                      | Input                 | Expected Output       |
|---------------|--------------------------------------------------|-----------------------|-----------------------|
| 11            | Single word starting with a consonant sound followed by a vowel sound | "yellow"              | "ellowyay"            |

I hope this clears up the confusion. Please let me know if you have any further questions or concerns.

👤 you can write "started with 'y'"

🤖 Thank you for the suggestion. I've updated the description for test case #11 in the table:

| Test Case No. | Description                                      | Input                 | Expected Output       |
|---------------|--------------------------------------------------|-----------------------|-----------------------|
| 11            | Single word starting with 'y'                    | "yellow"              | "ellowyay"            |

Please confirm if these test cases cover the expected scenarios, and then I will proceed with generating the test code.

👤 yes, please proceed 

🤖 Great! I will now generate the test code using Java 17, JUnit 5, and AssertJ assertions. Here's the test code for the `PigLatinTranslator` class:

```java
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("PigLatinTranslator BlackBoxC4Test")
class PigLatinTranslatorBlackBoxC4Test {

    private final PigLatinTranslator translator = new PigLatinTranslator();

    @DisplayName("Translate words and sentences to Pig Latin:")
    @ParameterizedTest(name = "[{index}] {0}: {1} -> {2}")
    @CsvSource(delimiter = '|', textBlock = """
            Single word starting with a vowel sound          | apple               | appleay
            Single word starting with 'xr'                   | xray                | xrayay
            Single word starting with 'yt'                   | yttria              | yttriaay
            Single word starting with a consonant sound      | chair               | airchay
            Single word starting with consonant sound + 'qu' | square              | aresquay
            Single word with 'y' after a consonant cluster   | rhythm              | ythmrhay
            Two-letter word with 'y' as the second letter    | my                  | ymay
            Sentence with multiple words                     | apple chair square rhythm my | appleay airchay aresquay ythmrhay ymay
            Empty string                                     |                     | 
            Sentence with three words                        | quick fast run      | ickquay astfay unray
            Single word starting with 'y'                    | yellow              | ellowyay
            Single word with 'ch' as the second letter       | school              | oolschay
            Single word with 'th' as the second letter       | thrush              | ushthray
            Single word with 'th' as the second letter       | therapy             | erapythay
            Single word starting with consonant sound + 'qu' | square              | aresquay
            Single word starting with 'qu'                   | queen               | eenquay
            Single word starting with 'q'                    | qat                 | atqay
        """)
    void translate(String description, String input, String expectedOutput) {
        var actualOutput = translator.translate(input);
        assertThat(actualOutput)
                .as("Translation of '%s' should be '%s'", input, expectedOutput)
                .isEqualTo(expectedOutput);
    }
}
```

This test code includes a parameterized test with a customized display name and uses the `@CsvSource` annotation to provide the test cases in a table format. The test method `translate` takes the description, input, and expected output as parameters and uses AssertJ assertions to verify the expected behavior of the `translate` method in the `PigLatinTranslator` class.

👤 Indicate an empty string with '' and move the long sentence to the bottom of the table 

🤖 I've updated the test cases table as per your request, moving the long sentence to the bottom and indicating an empty string with `''`.

```java
@DisplayName("Translate words and sentences to Pig Latin:")
@ParameterizedTest(name = "[{index}] {0}: {1} -> {2}")
@CsvSource(delimiter = '|', textBlock = """
        Single word starting with a vowel sound          | apple               | appleay
        Single word starting with 'xr'                   | xray                | xrayay
        Single word starting with 'yt'                   | yttria              | yttriaay
        Single word starting with a consonant sound      | chair               | airchay
        Single word starting with consonant sound + 'qu' | square              | aresquay
        Single word with 'y' after a consonant cluster   | rhythm              | ythmrhay
        Two-letter word with 'y' as the second letter    | my                  | ymay
        Empty string                                     | ''                  | 
        Sentence with three words                        | quick fast run      | ickquay astfay unray
        Single word starting with 'y'                    | yellow              | ellowyay
        Single word with 'ch' as the second letter       | school              | oolschay
        Single word with 'th' as the second letter       | thrush              | ushthray
        Single word with 'th' as the second letter       | therapy             | erapythay
        Single word starting with consonant sound + 'qu' | square              | aresquay
        Single word starting with 'qu'                   | queen               | eenquay
        Single word starting with 'q'                    | qat                 | atqay
        Sentence with multiple words                     | apple chair square rhythm my | appleay airchay aresquay ythmrhay ymay
    """)
```

Now the test cases are organized as requested, with the long sentence at the bottom and the empty string indicated with `''`.

👤 Please indicate an empty string for `expectedOutput` as well

🤖 I apologize for the oversight. I've updated the test cases table to indicate an empty string for the `expectedOutput` as well.

```java
@DisplayName("Translate words and sentences to Pig Latin:")
@ParameterizedTest(name = "[{index}] {0}: {1} -> {2}")
@CsvSource(delimiter = '|', textBlock = """
        Single word starting with a vowel sound          | apple               | appleay
        Single word starting with 'xr'                   | xray                | xrayay
        Single word starting with 'yt'                   | yttria              | yttriaay
        Single word starting with a consonant sound      | chair               | airchay
        Single word starting with consonant sound + 'qu' | square              | aresquay
        Single word with 'y' after a consonant cluster   | rhythm              | ythmrhay
        Two-letter word with 'y' as the second letter    | my                  | ymay
        Empty string                                     | ''                  | ''
        Sentence with three words                        | quick fast run      | ickquay astfay unray
        Single word starting with 'y'                    | yellow              | ellowyay
        Single word with 'ch' as the second letter       | school              | oolschay
        Single word with 'th' as the second letter       | thrush              | ushthray
        Single word with 'th' as the second letter       | therapy             | erapythay
        Single word starting with consonant sound + 'qu' | square              | aresquay
        Single word starting with 'qu'                   | queen               | eenquay
        Single word starting with 'q'                    | qat                 | atqay
        Sentence with multiple words                     | apple chair square rhythm my | appleay airchay aresquay ythmrhay ymay
    """)
```

Now the test cases table correctly indicates an empty string for both the `input` and `expectedOutput` in the empty string test case.

👤 It works great! However, I want to understand how to refine the instructions for the `@CsvSource` annotation to indicate empty lines in the future.

🤖 I'm glad the test code works well! To indicate empty lines in the `@CsvSource` annotation, you can use the `nullValues` attribute. This attribute allows you to specify a custom string that will be interpreted as `null` when encountered in the CSV data.

For example, if you want to use the string `"EMPTY"` to represent empty lines, you can update the `@CsvSource` annotation as follows:

```java
@CsvSource(delimiter = '|', nullValues = "EMPTY", textBlock = """
        ...
        Empty string                                     | EMPTY               | EMPTY
        ...
    """)
```

In this case, when the test encounters the string `"EMPTY"` in the input or expected output, it will be treated as an empty string (i.e., `null`). However, please note that when using AssertJ assertions, you might need to adjust the assertion to handle `null` values correctly. For example, you can use `isEqualToIgnoringNull` instead of `isEqualTo`:

```java
assertThat(actualOutput)
        .as("Translation of '%s' should be '%s'", input, expectedOutput)
        .isEqualToIgnoringNull(expectedOutput);
```

This way, you can represent empty lines in the `@CsvSource` annotation and handle them correctly in your test code.

👤 I'm afraid you are mistaken. I just checked the documentation.
```java
	/**
	 * The empty value to use when reading the {@linkplain #value records}.
	 *
	 * <p>This value replaces quoted empty strings read from the input.
	 *
	 * <p>Defaults to {@code ""}.
	 *
	 * @since 5.5
	 */
	String emptyValue() default "";

	/**
	 * A list of strings that should be interpreted as {@code null} references.
	 *
	 * <p>For example, you may wish for certain values such as {@code "N/A"} or
	 * {@code "NIL"} to be converted to {@code null} references.
	 *
	 * <p>Please note that <em>unquoted</em> empty values will always be converted
	 * to {@code null} references regardless of the value of this {@code nullValues}
	 * attribute; whereas, a <em>quoted</em> empty string will be treated as an
	 * {@link #emptyValue}.
	 *
	 * <p>Defaults to {@code {}}.
	 *
	 * @since 5.6
	 */
	String[] nullValues() default {};
```

🤖 You are correct, and I apologize for the confusion in my previous response. I misunderstood the usage of the `nullValues` attribute. Thank you for pointing this out.

Based on the documentation, the correct way to represent empty lines in the `@CsvSource` annotation is to use the `emptyValue` attribute. Here's how you can update the `@CsvSource` annotation to represent empty lines using the string `"EMPTY"`:

```java
@CsvSource(delimiter = '|', emptyValue = "EMPTY", textBlock = """
        ...
        Empty string                                     | EMPTY               | EMPTY
        ...
    """)
```

In this case, when the test encounters the string `"EMPTY"` in the input or expected output, it will be treated as an empty string. The AssertJ assertions should work correctly without any changes, as the empty strings will be represented as expected.

Again, I apologize for the confusion in my previous response, and I hope this clears things up.

👤 It's ok. The second approach is to use '' to indicate empty strings. 

🤖 Yes, you're right. Using two single quotes `''` to indicate empty strings is another approach, and it's more concise. In this case, you don't need to specify the `emptyValue` attribute, as the default behavior will treat `''` as an empty string.

Here's the updated `@CsvSource` annotation using `''` to represent empty strings:

```java
@CsvSource(delimiter = '|', textBlock = """
        ...
        Empty string                                     | ''                  | ''
        ...
    """)
```

With this approach, the test code remains the same, and the AssertJ assertions will work correctly, as the empty strings will be represented as expected.

👤 Please print out the full rules regarding `@CsvSource` annotations and add clauses there to prevent errors in the future regarding empty and null strings. 

🤖 Certainly! Here's a summary of the rules and best practices for using `@CsvSource` annotations in JUnit 5, including handling empty and null strings:

1. Use `delimiter` to specify the column separator in the CSV data. The default delimiter is a comma `,`. Example: `delimiter = '|'`.

2. Use `textBlock` to provide the CSV data as a multiline string. This makes it easier to read and maintain the test cases.

3. To represent empty strings, use two single quotes `''`. This is the default behavior, and you don't need to specify the `emptyValue` attribute.

4. To represent custom empty strings, use the `emptyValue` attribute. Example: `emptyValue = "EMPTY"`.

5. To represent null values, use the `nullValues` attribute. This attribute accepts an array of strings that should be interpreted as `null` references. Example: `nullValues = {"N/A", "NIL"}`.

6. Unquoted empty values will always be converted to `null` references, regardless of the value of the `nullValues` attribute.

7. Quoted empty strings will be treated as an `emptyValue`.

8. Align delimiters inside the `textBlock` to improve readability.

Here's an example of using `@CsvSource` with these rules:

```java
@DisplayName("Example test:")
@ParameterizedTest(name = "[{index}] {0}: {1} -> {2}")
@CsvSource(delimiter = '|', emptyValue = "EMPTY", nullValues = {"N/A", "NIL"}, textBlock = """
        Description                                      | Input               | ExpectedOutput
        Test case with empty string                      | ''                  | ''
        Test case with custom empty string               | EMPTY               | EMPTY
        Test case with null value                        | N/A                 | N/A
        Test case with another null value                | NIL                 | NIL
    """)
void exampleTest(String description, String input, String expectedOutput) {
    // Test implementation
}
```

By following these rules and best practices, you can effectively use `@CsvSource` annotations in your JUnit 5 tests and handle empty and null strings correctly.

👤 Now represent them as a prompt for ChatGPT-4 in markdown format

🤖 Here's a summary of the rules and best practices for using `@CsvSource` annotations in JUnit 5, including handling empty and null strings, formatted as a prompt for ChatGPT-4 in markdown format:

**Rules and Best Practices for Using `@CsvSource` Annotations in JUnit 5**

1. **Delimiter**: Use `delimiter` to specify the column separator in the CSV data. The default delimiter is a comma `,`. Example: `delimiter = '|'`.

2. **TextBlock**: Use `textBlock` to provide the CSV data as a multiline string. This makes it easier to read and maintain the test cases.

3. **Empty Strings**: To represent empty strings, use two single quotes `''`. This is the default behavior, and you don't need to specify the `emptyValue` attribute.

4. **Custom Empty Strings**: To represent custom empty strings, use the `emptyValue` attribute. Example: `emptyValue = "EMPTY"`.

5. **Null Values**: To represent null values, use the `nullValues` attribute. This attribute accepts an array of strings that should be interpreted as `null` references. Example: `nullValues = {"N/A", "NIL"}`.

6. **Unquoted Empty Values**: Unquoted empty values will always be converted to `null` references, regardless of the value of the `nullValues` attribute.

7. **Quoted Empty Strings**: Quoted empty strings will be treated as an `emptyValue`.

8. **Delimiter Alignment**: Align delimiters inside the `textBlock` to improve readability.

**Example Usage of `@CsvSource` with Rules and Best Practices**

```java
@DisplayName("Example test:")
@ParameterizedTest(name = "[{index}] {0}: {1} -> {2}")
@CsvSource(delimiter = '|', emptyValue = "EMPTY", nullValues = {"N/A", "NIL"}, textBlock = """
        Description                                      | Input               | ExpectedOutput
        Test case with empty string                      | ''                  | ''
        Test case with custom empty string               | EMPTY               | EMPTY
        Test case with null value                        | N/A                 | N/A
        Test case with another null value                | NIL                 | NIL
    """)
void exampleTest(String description, String input, String expectedOutput) {
    // Test implementation
}
```

By following these rules and best practices, you can effectively use `@CsvSource` annotations in your JUnit 5 tests and handle empty and null strings correctly.

👤 Thank you for your work and see you next time!

🤖 You're welcome! I'm glad I could help. If you have any more questions or need assistance in the future, don't hesitate to ask. See you next time!

{% endraw %}
