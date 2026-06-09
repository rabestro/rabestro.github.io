---
title: "Optimizing a Scala 3 FEN Parser"
date: 2026-06-09 12:00:00 +0300
author: rabestro
categories: [ Scala 3, Chess Engine, Performance ]
tags:
  [
    scala,
    performance,
    jmh,
    refactoring,
    code-quality,
  ]
pin: false
toc: true
comments: true
published: false
description: "How evolving an MVP chess FEN parser into a robust, validating library component improved both code quality and execution speed using Scala 3 boundaries."
---

When building the MVP for our Dice Chess engine, the primary goal was getting something that worked so we could start
testing our models. The `FenParser` did its job, but it was written fast. A prime example was the snippet responsible
for parsing castling rights:

```scala
val castling = parts(2)
var castlingInt = 0
if castling.contains('K') then castlingInt |= 1
if castling.contains('Q') then castlingInt |= 2
if castling.contains('k') then castlingInt |= 4
if castling.contains('q') then castlingInt |= 8
```

While functional, it had significant flaws for a high-quality library:

1. **No Validation**: It silently ignored invalid characters and duplicate fields. `"KxQ"` would parse as valid. `"K-q"`
   would parse identically.
2. **Sub-optimal Performance**: The `contains` method scans the string from the beginning every time. For a 4-character
   string (`"KQkq"`), we were scanning the string four times.
3. **Cognitive Load**: This logic was buried inside a massive `parse` function, making the method harder to read.

### The Refactoring: Parse, Don't Validate

Our goal was to rewrite this into a robust library component. We wanted strict validation (fail fast on bad input)
*without* sacrificing performance.

In Scala 3, we can leverage two powerful tools: `inline` methods and the new `boundary / break` control flow for
non-local returns. Here is the refactored result:

```scala
/** Parses the castling FEN string to an integer bitmask.
  * Uses a single pass `foreach` which is highly optimized in Scala 3.
  * Directly breaks the enclosing boundary on invalid characters.
  */
private inline def parseCastling(castling: String)(using boundary.Label[Either[String, GameState]]): Int = {
  val len = castling.length
  if len < 1 || len > 4 then break(Left(s"Invalid castling field length: $len"))

  if castling == "-" then 0
  else {
    var castlingInt = 0
    castling.foreach { c =>
      val bit = c match {
        case 'K' => 1
        case 'Q' => 2
        case 'k' => 4
        case 'q' => 8
        case _   => break(Left(s"Invalid castling character '$c'")) // '-' and invalid characters fail here
      }
      if (castlingInt & bit) != 0 then break(Left(s"Duplicate castling character '$c'"))
      castlingInt |= bit
    }
    castlingInt
  }
}
```

Notice the elegance here:

* We check the length explicitly.
* We handle the empty `-` state upfront.
* We use a **single-pass** `foreach` loop with pattern matching to resolve the character bit.
* We strictly validate against duplicate characters using a bitwise AND `(castlingInt & bit) != 0`.
* If we encounter any invalid or duplicate character, we call `break(...)` to immediately abort the entire FEN parsing process and return a `Left(error)` to the user.

Because the function is `inline` and the target `boundary` is statically known, the Scala 3 compiler optimizes the `break` control flow into a direct local jump (similar to a `goto` statement) rather than actually throwing and catching an exception. We achieve the safety of `Either` without the overhead of `Left` / `Right` allocations on the happy path, and without the performance penalty of exception handling on the failure path!

### The Proof is in the JMH Benchmarks

It's common to assume that adding validation and error handling slows down code. We ran JMH (Java Microbenchmark
Harness) to compare our naive `contains` MVP against our new, strictly-validating `boundary/break` approach.

Here are the results (average time in nanoseconds per operation, lower is better):

| FEN Castling String | MVP (`contains`) | New (`inline` + validation) |
| :--- | :--- | :--- |
| **`-`** (None) | 5.03 ns | **3.36 ns** |
| **`KQ`** (White only) | 6.89 ns | **4.08 ns** |
| **`kq`** (Black only) | 6.01 ns | **4.29 ns** |
| **`KQkq`** (All rights) | **8.19 ns** | 10.46 ns |

### Conclusion

For shorter strings and the empty `-` case (which are extremely common), the new single-pass approach is significantly faster because it bypasses multiple string scans and exits early. 

Only on the full 4-character string (`"KQkq"`) does the MVP slightly pull ahead (by ~2.2 nanoseconds), mostly because 4 loops of a highly-validated `foreach` (including bitwise duplicate detection) is slightly more verbose to the JVM than 4 optimized `indexOf` checks. 

However, the real victory is structural. We took a block of code with zero error handling, extracted it into a clean
helper, added strict bounds checking, precise invalid character rejection, and seamlessly integrated it into our
`Either` flow—and we did it while making the average parsing case *faster*.

This is the power of "Parse, Don't Validate" combined with Scala 3's modern control structures!
