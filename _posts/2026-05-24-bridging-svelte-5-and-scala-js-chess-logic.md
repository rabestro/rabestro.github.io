---
title: "Bridging Svelte 5 and Scala.js: Architectural Lessons from Dice Chess"
date: 2026-05-24 10:30:00 +0300
categories: [Scala.js, Svelte 5, Architecture]
tags:
  [scala3, svelte, architecture, refactoring, scala-js, dice-chess, frontend]
math: false
mermaid: false
published: false
---

Building a robust chess application involves managing incredibly complex game state. But what happens when your frontend needs to understand the rules of the game just as well as your backend?

A month ago, I started the **Dice Chess Lab** repository—a frontend application built with Svelte 5 intended for game analysis and a trainer mode. At that time, it needed to handle chess moves locally to immediately reflect board updates. Two weeks later, I began building the **Scala 3 Dice Chess Engine**.

Initially, the first piece of shared logic I integrated from the Scala engine into the UI was legal move generation (something the UI lacked entirely). But as the project evolved, my AI pair-programmer and I discovered another massive piece of duplicated logic in the UI that desperately needed to be extracted and replaced with our shared Scala code.

Here is the story of how we unified our game logic across the stack using Scala.js, and a fascinating architectural bug we encountered along the way involving the concept of a "Turn."

---

## The "God Function" Trap in Svelte 5

Because the frontend needed to apply moves to the board without waiting for a server round-trip, a custom JavaScript helper function called `makeFenMove` was born.

It started innocently enough: move a piece from origin to destination and update the FEN (Forsyth-Edwards Notation) string. But chess is never that simple. Soon, the function had to handle:

- Captures
- En Passant target square updates
- Castling rights invalidation (if a King or Rook moves/is captured)
- Pawn promotion
- Halfmove clock resets

Before long, `makeFenMove` grew into a 130-line monster. It was essentially a brittle, bug-prone reimplementation of chess rules trapped inside a Svelte store. We were duplicating domain logic that our Scala 3 engine was already doing perfectly.

---

## Enter Scala.js: The Single Source of Truth

The beauty of Scala 3 is its seamless compilation to JavaScript via **Scala.js**. We decided to rip out the 130-line JS helper and expose the engine's core move execution directly to the frontend.

We created an entry point in the engine using `@JSExportTopLevel`:

```scala
import scala.scalajs.js.annotation.*
import dicechess.engine.domain.*

@JSExportTopLevel("DiceChess")
object JsApi {
  @JSExport
  def applyMove(fen: String, from: String, to: String, promotion: js.UndefOr[String]): js.UndefOr[String] = {
    // ... parse FEN, validate move, apply it, and serialize back to FEN ...
  }
}
```

We published this as an npm package via GitHub Packages (`@rabestro/dicechess-engine`) and imported it into our Svelte app.

The frontend refactoring was glorious. We deleted `makeFenMove` entirely, and our Svelte 5 store now looked like this:

```typescript
const nextBoardFen = DiceChess.applyMove(this.currentBoardFen, orig, dest);
if (!nextBoardFen) {
  logger.error(`Engine rejected move ${orig}-${dest}`);
  return;
}
this.currentBoardFen = nextBoardFen;
```

We reduced 130 lines of spaghetti code into a single, pure function call. The Svelte 5 runes (`$state`) reacted beautifully to the new FEN string, and our tests passed. We merged the PR.

And then, the E2E tests failed.

---

## The Architectural Bug: Turn Boundaries vs. Move Boundaries

When I ran the app locally, the game against the bot was completely broken. In Dice Chess, a player rolls 3 dice and can make up to 3 "micro-moves" in a single turn. But suddenly, the app only allowed me to make exactly **one** micro-move. The engine rejected all subsequent moves.

Why?

It came down to a profound architectural mismatch between how standard chess engines and the Dice Chess frontend define a "Move" versus a "Turn."

In standard chess, the domain rule is absolute: **every applied move immediately flips the active color** to the opponent. Our Scala engine's `makeMove` function faithfully respected this rule.

```scala
// Inside the Scala engine
def makeMove(move: Move): BoardState =
  // ... updates board ...
  val nextColor = if (this.activeColor == Color.White) Color.Black else Color.White
```

However, **in Dice Chess, the active color must remain the same for up to 3 micro-moves!** The turn only ends when the player runs out of dice or valid moves.

When the Svelte frontend called `DiceChess.applyMove(...)` for the first micro-move, the engine returned a FEN string where the active color was flipped to the opponent. When the frontend tried to validate the second micro-move, the engine rejected it—because according to the FEN, it was now the opponent's turn!

### The Fix: Orchestrating State in the UI

We had a choice: modify the pure Scala engine to accept a "keep turn" flag, or patch the FEN state in the frontend.

We chose the latter to keep the engine stateless and standard-compliant. The pure engine evaluates individual moves. The **frontend application**, however, is responsible for orchestrating the concept of a Dice Chess "Turn."

We patched our Svelte store to temporarily preserve the active player's color and the fullmove number after the engine processes a micro-move, only allowing the color to flip when the turn actually concludes:

```typescript
const nextBoardFenRaw = DiceChess.applyMove(
  this.currentBoardFen,
  orig,
  dest,
  promotionStr,
);

if (!nextBoardFenRaw) {
  // Move was invalid or rejected by engine
  return;
}

// Dice Chess: preserve active color & fullmove until the turn explicitly ends.
const rawParts = nextBoardFenRaw.split(" ");
const oldParts = this.currentBoardFen.split(" ");
rawParts[1] = oldParts[1]; // keep original active color
rawParts[5] = oldParts[5]; // keep original fullmove number
const nextBoardFen = rawParts.join(" ");

this.currentBoardFen = nextBoardFen;
```

---

## Conclusion

This migration taught us a vital lesson in domain boundaries.

By leveraging Scala.js, we achieved a **Single Source of Truth** for chess logic. The UI no longer calculates castling invalidations or en passant targets.

However, we also learned that **domain mechanics are contextual**. A "move" to the core chess engine means something entirely different than a "turn" to the Dice Chess orchestrator. By keeping the engine purely focused on move mechanics and allowing the Svelte 5 UI to orchestrate the turn boundaries, we found the perfect architectural balance.

If you are building a complex application with a domain-heavy frontend, consider compiling your backend domain logic to WebAssembly or JavaScript. Just make sure you understand exactly who is responsible for turning the page to the next chapter.
