# Paper-Companion Writing Standards

Date: 2026-04-25

Use this when turning Dell-7810 evidence into blog posts, papers,
presentations, or collaborator drafts.

The goal is numbers-driven discoverability. The prose can still sound like
Jess, but the structure must let a reader find the measurement, reproduce the
capture, and understand the claim boundary before the narrative has a chance to
wander.

## Default Shape

Every paper-companion artifact should start with these blocks, in this order:

1. **Result card**: host, date, kernel lane, compiler source, command, result,
   and claim level.
2. **Evidence table**: exact repo paths for raw captures, projected records,
   source code, and figure sources.
3. **Measured numbers**: one compact table before any long explanation.
4. **Claim boundary**: what the result establishes, what it does not establish,
   and what would be needed to strengthen it.
5. **Method narrative**: short explanatory prose that connects the numbers to
   the broader body of work.
6. **Reproduction command**: the smallest truthful command path.

If a draft starts with vibes, history, or a large framing paragraph, move that
material below the result card or cut it.

## Blog Voice Constraint

The blog can use the `jesssullivan.github.io` voice, but only after the data is
visible.

Allowed:

- first-person discovery notes after the evidence block,
- short punch sentences for emphasis,
- hardware personality where it clarifies the work,
- a warm closing.

Avoid:

- "tiny program, big feelings" openings without numbers,
- fake cliffhangers,
- claims that depend on a future experiment,
- "we" unless naming a specific collaboration,
- narrative transitions that could fit any technical blog post.

## Figure Rules

Prefer Graphviz for paper-bound figures because it is diffable, renderable, and
portable into papers and slides.

Figure requirements:

- store source under [`figures/`](figures/),
- use stable node IDs,
- keep labels short enough for slides,
- encode claim status with shape or color, not prose alone,
- cite the evidence path in the figure caption or surrounding table.

Do not create one-off Mermaid diagrams in blog posts unless the same structure
also has a repo-owned Graphviz source.

## Slop Reduction Checklist

Before publishing or sharing a draft:

- every numeric claim has a repo path,
- every "proved", "validated", "replayed", or "reproducible" verb has an
  artifact behind it,
- every RT sentence says whether it is C0, C1, C2, C3, or C4,
- `honey` live-host evidence is not mixed with runner/cache proof,
- Dell-7810 remains the host evidence authority,
- XoxDWM is only cited for downstream software benefit claims,
- missing evidence is tracked as a task, not hidden in future-tense prose.

## Wording Discipline

| Pattern to avoid | Pattern to use |
| --- | --- |
| Chapel sees NUMA nodes | The OS reports N NUMA nodes; Chapel ran in a flat locale model |
| The host is optimized | The generic lane produced a host-characterization result |
| PBT proved the kernel is faster | PBT validated N invariants across M generated cases |
| 10x speedup (without context) | 10x speedup on synthetic channel reduction (not an application benchmark) |
| Chapel proved NUMA scheduling | Chapel expressed a parallel host probe against OS-visible topology |

## Cross-References

Every paper-companion post should link to:

- the Dell-7810 repo source files (paths will become public links)
- the relevant public GitHub issues when public tracker context helps
- the publication roadmap
  ([`bodies-of-work-chapel-flow.md`](bodies-of-work-chapel-flow.md))
- the claim ladder
  ([`../platform/rt-research-contract.md`](../platform/rt-research-contract.md))
- peer repo PRs where boundary decisions were made

External citations should use stable URLs.

## Tracker Anchors And Visibility

Linear is the internal planning surface. GitHub and repo paths are the public
artifact surface.

Use private Linear links in:

- internal collaborator briefs,
- draft planning notes,
- issue triage comments,
- private paper staging documents.

Do not put private Linear URLs in public blog posts, papers, slides, or
abstracts. For public artifacts, cite the public repo path, GitHub issue/PR, or
published result note instead.

