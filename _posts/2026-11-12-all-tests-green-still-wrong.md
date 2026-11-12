---
layout: post
title: "All Tests Green, Still Wrong: One Forth Bug in Three Languages"
date: 2026-11-12 12:00:00 +0200
categories: [Exercism, Scala 3]
tags: [exercism, forth, scala3, java, awk, mentoring, interpreters]
published: true
description: "My Forth evaluator passed all 46 tests and was still wrong. A mentor found the bug, I found the same one in my AWK solution, and my Java solution turned out to be right by accident. One exercise, three languages, and what a dictionary should store."
---

I maintain the Scala track on [Exercism](https://exercism.org). Recently I solved one of its exercises, [Forth](https://exercism.org/exercises/forth), watched all 46 tests pass, and asked a mentor to review it anyway.

The mentor replied with a three-line program:

```text
: sum + ;
: + * ;
2 3 sum
```

My evaluator answered `6`. The right answer is `5`.

This post is about that bug: why no test caught it, why the same bug was sitting in my AWK solution to the same exercise, and why my Java solution never had it — for a reason that had nothing to do with being careful.

## Why a maintainer asks for a review

I think of myself as a permanent student. I mentor on Exercism in several languages, and I still submit my own solutions for mentoring, including on the track I maintain. Not to find holes in the tests. I do it because another experienced engineer will often show me a cleaner way to say the same thing, and that is how I get better at Scala.

It is also the main reason I spend so much time on the platform. Mentors there are volunteers from all over the world, and some of them have been building software for twenty years or more. Where else can you get your code read by someone like that, for free, just by asking?

So I expected the usual: a suggestion or two about style. I got those. And above them, a bug.

## Forth in one minute

Forth is a stack language. Numbers go onto a stack; words take values off it and put results back:

```text
2 3 +       →  5
1 dup       →  1 1
1 2 swap    →  2 1
```

The exercise asks for four arithmetic operators, four stack words (`dup`, `drop`, `swap`, `over`), and one more feature, the one that makes it interesting. You can define your own words:

```text
: double dup + ;
4 double    →  8
```

Everything between the name and the semicolon is the body. Any word can be redefined, including the built-in ones: `: + * ;` is legal, and from then on `+` multiplies.

Which raises the question this whole post hangs on. If `sum` was defined using `+`, and `+` is redefined later, what does `sum` do? In Forth the answer is fixed: a definition captures what its words mean at the moment it is defined. `sum` keeps adding.

## The bug

My evaluator kept user-defined words in a map from a name to a list of tokens. When a new word was defined, I expanded its body first:

```scala
val expandedBody = body.flatMap(token => state.words.getOrElse(token, List(token)))
```

Read it as: if the token is a word the user defined, replace it with that word's body; otherwise, keep the token as it is. For user-defined words this is correct, and the test suite has a case that proves it:

```text
: foo 5 ;
: bar foo ;
: foo 6 ;
bar foo
```

The result is `5 6`: `bar` was defined while `foo` still meant 5, and it stays that way.

The catch hides in "otherwise, keep the token". `+` was not in the map. Built-in words lived in a `match` expression further down, so the body of `sum` was stored as the string `"+"` — a name, not a meaning. By the time `sum` ran and looked that name up, `+` meant multiplication.

The mentor's second example was shorter and worse:

```text
: dup dup ;
1 dup
```

The body is stored as `"dup"`. Calling `dup` finds the user-defined word and replaces it with its body, which is `dup`, which is a user-defined word. I had marked the evaluation loop `@tailrec` to keep it stack-safe, so this did not even crash. The compiler had politely turned my stack overflow into a program that runs forever.

Forty-six tests, and not one of them uses a built-in word inside a definition and then redefines that built-in. I checked the shared test data that every Exercism track draws from. The case is not there either.

That could have been the end of it: fix one line, thank the mentor. Except that I had solved this exercise twice before.

## I had solved this before. Twice.

Exercism offers the same exercise on many tracks, and this was my third Forth. I had solved it in AWK four years ago and in Java a year after that. So I ran the mentor's two programs against the old solutions.

AWK first. It printed `6`, then hung on the second program. I opened the file and found this:

```awk
for (i = 3; i < NF; ++i) if ($i in Macro) $i = Macro[$i]
```

Put it next to the Scala line:

```scala
body.flatMap(token => state.words.getOrElse(token, List(token)))
```

Two languages with almost nothing in common, and the same sentence in both: if it is a user-defined word, expand it; otherwise, leave the name alone. I had written the same bug twice, four years apart.

Then Java. `5`. And `1 1`. Correct on both.

Wrong in AWK, right in Java, wrong again in Scala. I had the correct solution in the middle and still wrote the bug a second time.

I would like to say that Java was the one time I thought it through. It wasn't. Here is how that solution compiled a definition:

```java
private Consumer<Deque<Integer>> compile(List<String> tokens) {
    return tokens.stream().map(this::parseToken).reduce(Consumer::andThen).orElseThrow();
}
```

Each token is looked up in the dictionary and turned into a function. `reduce` glues those functions into one, and the dictionary stores the result. I wrote it this way because composing lambdas with `reduce` looked neat.

But look at what it does to our problem. By the time a definition is stored, there are no names left in it. `sum` does not hold the word `+`. It holds the function that `+` pointed to on that day. Redefining `+` puts a new function into the dictionary, and the old one stays exactly where `sum` left it.

So the three solutions differ in one thing only:

| Solution | What the dictionary stores | When names are resolved |
| -------- | -------------------------- | ----------------------- |
| AWK      | text                       | when the word is called |
| Scala    | a list of tokens           | when the word is called |
| Java     | a function                 | when the word is defined |

The bug was never about the language. It was about what I chose to put in the dictionary. Store names, and you have to remember to resolve them. Store values, and there is nothing left to forget.

## Scala 3: storing meanings instead of names

The mentor suggested two ways out: resolve every word before storing a definition, or keep a copy of the dictionary as it was at that moment. I took the first, and it turned out to be mostly a question of types.

A word is one of three things:

```scala
enum Word:
  case Num(n: Int)
  case Builtin(run: Stack => Either[ForthError, Stack])
  case User(body: List[Word])
```

The dictionary becomes a `Map[String, Word]`, and the built-ins sit in it from the start, next to whatever the user defines. That alone removes the special case behind the bug: there is no longer a "known word" and an "otherwise". Defining a word means looking up each token of its body right now and storing what comes back:

```scala
for
  (definition, remaining) <- parseDefinition(rest)
  body                    <- resolveAll(definition.body, dictionary)
yield (remaining, dictionary + (definition.name -> Word.User(body)))
```

After that, `sum` holds `Builtin(add)`, not `"+"`.

Running words is a small tail-recursive loop:

```scala
@tailrec
private def run(words: List[Word], stack: Stack): Either[ForthError, Stack] =
  words match
    case Nil                      => Right(stack)
    case Word.Num(n) :: rest      => run(rest, n :: stack)
    case Word.User(body) :: rest  => run(body ++ rest, stack)
    case Word.Builtin(op) :: rest =>
      op(stack) match
        case Right(next) => run(rest, next)
        case Left(err)   => Left(err)
```

Two details are worth a closer look.

The last case matches on the result by hand instead of calling `flatMap`. That is deliberate. A call inside a lambda is not in tail position, so with `flatMap` the compiler would reject `@tailrec`, and without `@tailrec` a long program could overflow the stack.

The second detail I found by accident. My old version copied the body of every word it expanded. Define a word that uses the previous one twice, repeat that 26 times, and the last body is 2²⁶ tokens long. The old evaluator ran out of memory on that program before a single word was called. `User(body)` holds references to the words it uses, so a definition now costs as much as it is long.

## Java: a word is a function

The Java solution was right from the start, so there was no bug to fix. A review for this post still turned up five tiny classes that wanted to be one, and a parser that accepted `: foo 1 2` without the closing semicolon and quietly defined `foo` as `1`. I cleaned those up. The idea stayed.

The idea is that a word is a function over the stack, and a definition is a composition of such functions:

```java
@FunctionalInterface
public interface ForthWord extends Consumer<Deque<Integer>> {
    ForthWord NO_OP = stack -> { };

    static ForthWord number(int value) {
        return stack -> stack.push(value);
    }

    default ForthWord then(ForthWord next) {
        return stack -> {
            accept(stack);
            next.accept(stack);
        };
    }
}
```

Why my own `then`, when `Consumer` already has `andThen`? Because `andThen` returns a plain `Consumer`. In the original version that forced the dictionary to be a `Map<String, Consumer<Deque<Integer>>>`, and my own interface was never used as a type. With `then`, a composition of words is a word.

Built-ins are entries in a map, written as lambdas and method references:

```java
private static final Map<String, ForthWord> WORDS = Map.of(
        "+", binary("Addition", Integer::sum),
        "-", binary("Subtraction", (a, b) -> a - b),
        // "*" and "/" go here
        "dup", BuiltIns::dup,
        "drop", BuiltIns::drop,
        "swap", BuiltIns::swap,
        "over", BuiltIns::over);
```

Each evaluator starts with a copy of that map and adds user definitions to it. Compiling a definition is one expression:

```java
private ForthWord compile(List<String> tokens) {
    return tokens.stream()
            .map(this::parseToken)
            .reduce(ForthWord::then)
            .orElse(ForthWord.NO_OP);
}
```

`parseToken` looks each token up now. `reduce` folds the results into a single `ForthWord`. Nothing is left to resolve later.

This has a price. Every `then` wraps two words in a new lambda, so a line of N tokens becomes a chain N calls deep. On my machine a single line of 20,000 tokens runs fine, and one of 200,000 ends in a `StackOverflowError`. A plain loop over a list would have no such limit. I kept `reduce` anyway: the limit applies to one line, not to the whole program, and I like code that treats functions as values you can fold like numbers.

It is worth comparing with Scala. The Scala version stores a description of the work, `User(body)`, and a loop that reads it. The Java version stores the work itself. The first is stack-safe. The second is one expression long.

## AWK: the same fix with nothing but strings

I met AWK on a project at EPAM, where I had to chew through a large pile of text files — logs, as far as I remember. I found a short course, expected a tool, and found a language: tiny, carefully thought out, and built on an idea that was new to me. Java is object-oriented first. Scala is mostly functional. AWK is data-driven. You don't write a program that reads input. You write rules of the form _pattern { action }_, and AWK runs the input past them, line by line. I liked it enough to give a talk about it at one of EPAM's internal learning events, streamed to the company and recorded.

It is also almost fifty years old. Aho, Weinberger and Kernighan wrote it at Bell Labs in 1977, a decade before Perl, which borrowed from it openly. Some of its notation shows up in unexpected places. In AWK, `$0` is the whole line and `$1` is its first field. If you have ever written `$1` in a regex replacement in Java or Scala, you have seen the family resemblance.

Here is the whole control flow of my Forth evaluator, written in GNU AWK:

```awk
$1 == ":" {
    # ...checks...
    Macro[$2] = resolve(3, NF - 1)
    next
}
{
    $0 = resolve(1, NF)
    for (i = 1; i <= NF; ++i) execute($i)
}
```

A line that starts with a colon is a definition. Any other line is a program. That's it.

Now the problem. AWK has no closures to capture a function, and no algebraic types to describe one. It has strings, numbers and associative arrays. My old solution stored the body of a word as text, and text is nothing but names.

The fix keeps the text and changes the vocabulary. Every built-in gets a private name: `+` becomes `@+`, `dup` becomes `@dup`. One function translates words into what they mean right now:

```awk
function resolve(first, last,   i, resolved) {
    for (i = first; i <= last; ++i) {
        if ($i ~ Number) resolved = resolved " " $i
        else if ($i in Macro) resolved = resolved " " Macro[$i]
        else if ($i in BuiltIn) resolved = resolved " " BuiltIn[$i]
        else die("undefined operation")
    }
    return resolved
}
```

Define `: sum + ;` and the stored body is `@+`. Redefine `+` as often as you like: `@+` still means addition, because the public name is no longer in there. It is the same idea as in Java and Scala — store the meaning, not the name — done by renaming, which is what a text-processing language does best.

Two idioms in this code are worth a look. The first is `$0 = resolve(1, NF)`. Assigning to `$0` replaces the current line, and AWK splits it into fields again, so the translated program simply becomes the input. The second is how the stack gets printed:

```awk
ENDFILE {
    NF = Size
    while (Size) {
        $Size = Stack[Size]
        --Size
    }
    print
}
```

Set the number of fields to the size of the stack, fill the fields, and `print` joins them with spaces.

One confession before I leave AWK. While fixing the binding bug I found a second one, and it is funnier. The old code recognised built-ins with the regular expression `/[-+*]|[/]|swap|over/`, with no anchors. So `1 2 overflow` was accepted: `overflow` contains `over`. The program took two numbers off the stack, found no operation to perform, and printed an empty stack with exit status 0. The only undefined word in the tests is `foo`.

## What the tests could not tell me

All three solutions passed their test suites on the day I submitted them. Two of them were wrong, and the third was right for a reason I had not noticed.

I don't hold that against the tests. They are not mine: on Exercism the tests come with the exercise, and students run them rather than write them. They are also shared. The same cases are used by every language track, so they can only ask for what every language can deliver. One language has big integers and another does not; a check that is trivial in one can be impossible in the other. A suite like that has to stop somewhere.

Which means the rest is my job. The question was sitting right there — what happens to `sum` when `+` changes? — and I could have asked it myself: tried three lines in a real Forth, or asked on the forum. I didn't, because the checkmark was green.

That is what I really go to mentors for. Not the fix, but the habit: to keep asking questions after the tests have stopped.

## Takeaways

1. **What you store decides when names are resolved.** Store names, and binding happens late whether you meant it or not. Store values — functions in Java, an `enum` in Scala, renamed tokens in AWK — and it happens at definition, with nothing left to remember.
2. **A correct solution can be an accident.** My Java code was right because of a design I picked for its looks. I learned nothing from it, and proved that by writing the same bug again three years later.
3. **Ask someone to read your code, especially when the tests are green.** Mentors on Exercism do this for free, and mine found what four years of passing tests had not.

Thank you to the mentor who caught what the tests let through.

The full code of all three solutions is in my [Exercism solutions repository](https://github.com/rabestro/exercism-solutions-sync): [Scala](https://github.com/rabestro/exercism-solutions-sync/tree/main/solutions/scala/forth), [Java](https://github.com/rabestro/exercism-solutions-sync/tree/main/solutions/java/forth), and [AWK](https://github.com/rabestro/exercism-solutions-sync/tree/main/solutions/awk/forth).
