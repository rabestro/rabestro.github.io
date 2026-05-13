---
title: "Zero-Cost Domain Modeling in Scala 3: From Heavy Heap to Packed Primitives"
date: 2026-05-13 19:30:00 +0300
categories: [Scala, Performance]
tags: [scala3, architecture, optimization, domain-driven-design, performance, zero-cost-abstractions]
mermaid: false
---

I am currently building a high-performance Scala 3 search engine for a variation of chess called **Dice Chess**. 

When writing an engine that needs to traverse millions (or billions) of game states using Expectimax or Alpha-Beta search, **object allocation is the ultimate enemy**. Every single byte allocated on the heap during hot loops creates garbage collector (GC) pressure, induces CPU cache misses due to pointer chasing, and robs the engine of speed.

For my core domain—representing things like `Color`, `Piece`, `Square`, and `Move`—I wanted the best of both worlds: **type-safe, readable domain code** during development, and **absolute zero overhead** at runtime. 

In this article, I will walk through how my AI pair-programmer and I refactored our core models from traditional heap-allocated structures to **Scala 3 Opaque Types** and bitwise packed primitives. Along the way, we ran into three fascinating compiler restrictions that forced us to deepen our understanding of Scala 3's internal mechanics.

Here is our real-world battle report.

---

## The Problem with Classic Models

In standard Scala (or Java), representing a chess square or a piece is typically done using `case class`es, `enum`s, or `sealed trait`s:

```scala
// The Standard Approach (Scala 2 Style)
case class Piece(color: Color, pieceType: PieceType)
case class Square(file: Char, rank: Int)
```

While this is incredibly expressive, at runtime, every `Piece` and `Square` instance is a full JVM object. An object header alone on a 64-bit JVM consumes 12–16 bytes, plus fields, plus padding. When your board evaluation traverses tree branches 10 plies deep, allocating millions of these objects in a loop will choke your L1/L2 CPU cache.

In Scala 2, we could try using **Value Classes** (`extends AnyVal`). However, Value Classes are notorious for silently **boxing** (allocating on the heap) when passed to generic collections, mapped over `Option`, or used in pattern matching. They are "mostly" zero-cost, which is not good enough for a search engine.

---

## The Scala 3 Savior: Opaque Types

Scala 3 introduces **Opaque Types**. Unlike type aliases (which are transparent), an `opaque type` hides its underlying primitive representation from the outside world, but compiles down *exactly* to that primitive.

At compile-time, it's a strong, distinct type. At runtime, it is just an `Int` or a `Long`. Absolutely zero memory footprint.

Let's look at our base types:

```scala
opaque type Color = Int

object Color:
  val White: Color = 0
  val Black: Color = 1

  extension (color: Color)
    inline def opponent: Color  = color ^ 1 // Bitwise XOR toggle!
    inline def isWhite: Boolean = color == Color.White
```

Outside of the defining package, nobody knows that `Color` is an `Int`. You cannot add numbers to it. But internally, we can perform blazingly fast bitwise operations like `color ^ 1` to instantly toggle from White to Black!

---

## Extreme Optimization: Bitwise Packing

Once we migrated `Color` and `PieceType` to opaque `Int`s, we asked: **Why allocate aggregate objects at all?**

A chess `Piece` consists of a `Color` and a `PieceType` (Pawn, Knight, etc.). We only have 2 colors and 6 piece types. We can pack all of that into a single 4-bit primitive!

```scala
opaque type Piece = Int

object Piece:
  /**
   * Packs both properties into a single 4-bit byte:
   * Bits 0-2: PieceType (1 to 6)
   * Bit 3: Color (0 = White, 1 = Black)
   */
  def apply(color: Color, pieceType: PieceType): Piece =
    (color.value << 3) | pieceType.value

  extension (piece: Piece)
    def color: Color      = (piece >>> 3) & 1
    def pieceType: PieceType = piece & 0x07
```

This is beautiful. The caller uses a natural interface: `myPiece.color` or `myPiece.pieceType`. But the JVM just sees bit-shifting instructions (`>>>`, `&`) on raw integers. The memory footprint of a Piece is now exactly **zero extra bytes** beyond the primitive storage.

We did the exact same thing for a `MicroMove`, packing the origin square (6 bits), target square (6 bits), and promotion type (4 bits) into a highly compact **16-bit integer**: `(promotion << 12) | (target << 6) | origin`.

---

## Battle Royale with the Scala 3 Compiler

