"""Recalculate latency summaries from the published per-fork means (Python 3)."""

import csv
import math
import statistics
import sys
from collections import defaultdict
from pathlib import Path

root = Path(__file__).resolve().parent
cases = defaultdict(lambda: defaultdict(list))
with (root / "fork-means.csv").open(encoding="utf-8", newline="") as source:
    for row in csv.DictReader(source):
        value = float(row["mean_us"])
        if not math.isfinite(value) or value <= 0:
            raise ValueError("Fork means must be finite positive latencies")
        cases[(row["series"], row["case"])][row["version"]].append(value)

writer = csv.writer(sys.stdout, lineterminator="\n")
writer.writerow(["series", "case", "A_us", "B_us", "change_percent", "ci95_low_percent", "ci95_high_percent"])
for (series, name), versions in sorted(cases.items()):
    if set(versions) != {"A", "B"} or any(len(values) != 4 for values in versions.values()):
        raise ValueError(f"Expected four forks per version: {series}, {name}")
    a, b = ([math.log(value) for value in versions[version]] for version in ("A", "B"))
    delta = statistics.mean(b) - statistics.mean(a)
    se = math.sqrt(statistics.variance(a) / 4 + statistics.variance(b) / 4)
    # df=3 is the minimum Welch df for two independent groups of four.
    margin = 3.182446305 * se
    writer.writerow([
        series, name, math.exp(statistics.mean(a)), math.exp(statistics.mean(b)),
        100 * (math.exp(delta) - 1),
        100 * (math.exp(delta - margin) - 1),
        100 * (math.exp(delta + margin) - 1),
    ])
