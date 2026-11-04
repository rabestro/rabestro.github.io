---
title: "Upgrading to Scala 3.10: The Version Bump Was the Easy Part"
date: 2026-11-04 13:00:00 +0200
author: rabestro
categories: [Scala 3, Chess Engine, Performance]
tags: [scala3, sbt, mima, scoverage, jmh, migration]
description: "A Scala 3.8.4 to 3.10.0 migration: hidden compiler pins, precise MiMa filters, an inline coverage limit, and JMH results with an unresolved 5% margin."
toc: true
mermaid: false
---

My `build.sbt` already said Scala 3.10.0. The main engine modules were still compiling with 3.8.4.

That was the first surprise while upgrading our [Dice Chess engine][engine]. The next two came from binary
compatibility checks and coverage instrumentation. Then we had to answer the question that matters for a search
engine: did any of the fixes make it slower?

Here is what we changed, what our checks caught, and what the measurements actually let us conclude.
Choose your publishing baseline deliberately: the [release notes][release] recommend Scala 3.9 LTS for
libraries needing the longest support window.

## One build, two Scala versions

The build had two independent declarations, in different parts of the file:

```scala
ThisBuild / scalaVersion := "3.10.0"

val ScalaV = "3.8.4"
```

Our `sbt-projectmatrix` rows explicitly used `scalaVersions = Seq(ScalaV)`. Those rows, and API documentation,
kept the old compiler; ordinary subprojects inherited the new global setting. Reading the first declaration was
enough to believe the migration had already happened.

The fix was one shared value:

```scala
val ScalaV = "3.10.0"

ThisBuild / scalaVersion := ScalaV
// Matrix rows also use scalaVersions = Seq(ScalaV).
```

We checked the effective versions across the projects and updated coverage-report paths containing the old
version. A compiler pin has consumers beyond compilation.

## Forty-seven MiMa reports deserve a closer look

Our rules library checks compatibility against its previous release with MiMa. After the upgrade it reported
47 `IncompatibleSignatureProblem`s. We already had MiMa 1.2.1, the minimum recommended by the
[Scala 3.10 release notes][release].

One example was `GameFlags.dicePool`. Its JVM generic signature changed like this:

```text
Before: (I)Lscala/collection/immutable/List<Ljava/lang/Object;>;
After:  (I)Lscala/collection/immutable/List<Ljava/lang/Integer;>;
```

The erased JVM descriptor stayed the same. The generic metadata became more precise. Other reports involved
boxed `Long` and `Boolean` arguments, or type parameters added to synthetic case-class copy defaults.
Our [packed opaque domain types]({% post_url 2026-05-13-zero-cost-domain-modeling-with-scala-3-opaque-types %})
made these primitive-backed signatures especially common.

That distinction matters: existing binaries can still link, while Java source consuming the generic API can
be affected. Our Java facade tests passed; that does not prove every possible Java call site remains compatible.

We accepted the reviewed changes against the existing `0.17.1` baseline. An automated review caught a weakness
in our first approach: filtering by member name alone could also hide a later change to that member's element
type. We tightened the filters to match the member **and both exact signatures**:

```scala
import com.typesafe.tools.mima.core.{IncompatibleSignatureProblem, Problem, ProblemFilters}

def signatureChange(member: String, previous: String, current: String): Problem => Boolean = {
  val keep = ProblemFilters.exclude[IncompatibleSignatureProblem](member)
  problem =>
    problem match {
      case IncompatibleSignatureProblem(oldMethod, newMethod)
          if oldMethod.signature.toString == previous && newMethod.signature.toString == current =>
        keep(problem)
      case _ => true
    }
}
```

Each entry supplies the full member identifier and the two strings above. The complete list applies only when
`RulesMimaBaseline == "0.17.1"`.

We checked the filter itself: changing the expected new `dicePool` signature to `List<Long>` produced exactly
one MiMa failure. Restoring `List<Integer>` passed. An exception in a compatibility gate needs a negative control.

## Inlining met a coverage limit

The normal compilation was only part of the story. Under coverage, the expanded `makeMove` body reached 4,062
tree nodes. Scala 3.10's [coverage instrumenter][instrumenter] skips method bodies above 3,000 nodes to reduce
the risk of exceeding the JVM method-size limit.

It issued a warning. With `-Werror`, that stopped our build.

The change was small:

```diff
-  private[engine] inline def computeMoveZobristKey(
+  private[engine] def computeMoveZobristKey(
```

Keeping the Zobrist-hash helper separate brought the expanded caller back within the instrumentation limit.
The algorithm stayed the same; coverage and warnings-as-errors remained enabled. Removing Scala's forced
inlining also leaves the JVM JIT free to make its own inlining decisions.

There was one smaller source fix. A test deliberately checking `GameState.equals` against an unrelated object
had widened its receiver to `Any`. That selected deprecated `Any.equals` under the new compiler:

```diff
-    val s: Any = emptyState()
+    val s = emptyState()
     assert(!s.equals("not a game state"))
```

The test now calls the concrete override it was intended to exercise.

## Measuring the migration

Our first performance probe compared the inline and separate helpers **both on Scala 3.10**. It helped assess
that fix, but could not answer whether the whole migration regressed. Other work was also running on the
development machine. We moved the version comparison to a separate, otherwise idle Linux server.

Both variants used [commit `1cd3645`][measured-commit]. Variant A set all modules to Scala 3.8.4 and restored
the old inline `Position.scala` from [commit `9b515b7`][old-position]. Variant B used Scala 3.10.0 and the helper
fix. Other production sources and benchmark fixtures were shared.