This sounds amazing on paper, but when we activated strict compiler warnings (`-Werror`, `-Wunused:all`, `-explain`), the Scala 3 compiler put up a serious fight. Here are the three massive roadblocks we hit and how we solved them.

### Trap 1: Opaque Erasure Collisions

In our first attempt, we wrote top-level extension methods for notation formatting:

```scala
// Inside package dicechess.engine.domain
extension (s: Square) def toNotation: String = ???
extension (mv: MicroMove) def toNotation: String = ???
```

The compiler screamed! Why? Because inside the defining package, both `Square` and `MicroMove` are seen as their underlying type: `Int`. 

To the compiler, we were trying to define two different functions named `toNotation` that both accepted a raw `Int`. This is a direct method overload collision at the JVM bytecode level (Type Erasure)!

**The Fix: Companion Scoping**
By nesting the `extension` blocks directly **inside each companion object**, Scala 3 compiles the extension methods independently into distinct companion binaries (`Square$` and `MicroMove$`). 

```scala
object Square:
  extension (s: Square) 
    def toNotation: String = ...

object MicroMove:
  extension (mv: MicroMove) 
    def toNotation: String = ...
```
This cleanly organizes the API surface and completely bypasses JVM erasure conflicts!

---

### Trap 2: The "Stable Identifier" Conundrum

We initially defined our piece type constants as `inline val`s, thinking that would make them compile-time constants:

```scala
object PieceType:
  inline val Pawn: PieceType = 1 // Compiler Error!
```

The compiler rejected this with a very informative error:
`The type of an inline val cannot be an opaque type. To inline, consider using inline def instead`.

So we dutifully changed them to `inline def`:
```scala
object PieceType:
  inline def Pawn: PieceType = 1
```

This fixed the constant definition, but completely broke our **pattern matching**!
```scala
somePieceType match
  case PieceType.Pawn => "p" // Compiler Error!
```
Error: `Stable identifier required, but PieceType.Pawn found`.

In Scala, you cannot pattern match against a `def` because it's a method call, not a stable value. 

**The Fix: Plain old `val`**
It turns out `inline` was complete overkill here. For simple opaque primitive constants, a standard final `val` is 100% permitted. It satisfies the Stable Identifier requirement for fast pattern matching, and the JIT compiler easily inlines it into an absolute constant at runtime anyway!

```scala
object PieceType:
  val Pawn: PieceType = 1 // Perfect!
```

---

### Trap 3: The Infinite Recursion Detector

Inside `MicroMove.toNotation`, we composed the notation using the `from` and `to` squares:

```scala
// Inside MicroMove companion
extension (mv: MicroMove)
  def toNotation: String =
    s"${mv.from.toNotation}${mv.to.toNotation}"
```

The strict compiler suddenly issued a fascinating warning:
`Warning: Infinite loop in function body`.

Wait, why an infinite loop? 
Because in the local scope of `Models.scala`, both `Square` and `MicroMove` erase to `Int`. So when we called `mv.from.toNotation`, the compiler resolved `toNotation` to the *current* method (`MicroMove.toNotation`) instead of `Square.toNotation`! It was accidentally predicting a runtime StackOverflow before we even ran a single test!

**The Fix: Unambiguous Invocation**
We bypassed the extension method sugar and invoked the companion object's extension explicitly:

```scala
extension (mv: MicroMove)
  def toNotation: String =
    s"${Square.toNotation(mv.from)}${Square.toNotation(mv.to)}"
```
This was unambiguous, 100% safe, and compiled cleanly.

---

## Results & Conclusion

By refactoring our core domain to Opaque Types, we achieved a major architectural win:

1. **Zero Garbage Collector Load:** Generating, verifying, and evaluating chess moves now creates absolutely **zero objects on the heap**. Our CPU cache stays warm, and GC pauses are non-existent.
2. **Complete Type Safety:** Despite being raw integers under the hood, we cannot accidentally pass a `Color` where a `Piece` is expected. The compiler strictly guards our domain boundaries.
3. **Readable Domain API:** Our code still reads like high-level Scala: `piece.color.opponent`. All the bitwise math is neatly tucked away inside companion extensions.

Working at a Scala-first shop like Evolution, I truly appreciate the power of getting maximum performance without sacrificing type safety. Scala 3's Opaque Types deliver exactly that—a rare developer superpower where the abstraction overhead genuinely reaches absolute zero.

Happy coding!
