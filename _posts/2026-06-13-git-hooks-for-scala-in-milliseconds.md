---
title: "Git Hooks for Scala in Milliseconds: Lefthook, Native Scalafmt, and Betterleaks"
date: 2026-06-13 10:00:00 +0300
categories: [DevOps, Scala]
tags:
  [scala, git-hooks, lefthook, scalafmt, gitleaks, betterleaks, mise, developer-experience]
mermaid: false
---

Almost nobody uses git hooks in Scala projects. I understand why: everything in the Scala
world traditionally goes through sbt, and sbt means booting a JVM, loading plugins, and
resolving a build — fifteen to twenty-five seconds before a single line of your code is
checked. Nobody wants to pay that tax on every commit, so the usual verdict is to skip
pre-commit checks entirely and let CI catch formatting issues ten minutes later.

This week I rebuilt the git-hook setup for one of my pet projects, and the verdict turned
out to be obsolete. A formatting check on a typical commit now takes **44 milliseconds**.
Here is the full configuration, the measurements behind it, and two traps I stepped into
along the way.

## The starting point

The project is a Scala 3 backend living next to legacy Python code in the same repository.
The hooks had been managed by [pre-commit](https://pre-commit.com/) — a fine tool, but it
drags a Python toolchain into every repository that uses it. Since the project is migrating
away from Python, keeping `pipx` and `pre-commit` around just to run git hooks felt
backwards.

The first decision was to switch the hook manager to
[Lefthook](https://github.com/evilmartians/lefthook): a single Go binary, YAML
configuration, parallel execution, no runtime dependencies. It installs cleanly through
[mise](https://mise.jdx.dev/), which I already use as the task runner and toolchain manager
everywhere ([I wrote about that setup earlier]({% post_url 2026-05-11-unifying-monorepo-chaos-with-mise %})).

My initial Lefthook configuration deliberately left Scala formatting out of the pre-commit
stage. The comment in the config said it plainly: *"Scala formatting is too slow for
per-commit checks."* The full `sbt scalafmtCheckAll` ran only on pre-push, and only when
Scala files were actually being pushed.

That comment survived less than a day.

## The discovery: scalafmt ships native binaries

Reading through the [scalafmt installation
docs](https://scalameta.org/scalafmt/docs/installation.html#native-binaries), I noticed
something I had managed to overlook for years: scalafmt ships **pre-built native binaries**
with instant startup, no JVM involved. The sbt plugin is only one way to run the formatter
— and for short-lived runs like a git hook, it is the worst one.

The numbers on my project (fourteen Scala source files):

| How you run it | Time |
| :--- | :--- |
| Native CLI, typical commit (2 staged files) | **0.044 s** |
| Native CLI, every Scala file in the project, cold | 1.02 s |
| `sbt scalafmtCheckAll` with a warm sbt server | 3.5 s |
| `sbt scalafmtCheckAll`, cold | 15–25 s |

Three orders of magnitude between the native CLI and a cold sbt run. At 44 milliseconds,
the formatting check is free — you will not notice it between typing `git commit` and
seeing your editor close the COMMIT_EDITMSG buffer.

## Trap one: the native binary does not dispatch versions

The scalafmt documentation makes a promise: if the `version` in `.scalafmt.conf` differs
from the CLI version, the CLI downloads and runs the right one. I pinned the latest CLI,
ran it, and got an error instead of a download.

It turns out the promise holds **only for the JVM launcher**. The native binary cannot
re-exec itself into a different version, and tells you so — politely, but only after you
hit it:

> NOTE: this error happens only when running a native Scalafmt binary.
> Scalafmt automatically installs and invokes the correct version of Scalafmt
> when running on the JVM.

The consequence: the CLI version you install must exactly match the `version` declared in
`.scalafmt.conf`. I encode that coupling in `mise.toml` with a comment, so the next person
(usually future me) bumps both together:

```toml
[tools]
lefthook = "latest"
scalafmt = "3.11.1"           # native CLI; MUST match version in .scalafmt.conf
```

The good news: the sbt plugin reads the same `.scalafmt.conf`, downloads the matching core,
and agrees with the native CLI byte for byte. One config file, two runners, no drift.

## Trap two: `**/` does not match files in the root

My first glob for the hook was `backend/**/*.scala` — and then I extended it to cover
`build.sbt`, because sbt build definitions are Scala too and `scalafmtCheckAll` checks
them. The obvious pattern `backend/**/*.{scala,sbt}` silently missed `backend/build.sbt`:
in glob semantics, `**/` requires at least one intermediate directory.

The pattern that matches both nested sources and top-level build files:

```yaml
glob: "backend/**.{scala,sbt}"
```

I only caught this because I tested the hook by actually staging a `.sbt` file and watching
which jobs Lefthook dispatched. Globs are exactly the kind of code that looks correct in
review and fails silently in production — test them with real files.

## Replacing the secret scanner along the way

The hook suite also includes secret scanning. I had started with
[gitleaks](https://github.com/gitleaks/gitleaks), but while reading its documentation I
noticed a warning at the top of the README: gitleaks is feature-complete, future releases
will be security patches only, and the author is shifting his focus to a successor project
called [Betterleaks](https://github.com/betterleaks/betterleaks).

A word of caution that applies to everyone: when a popular **security tool** suddenly has a
"newer, better successor", do not take the link at face value. A secret scanner reads your
secrets by design — a malicious lookalike is a perfect exfiltration vector. Before adopting
it, I verified three things:

1. The succession claim appears in the official gitleaks README itself, not in a random
   blog post or issue comment.
2. The top contributor of Betterleaks is `zricethezav` — the author of gitleaks.
3. The license is the same MIT, and the project ships through the same distribution
   channels (it is already in the mise registry).

Adopting the successor at introduction time beats migrating off a frozen tool later. And
since trust requires verification, I tested the hook by staging a file with a
format-valid fake GitHub token: `leaks found: 1`, exit code 1, commit blocked. My first
test attempt, amusingly, "failed" — I had planted the canonical AWS example key from the
documentation, which scanners correctly allowlist. The tool was smarter than my test.

One deliberate choice: Betterleaks supports *validating* candidate secrets with HTTP
requests to the issuing services. I leave that off in hooks — detection works offline, and
nothing a hook finds should ever leave the machine.

## The resulting configuration

Three tiers, each sized to its latency budget:

```yaml
# lefthook.yml
pre-commit:
  parallel: true
  jobs:
    # Secret scanning: abort if any staged diff leaks a credential
    - name: betterleaks
      run: betterleaks git --pre-commit --redact --staged

    # Native scalafmt CLI: ~44ms per commit. The pinned mise version must
    # match .scalafmt.conf (the native binary does not dispatch versions).
    - name: scalafmt
      glob: "backend/**.{scala,sbt}"
      run: scalafmt --config backend/.scalafmt.conf --test {staged_files}

    # Python linting while the legacy code is still around. check --fix and
    # format both rewrite files: one sequential job avoids concurrent writes
    - name: ruff
      glob: "**/*.py"
      run: uv run ruff check --fix {staged_files} && uv run ruff format {staged_files}

# Full backend validation (tests + coverage) is too slow for per-commit:
# run it only when backend/ files are pushed.
pre-push:
  jobs:
    - name: backend-check
      glob: "backend/**/*"
      run: mise run backend:check
```

- **Pre-commit, milliseconds:** formatting and secret scanning on staged files only.
- **Pre-push, twenty seconds:** the full sbt gate — compile, scalafmt across the project,
  tests against a real PostgreSQL in testcontainers, coverage threshold — and only when
  files under `backend/` are actually part of the push.
- **CI, minutes:** the same gate again, on every pull request, because local hooks are a
  courtesy, not a guarantee — anyone can commit with `--no-verify`.

A pleasant detail about Lefthook worth knowing: `{staged_files}` already excludes deleted
files, and a job whose glob matches nothing is skipped entirely. A code-review bot
confidently told me the configuration above would crash on deleted files; staging an actual
`git rm` and running the hook took thirty seconds and settled the question. Empiricism is
cheap — use it on your reviewers too.

## Closing thought

The "Scala is too slow for git hooks" folklore is a statement about sbt startup, not about
Scala tooling. The formatter itself was always fast; it just needed to escape the JVM
boot sequence. One pinned native binary later, the gap between "commit" and "feedback" is
forty-four milliseconds — and the comment in my config that said it could not be done is
gone from the file, but preserved here as a reminder.
