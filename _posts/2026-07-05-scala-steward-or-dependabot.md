---
title: "Scala Steward or Dependabot? Automating sbt Dependency Updates"
date: 2026-07-05 12:00:00 +0300
categories: [DevOps, Scala]
tags:
  [scala, sbt, dependabot, scala-steward, dependencies, automation, developer-experience]
mermaid: false
---

For years, keeping Scala dependencies up to date had one obvious answer: [Scala Steward](https://github.com/scala-steward-org/scala-steward). It is mature, Scala-native, and runs a free public instance that sends pull requests to open-source projects for you. There was little reason to look anywhere else.

Then, in May 2026, [Dependabot added support for the sbt ecosystem](https://github.blog/changelog/2026-05-26-dependabot-version-updates-now-support-the-sbt-ecosystem/). The default suddenly has a serious alternative — and if your projects already live on GitHub, it is one worth taking seriously.

I recently set up automated dependency updates across my open-source repositories and, after weighing both tools, settled on Dependabot. Not because it is better than Scala Steward — in several respects it is not — but because it fit my situation better. This article is the honest comparison behind that decision, and the one trap I hit while wiring it up.

One note on scope before I start: there is a third option, [Renovate](https://docs.renovatebot.com/modules/manager/sbt/), which also has deep sbt support and is excellent. I was choosing between the two bots that fit my workflow most directly, so those are the two I'll compare here.

## The incumbent: Scala Steward

Scala Steward is not a generic dependency bot that happens to read `build.sbt`. It understands the Scala build model, and that shows up in what it can update:

- **Library dependencies** in `build.sbt`, including cross-built artifacts (`%%` and `%%%` for Scala.js / Native).
- **sbt plugins** in `project/plugins.sbt`.
- **The sbt version** in `project/build.properties`.
- **The Scala version** itself.

That last one matters more than it looks. Bumping `scalaVersion` is exactly the kind of chore that quietly rots — Steward treats it as just another dependency.

Its standout feature, though, is **Scalafix migrations**. When a library ships migration rules alongside a breaking release, Scala Steward can apply them automatically inside the update PR. A breaking API change arrives with the mechanical part of the migration already done for you — not just a version bump that leaves your build red until you fix every call site by hand. No general-purpose bot does this, because it requires understanding the language, not just the version string.

Add to that a free hosted instance for open-source projects, sensible grouping of related updates, and years of accumulated Scala-specific knowledge, and you have a tool that is genuinely hard to beat *on Scala terms*.

## The newcomer: Dependabot speaks sbt

Dependabot's sbt support is younger and narrower, but it covers more than the announcement led me to expect. The changelog talks only about monitoring "`build.sbt` inputs," so I assumed it would stop at library coordinates. It does not.

When I enabled it, the first pull requests it opened bumped:

- library dependencies in `build.sbt`, as advertised;
- an sbt **plugin** in `project/plugins.sbt` (`sbt-scalafix`, `0.12.1 → 0.14.7`);
- the **sbt version** itself in `project/build.properties`.

So in practice it reaches the plugin file and the build launcher, not just your library list. For most projects, that is the bulk of what you actually need kept current.

![Dependabot pull requests for the sbt and npm ecosystems in one repository](/assets/img/2026-07-05-dependabot-sbt-prs.png)
_A single morning of Dependabot PRs in one repository: an sbt library (`jline`), the sbt version itself (`org.scala-sbt:sbt`), sbt plugins (`sbt-scalafmt`, `sbt-scalafix`, `sbt-scalajs`), and npm packages for the docs site — each opened as its own reviewable PR and gated by CI. The red mark on the `sbt-scalajs` bump is the safety net doing its job; more on that below._

There are two honest limitations to name up front:

- **Version updates only, not security updates.** The changelog is explicit about this: at launch, sbt is supported for scheduled version bumps, not for Dependabot's security-alert-driven updates. For npm and GitHub Actions I get both; for sbt, today, I get the former.
- **No Scalafix migrations.** Dependabot changes the version number and nothing else. A breaking major bump lands as a red build you fix yourself. This is the real functional gap versus Steward, and no amount of configuration closes it.

It is worth being concrete about what "version number and nothing else" means. Shortly after I enabled sbt updates, a **minor** bump of the Scala.js plugin (`sbt-scalajs`, `1.21.0 → 1.22.0`) — minor, so semver promises no breakage — failed my build outright: the new release tightened a linker requirement my project did not yet satisfy. That is not a knock on Dependabot; Scala Steward would have proposed exactly the same bump. It is the reminder that any automated update is only as safe as the CI gating it. The bot raises the version; your test suite decides whether that version gets in. If you are going to let robots open dependency PRs, a real CI pipeline is not optional — it is the half of the system that makes the other half safe.

## Why I chose Dependabot

If Steward is stronger on Scala terms, why did I pick the other one? Because my repositories are not *only* Scala, and that changed the question.

**One tool for every ecosystem.** A typical repository of mine is polyglot: a Scala engine, an npm-based documentation site, GitHub Actions workflows, and pre-commit hooks. I was already running Dependabot for all the non-Scala parts. Adding sbt did not introduce a new tool, a new config format, or a new mental model — it was four lines in a file I already maintain:

```yaml
  - package-ecosystem: "sbt"
    directory: "/"
    schedule:
      interval: "weekly"
```

Every ecosystem now updates through the same bot, opens PRs in the same shape, and wears the same labels and reviewers. One place to look, one thing to reason about.

**It covers my baseline needs for open-source repos.** What I actually require from dependency automation is modest: regular bumps for libraries, plugins, and actions, opened as reviewable PRs, with as little infrastructure as possible. Dependabot is native to GitHub — nothing to host, nothing to authorize, nothing to keep alive. For a solo maintainer spreading attention across several repositories, "already there and zero moving parts" is worth a great deal.

**It scales across repositories cheaply.** I have more repos to onboard, and with Dependabot that is a copy-paste of one YAML block per repo — not a separate service to enable and configure each time.

None of this makes Dependabot the objectively better tool. It makes it the better fit for a GitHub-hosted, multi-language, low-maintenance setup — which is exactly what I have.

## Where Scala Steward still wins

I would reach for Scala Steward without hesitation if my context were different. It is the better choice when:

- **Your stack is Scala-first.** If the vast majority of your dependencies are Scala libraries and plugins, Steward's depth is pure upside and the polyglot argument for Dependabot mostly evaporates.
- **You want Scalafix migrations.** On a project that tracks fast-moving libraries with breaking releases, having migrations applied automatically is a real, recurring time saver.
- **You want the Scala version kept current too**, or you lean on grouped, Scala-aware update logic.

This is not a "loser's bracket." For a heavily Scala codebase, Steward is arguably still the right default. My decision is a statement about my repositories, not a verdict on the tools.

## Setting it up

Here is the minimal sbt block, in context:

```yaml
version: 2
updates:
  - package-ecosystem: "sbt"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
    labels:
      - "dependencies"
```

In a polyglot repo you simply list more ecosystems (`github-actions`, `npm`, `pre-commit`, …) as sibling entries under `updates`, each on its own schedule.

If the volume of PRs starts to feel noisy, group the low-risk ones so patch and minor bumps arrive together instead of one PR at a time:

```yaml
    groups:
      sbt-minor-and-patch:
        update-types:
          - "minor"
          - "patch"
```

Majors stay on their own — which is exactly what you want, for the reason the next section explains.

## The trap: the sbt 2.x major bump

The first batch of PRs included one I was very glad I read before merging:

```
chore: bump org.scala-sbt:sbt from 1.12.12 to 2.0.1
```

sbt 2.0 is a **breaking major release**. It changes the build definition model and the plugin contract; plugins have to be rebuilt against it, and a real project does not follow it by accident on a Friday-morning autobump. Dependabot is doing its job correctly here — a newer version *does* exist — but "correct" and "safe to merge unattended" are not the same thing.

This is where Dependabot's lack of Scala awareness shows. Steward users lean on curated version pins for cases like this; with Dependabot you express the same intent with an `ignore` rule that refuses the major while still allowing patch and minor updates to sbt:

```yaml
    ignore:
      # sbt 1.x -> 2.x is a breaking major requiring a deliberate, manual
      # migration (plugin compatibility, build definition changes) - not an
      # automated bump.
      - dependency-name: "org.scala-sbt:sbt"
        update-types: ["version-update:semver-major"]
```

The effect is immediate and exactly what you want. With the major pinned out, the next run replaced the `2.0.1` proposal with a PR to bump `org.scala-sbt:sbt from 1.12.12 to 1.12.13` — a patch that sailed through CI. You keep every safe update and decline only the one release that demands a deliberate migration.

The rule is not "never upgrade to sbt 2" — it is "upgrade to sbt 2 as a project, on purpose, not as an unattended PR." When a new class of breaking major shows up, add another `ignore` entry rather than closing the same PR every week. Treat the noisy autobump as a signal to encode a decision, not as a chore to dismiss.

## Closing thought

The interesting part of this story is not that one tool won. It is that Scala finally has a real *choice* in dependency automation, and the right answer now depends on your context rather than defaulting to the only game in town.

If your world is mostly Scala and you value Scalafix migrations, Scala Steward remains excellent and I would not talk you out of it. If your repositories are polyglot, GitHub-hosted, and you would rather run one bot than two, Dependabot's new sbt support is more than good enough — and it is four lines away. Just add the `ignore` rule for major sbt bumps before the first Friday, and let the robots handle the rest.