Current internal tracker anchors:

- Initiative:
  `Dell-7810 Chapel/RT/NUMA Publication Program (2026-2027)`
- Umbrella:
  `Rockies / XR Workstation Program (2026-2027)`
- BoW-5 issue: `TIN-596`
- BoW-3 issue: `TIN-597`
- BoW-4 issue: `TIN-598`
- BoW-1 issue: `TIN-599`
- BoW-2 issue: `TIN-600`
- Venue research: `TIN-601`

## Repo and Project Context

| Repo | Role | Link |
| --- | --- | --- |
| Jesssullivan/Dell-7810 | Host evidence authority | [GitHub](https://github.com/Jesssullivan/Dell-7810) |
| tinyland-inc/linux-xr | Kernel carry, RPM release | [GitHub](https://github.com/tinyland-inc/linux-xr) |
| tinyland-inc/rockies | Umbrella meta repo | [GitHub](https://github.com/tinyland-inc/rockies) |
| Jesssullivan/XoxdWM | Compositor, XR, BCI (C4 authority) | [GitHub](https://github.com/Jesssullivan/XoxdWM) |
| tinyland-inc/GloriousFlywheel | Shared runner, cache, Bazel substrate | [GitHub](https://github.com/tinyland-inc/GloriousFlywheel) |
| Jesssullivan/jesssullivan.github.io | Blog publication surface | [GitHub](https://github.com/Jesssullivan/jesssullivan.github.io) |

## External References

- [Chapel Language](https://chapel-lang.org/)
- [Chapel 2.8.0 Release Notes](https://chapel-lang.org/releaseNotes/2.8.html)
- [Chapel Locale Models](https://chapel-lang.org/docs/usingchapel/localeModels.html) -
  explains `CHPL_LOCALE_MODEL=flat` and `Sublocales: 0`
- [quickchpl](https://github.com/nicholasTng/quickchpl) - property-based
  testing library for Chapel
- [Dhall Language](https://dhall-lang.org/) - typed configuration and evidence
  records
- [Nix](https://nixos.org/) - hermetic build and compiler sourcing
- [OSADL Real-Time Wiki](https://osadl.org/Real-Time-Linux.real-time-linux.0.html) -
  RT Linux measurement methodology
- [Intel SDM Vol 3 Ch 34](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html) -
  SMI architecture reference
- Claessen & Hughes, "QuickCheck: A Lightweight Tool for Random Testing of
  Haskell Programs," ICFP 2000
- Chamberlain et al., "Parallel Programmability and the Chapel Language,"
  HPDC 2007
- Broquedis et al., "hwloc: A Generic Framework for Managing Hardware
  Affinities in HPC Applications," Euro-Par 2010
- Diener et al., "Locality vs. Balance: Exploring Data Mapping Policies on
  NUMA Multiprocessors," JPDC 2015
- Stodden et al., "Enhancing Reproducibility for Computational Methods,"
  Science 2016

## Current First Artifact Rule

For BoW-5, the safe first blog/presentation shape is:

- result: first generic/RT Chapel + SMI + `hwlat` packet exists, and the first
  RT packet is neutral-to-negative rather than an improvement result,
- repeatability: five generic store-prebuilt Chapel repeats exist and show
  material ratio variance under current lab load,
- RT repeat context: matching 120s RT SMI/`hwlat` windows and a hardened
  five-sample RT Chapel repeat exist; the repeat is neutral-to-negative because
  RT has a lower ratio mean, higher ratio variance, and one severe parallel
  outlier,
- method: Nix + Chapel + Dhall made the result replayable and citable,
- boundary: this is host characterization, not RT benefit, not downstream
  XoxDWM benefit, and not an application benchmark,
- next evidence: fresh PBT run output, downstream deadline packet design, and
  a decision on whether the RT `14 us` `hwlat` threshold crossing needs rerun
  or becomes part of the cautionary result.