**This compares the complete migration, including the inline change. It does not isolate the compiler's effect.**
Also, A is a uniform 3.8.4 control, rather than the original mixed-version build.

The environment was an Intel Core i5-2500, four CPUs, about 3.3 GiB of OS-visible RAM, Temurin 25.0.4.1,
sbt 2.0.12 and JMH 1.37. Background backup containers were paused during each series.

For every case we ran blocks in **A1 → B1 → B2 → A2** order, with two fresh JVM forks per block: four forks
per version. Each fork had five one-second warmups and seven one-second measurements, one worker thread,
and these JVM settings:

```text
-Xms512m -Xmx512m -XX:+UseG1GC -XX:ActiveProcessorCount=2
```

We averaged iterations within each fork, then compared geometric means across forks. The approximate 95%
intervals use log ratios and a conservative t critical value with three degrees of freedom. Iterations inside
one JVM are not independent replications. Intervals are pointwise, without a multiple-comparison correction.

Selected results follow. Negative changes mean less time per operation; the [complete data and protocol][data]
include all 17 cases, fork means and the analysis script.
The [result CSV]({{ '/assets/data/scala-3-10-migration/results.csv' | relative_url }}) also includes the separate follow-up.

| Workload | A, µs/op | B, µs/op | Time change | Approx. 95% interval |
| :--- | ---: | ---: | ---: | :--- |
| Quiet move | 0.1505 | 0.1525 | +1.33% | −7.77% to +11.32% |
| Double pawn push | 0.1519 | 0.1534 | +0.97% | −5.98% to +8.44% |
| All moves, initial position | 0.5361 | 0.5391 | +0.55% | −0.96% to +2.09% |
| All moves, kiwipete | 1.0173 | 1.0211 | +0.37% | −4.01% to +4.96% |
| Greedy, endgame, dice 1 | 2.2803 | 2.1510 | −5.67% | −9.16% to −2.05% |
| Greedy, initial, dice 1,2,3 | 286.5829 | 244.8076 | −14.58% | −17.50% to −11.55% |
| Expectimax, cold tree, depth 2 | 76.9989 | 57.0451 | −25.91% | −28.30% to −23.45% |
| Expectimax, cold tree, depth 3 | 25132.5268 | 19525.3110 | −22.31% | −24.75% to −19.80% |

Across all cases, move-generation point estimates ranged from −2.63% to +0.55%; greedy latency fell
5.67–14.66%. The four Expectimax cases fell 22.31–25.91%, but used a sparse tactical position with
`candidateLimit = 1`, a transposition table cleared before every invocation, and a fixed random seed.
They do not represent every search tree or a production game.

## The quiet move still has an asterisk

Before analysing the results, we chose +5% as a practical slowdown margin. The two packed-move cases had
wide intervals, so we ran a bounded follow-up: the same ABBA order and fork count, five two-second warmups,
five three-second measurements, and CPU affinity to one core. We analysed it separately.

| Follow-up workload | A, µs/op | B, µs/op | Time change | Approx. 95% interval |
| :--- | ---: | ---: | ---: | :--- |
| Double pawn push | 0.1572 | 0.1534 | −2.42% | −8.48% to +4.04% |
| Quiet move | 0.1476 | 0.1475 | −0.07% | −5.37% to +5.53% |

The quiet-move estimate is almost unchanged. Its upper bound is still **+5.53%**. We cannot strictly exclude
a 5% regression for that case under this analysis. “No confirmed slowdown” is the supported conclusion;
“every case passed the 5% margin” is not.

Four forks per version leave uncertainty. CPU frequency and temperature were not locked, and monitoring did
not establish zero background activity throughout. These JVM measurements say nothing about JS/Wasm speed,
ONNX inference, real-game strength or multithreaded scaling. The public data contains fork means, not the
privately archived iteration logs.

## What I would check on the next upgrade

The [merged migration][migration] passed 3,220 tests, compatibility checks, coverage thresholds, documentation
and JS/Wasm packaging checks. Those functional gates and the performance experiment answer different questions.

My checklist for the next compiler upgrade is short:

1. Inspect effective Scala versions in every module, including matrix rows and documentation projects.
2. Review generic-signature changes and Java callers; test any compatibility filters with a deliberate mismatch.
3. Compile with coverage enabled as well as disabled.
4. Compare the complete migration on a quiet machine, retaining uncertainty and the original measurements.

The version edit took seconds. Establishing what we had actually changed took the work.

[engine]: https://github.com/fortemate/dicechess-engine
[release]: https://scala-lang.org/news/3.10/
[instrumenter]: https://github.com/scala/scala3/blob/3.10.0/compiler/src/dotty/tools/dotc/transform/InstrumentCoverage.scala#L908-L912
[migration]: https://github.com/fortemate/dicechess-engine/pull/450
[measured-commit]: https://github.com/fortemate/dicechess-engine/tree/1cd3645f50859e89c18aaa60ddf55993fd6051b0
[old-position]: https://github.com/fortemate/dicechess-engine/blob/9b515b7ba44d90317771ab81822ec8023b98cc28/shared-rules/src/main/scala/dicechess/engine/domain/Position.scala
[data]: https://github.com/rabestro/rabestro.github.io/tree/4944b65a233be4b028eb3f7860846a47273ece29/assets/data/scala-3-10-migration
