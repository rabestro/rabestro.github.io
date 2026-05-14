---
layout: post
title: "O(1) Sliding Attacks in Chess: The Magic Bitboard Illusion in Scala 3"
date: 2026-05-14 10:30:00 +0300
categories: [Scala 3, Chess Engine, Performance]
tags: [scala3, bitboards, algorithms, gamedev, chess-engine, optimization, hashing]
math: true
---

In my [previous post]({% post_url 2026-05-14-leaper-algorithms-and-bitboards-in-scala-3 %}), we explored how to generate moves for "Leapers" (Kings and Knights) using fast bitwise shifts. Because Leapers ignore other pieces, we could precalculate all their moves at startup. 

But what about **Sliders** — Rooks, Bishops, and Queens?

Sliders move along rays (ranks, files, and diagonals), and their movement is stopped by other pieces. This means a Rook's legal moves depend entirely on the current state of the board.

In this post, we’ll explore how to avoid slow, iterative loops and instead generate sliding attacks instantly in $O(1)$ time using a technique known as **Magic Bitboards**.

---

### The 16-Exabyte Problem

The traditional way to find a Rook's moves is **Raycasting**: start at the Rook, look one square North. If it's empty, add it to legal moves. If it's occupied, add it (capture) and stop. Repeat for all four directions.

This involves `while` loops and `if` branches. In the microscopic world of a chess engine evaluating millions of positions per second, loops are too slow.

We want a **Lookup Table**. Ideally, we just ask an array:
`Attacks = LookupTable[Square][Occupancy]`

The problem? `Occupancy` is a 64-bit integer. An array with $2^{64}$ entries would require **16 Exabytes of RAM**. We need a way to compress this 64-bit state into a tiny number.

### Step 1: Irrelevant Geometry (Masking)

The first realization is that a sliding piece doesn't care about the whole board. A Rook on `a1` doesn't care if there's a Pawn on `h8`. It only cares about the `a` file and the `1` rank.

The second, more subtle realization: **it doesn't care about the edges of the board.**
If a Rook is on `a1` looking East towards `h1`, it will stop at `h1` regardless of whether `h1` is empty or occupied. Therefore, we don't need to know the state of `h1` to generate the attack ray.

By "masking" out the irrelevant squares and the edges, we reduce the "Relevant Occupancy" drastically. For a Rook, the absolute worst-case square has only **12 relevant bits**. For a Bishop, it's **9**.

Instead of $2^{64}$ possibilities, we now only have to deal with $2^{12} = 4096$ possibilities for a Rook!

### Step 2: The Magic Trick (Perfect Hashing)

We now have a 64-bit number, but we know that at most 12 specific bits might be set to `1`. The rest are guaranteed to be `0`. 

We need to map these 4096 possible scattered bit patterns to a dense array index from `0` to `4095`.

Enter the **Magic Number**.

If we multiply our 64-bit Relevant Occupancy by a carefully chosen 64-bit Magic Number, the mathematics of binary multiplication will shift those 12 scattered bits, collide them, and push them to the very top (the most significant bits) of the resulting 64-bit integer.

We then simply shift those bits back down to the bottom to get our index!

```scala
val index = (RelevantOccupancy * MagicNumber) >>> (64 - 12)
```

Finding these Magic Numbers is the tricky part. There is no mathematical formula to derive them; they are found via brute-force scripts that try random 64-bit numbers until they find one that maps all 4096 patterns to 4096 unique slots without a single collision. 

### The Scala 3 Implementation

When the engine boots up, it spends a few milliseconds using the slow raycasting algorithm to populate the `RookTable` and `BishopTable` for every square and every possible relevant occupancy.

During the actual game search, the code to find a sliding attack is astonishingly elegant and fast. Here is the actual implementation from my Dice Chess Engine:

```scala
/** Returns rook attacks given a square and board occupancy. */
def rookAttacks(sq: Square, occupancy: Bitboard): Bitboard =
  val i     = sq.index
  val occ   = occupancy & RookMasks(i) // 1. Mask the board
  
  // 2. The Magic Hash!
  val index = ((occ.value * RookMagics(i)) >>> (64 - RookRelevantBits(i))).toInt
  
  // 3. O(1) Array Lookup
  RookTable(RookOffsets(i) + index)
```

(For a Queen, we simply do a bitwise `OR` between the Rook and Bishop attacks: `rookAttacks(sq, occ) | bishopAttacks(sq, occ)`).

### Conclusion

Magic Bitboards are a perfect example of trading memory for extreme speed. By accepting a ~100KB lookup table and spending time precalculating moves at startup, we completely eliminate loops and branches from sliding piece move generation.

Combined with Scala 3's `opaque type` features and clean syntax, we achieve C-level performance while maintaining highly readable code. The engine is now capable of generating all legal moves in a fraction of a microsecond!
