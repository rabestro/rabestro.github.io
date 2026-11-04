# Scala 3.8.4 → 3.10.0 migration: measurement supplement

Measured on 2026-11-04. This is the public numerical supplement to the blog post,
not an export of the private operational archive.

## Data and recalculation

- `fork-means.csv`: all 152 fork means (17 main cases plus 2 follow-up cases,
  4 forks per version per case), in microseconds per operation.
- `results.csv`: all 19 comparisons, retaining the main and follow-up series separately.
- `analyze.py`: Python standard-library analysis; run `python3 analyze.py` to print
  the result CSV. No dependencies or network access required.

Fork means are arithmetic means of JMH measurement iterations, converted from
milliseconds where necessary. A1/B1 and B2/A2 each contain two fresh JVM forks.
The CSV retains these block labels; fork numbers are local to each block.
Raw iteration JSON and operational logs remain in the private experiment archive.
This supplement supports recalculation from fork means, not an independent audit
of the original iteration samples or host telemetry.

For each case, compare geometric means of the four fork means per version.
The change is `100 * (B/A - 1)`. Construct approximate pointwise 95% intervals
from the difference of mean log latencies, standard error
`sqrt(var(log A)/4 + var(log B)/4)`, and t critical value `3.182446305`
(df=3, the minimum Welch df for these group sizes). This assumes suitable
log-fork-mean distributions; no multiple-comparison adjustment is made.

## Source and environment

Both variants start from public engine commit
[`1cd3645f50859e89c18aaa60ddf55993fd6051b0`](https://github.com/fortemate/dicechess-engine/tree/1cd3645f50859e89c18aaa60ddf55993fd6051b0).

- A: change `val ScalaV = "3.10.0"` in `build.sbt` to `"3.8.4"`; restore
  `shared-rules/src/main/scala/dicechess/engine/domain/Position.scala` from
  `9b515b7ba44d90317771ab81822ec8023b98cc28`.
- B: the common commit unchanged, Scala 3.10.0 and the separate hash helper.
- All other production sources and JMH fixtures are shared.

This tests the complete migration, including the helper change, not the compiler
in isolation. A is a uniformly pinned 3.8.4 control, not the original mixed build.

Linux x86_64, Intel Core i5-2500 @ 3.30 GHz, four CPUs, 3347 MiB OS-visible RAM;
Temurin 25.0.4.1, sbt 2.0.12, JMH 1.37. Backup containers paused during each
series; builds and measurements sequential. Governor, frequency and temperature
not fixed. Main telemetry recorded no swap or steal; supplemental telemetry,
which also covered boundaries between series, included swap-in up to 6 KiB/s.
Neither establishes an absolutely idle machine throughout.

## Running equivalent benchmark series

Create independent A/B checkouts and apply the changes above. Compile each with:

```bash
sbt --server 'benchmark/Jmh/compile; rootJVM/assertNoCoverageInstrumentation'
```

Run each family in A1 → B1 → B2 → A2 order, sequentially. Use two fresh JMH
forks per block, average-time mode and one worker. Common JMH arguments:

```text
-bm avgt -t 1 -wi 5 -w 1s -i 7 -r 1s -f 2
-jvmArgs "-Xms512m -Xmx512m -XX:+UseG1GC -XX:ActiveProcessorCount=2"
-rf json
```

Pass them to `benchmark/Jmh/run`, with a distinct `-rff` filename for each block
and family. Filters and parameter overrides:

| Filter | Overrides | Cases |
| --- | --- | ---: |
| `.*MakeMoveBenchmark.*` | none | 3 |
| `.*MoveGeneratorBenchmark.generate.*` | `-p position=initial,kiwipete -p diceRoll=1` | 4 |
| `.*SearchAlgorithmBenchmark.greedySearch` | `-p position=initial,endgame` | 6 |
| `.*ExpectimaxSearchBenchmark.*` | none | 4 |

Example, from the A checkout for the first move block:

```bash
sbt --server 'benchmark/Jmh/run -bm avgt -t 1 -wi 5 -w 1s -i 7 -r 1s -f 2 -jvmArgs "-Xms512m -Xmx512m -XX:+UseG1GC -XX:ActiveProcessorCount=2" -rf json -rff A1-moves.json .*MakeMoveBenchmark.*'
```

The original run completed the 13 move/generation/greedy cases first, then ran a
separate ABBA series for Expectimax. All use the common warmup/measurement settings.
Generation uses `diceRoll=1`; `generateAllMoves` does not consume this parameter.
Greedy uses the three default pools `1`, `1,2`, `1,2,3` for both positions.
Expectimax uses depths 2/3, ordinary and budgeted cold-tree search, sparse FEN
`k7/8/8/8/8/8/8/R3K3 w - - 0 1`, dice 2/3/6, candidate limit 1, TT capacity
4096 cleared per invocation, and seed 42. The budgeted case uses an ample work budget.

The follow-up is another ABBA series with the same fork/JVM settings. Filter
`.*MakeMoveBenchmark.makeMove.*` selects the two packed-move cases. Override
warmup/measurement with `-wi 5 -w 2s -i 5 -r 3s` and launch sbt with
`taskset -c 2` (choose an available CPU on a different host). Analyse this series
separately; do not pool its forks with the original cases.

## Interpretation

The +5% practical slowdown margin was chosen before analysis. Wide intervals in
the two packed-move cases prompted the bounded follow-up. It did not strictly
exclude +5% for quiet moves: its upper bound remains +5.53%. No measured case
had a confirmed slowdown under the stated interval calculation.

Search improvements describe these fixtures and the complete migration only.
Four forks per version, non-randomised ABBA order, residual machine variation
and sparse Expectimax fixtures limit generalisation. JS/Wasm speed, ONNX,
real games, bot strength and multithreaded scaling were not measured.
