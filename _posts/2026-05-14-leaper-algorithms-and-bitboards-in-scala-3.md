---
layout: post
title: "Why Kings and Knights Are the Same: Blazing Fast Leaper Attacks in Scala 3"
date: 2026-05-14 10:00:00 +0300
categories: [Scala 3, Chess Engine, Performance]
tags: [scala, bitboards, algorithms, gamedev]
---

Yesterday, I was explaining the architecture of my new Dice Chess Engine to a friend. We were talking about move generation — the core algorithm that determines where a piece can legally move. 

When I mentioned that my engine handles Kings and Knights using the exact same algorithm under the hood, she was puzzled. *"Wait,"* she asked, *"Why do Kings and Knights fall into the same category? A King steps slowly, and a Knight jumps in an L-shape!"*

It’s a great question. In human terms, they move very differently. But in the eyes of a chess engine, they share a fundamental trait that makes them practically identical: **they are Leapers.**

In this post, I want to explain what a "Leaper" is, why this concept is so important, and how we can use Scala 3 to generate their moves with zero-cost, blazing-fast bitwise math.

---

### Sliders vs. Leapers

In chess programming, we divide pieces into two broad categories based on how they reach their destination:

1. **Sliders (Rooks, Bishops, Queens):** These pieces slide along a ray. Their movement is highly dependent on the board state because they can be blocked by other pieces. You have to check every square along the path.
2. **Leapers (Knights and Kings):** These pieces simply "teleport" to their destination. A Knight jumps over everything, and a King only moves one square anyway. For a Leaper, **the path doesn't matter, only the destination.**

Because Leapers are never blocked along a path, the squares they *attack* from any given position are always exactly the same, regardless of what else is on the board. This predictable nature allows us to optimize them heavily.

### Enter the Bitboard

As discussed in my [previous post](/2026/05/13/zero-cost-domain-modeling-with-scala-3-opaque-types.html), our engine represents the chess board using **Bitboards** — simple 64-bit integers (`Long` in Scala) where each bit corresponds to one of the 64 squares. 

If we place a Knight on `b1`, we just flip the 1st bit (since `a1` is 0, `b1` is 1). That's our Bitboard.

Now, how do we calculate where it can jump? We don't use 2D arrays or `for` loops. We use **bitwise shifts**.

Because our 64-bit integer represents a grid, shifting bits to the left or right physically moves the piece on the board:
- Shifting `<< 8` moves the piece **Up** one rank (North).
- Shifting `>>> 8` moves the piece **Down** one rank (South).
- Shifting `<< 1` moves the piece **Right** one file (East).

To make a Knight jump "North-North-East" (up two squares, right one square), we shift by `8 + 8 + 1 = 17`.
So, `Bitboard << 17` instantly gives us the target square!

### The Wrap-Around Bug

There is one critical trap in this bitwise wonderland. The board is not a cylinder. 

If a Knight is on the `h` file (the rightmost edge) and we shift it `<< 1` to move East, it doesn't fall off the board. Instead, because it's just a sequence of bits, it wraps around to the `a` file on the *next rank up*. 

To prevent our Knights from magically teleporting across the board, we use **File Masks**. Before we shift East, we simply use a bitwise `AND` to erase any pieces that are already on the `h` file.

```scala
private val NotHFile: Bitboard = Bitboard(0x7f7f7f7f7f7f7f7fL)

// Safe East shift:
val east = (bitboard & NotHFile) << 1
```

### The Scala 3 Implementation

With these concepts, generating every possible attack for a Knight requires just a few lines of bitwise math. Here is the actual code from my engine:

```scala
private def computeKnightAttacks(sqIndex: Int): Bitboard =
  val b   = Bitboard.fromSquare(Square.fromIndex(sqIndex))
  
  val nne = (b & NotHFile) << 17  // North-North-East
  val nnw = (b & NotAFile) << 15  // North-North-West
  val ene = (b & NotGHFile) << 10 // East-North-East
  val wnw = (b & NotABFile) << 6  // West-North-West
  
  val ese = (b & NotGHFile) >>> 6 // East-South-East
  val wsw = (b & NotABFile) >>> 10// West-South-West
  val sse = (b & NotHFile) >>> 15 // South-South-East
  val ssw = (b & NotAFile) >>> 17 // South-South-West

  // Combine all possible targets into a single Bitboard
  nne | nnw | ene | wnw | ese | wsw | sse | ssw
```

For the King, the algorithm is exactly the same, just with different shift values (e.g., `<< 8` for North, `<< 9` for North-East).

### The Ultimate Optimization: Precomputation

The `computeKnightAttacks` function is fast, but it still performs about 25 bitwise operations. In the hot loop of an AI search tree, evaluating millions of positions per second, even 25 operations is too slow.

Here is where the magic of the "Leaper" property shines. Because these attacks *never change based on other pieces*, **we don't need to calculate them during the game.**

We calculate them exactly *once* when the JVM starts, and store the results in an array. Scala makes this beautiful with `Array.tabulate`:

```scala
object LeaperAttacks:
  /** Precalculated arrays for all 64 squares */
  val knightAttacks: Array[Bitboard] = Array.tabulate(64)(computeKnightAttacks)
  val kingAttacks:   Array[Bitboard] = Array.tabulate(64)(computeKingAttacks)

  /** Fetching an attack takes O(1) time */
  inline def knightAttacksFor(sq: Square): Bitboard = knightAttacks(Square.index(sq))
```

Now, when the engine needs to know where a Knight on `e4` can move, it doesn't do any math. It simply looks at index `28` in the array. It's an $O(1)$ memory lookup. 

### Conclusion

By treating Kings and Knights simply as "Leapers," we can mathematically generalize their movement. Combining this conceptual generalization with the raw power of Bitboards and Scala 3's clean syntax allows us to build an engine that is both highly readable and brutally fast.

In the next post, I'll talk about the real challenge: how to generate moves for "Sliders" in $O(1)$ time using something called *Magic Bitboards*. Stay tuned!
