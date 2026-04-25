# Publication Notes

This directory exists to keep future papers, talks, and project writeups from
collapsing several different engineering stories into one vague narrative.

The important split is:

- this repo is the source of truth for Dell 7810 host-platform and enclosure work,
- `XoxdWM` is still the source of truth for XR product logic, XR patch carry,
  and most application-side BCI software behavior,
- the Chapel lane here is a host-characterization and proof-method lane, not a
  substitute for the whole application analysis stack.

## Use these docs before writing or presenting

- [`narrative-lanes.md`](narrative-lanes.md)
  defines the distinct stories this repo can legitimately tell
- [`claim-traceability.md`](claim-traceability.md)
  maps common claim types to the repo and artifacts that should back them
- [`paper-outline-legacy-host.md`](paper-outline-legacy-host.md)
  provides a concrete host-systems paper scaffold
- [`evidence-gap-matrix.md`](evidence-gap-matrix.md)
  marks which sections, figures, and tables are actually supportable today
- [`rt-numa-chapel-experiment-matrix.md`](rt-numa-chapel-experiment-matrix.md)
  narrows the current RT / SMI / NUMA / Chapel lane into publication-safe
  experiment packages
- [`chapel-pbt-publishing-roadmap-2026-04-25.md`](chapel-pbt-publishing-roadmap-2026-04-25.md)
  breaks the Chapel/PBT timing work into paper, blog, and incremental
  publishing bodies of work
- [`bodies-of-work-chapel-flow.md`](bodies-of-work-chapel-flow.md)
  identifies five distinct publishable bodies of work focused on Chapel + PBT
  as development flow, with figure/graph specs, data tables, venue candidates,
  and an internal sequencing proposal
- [`writing-collaboration-brief-2026-04-25.md`](writing-collaboration-brief-2026-04-25.md)
  gives Claude, Codex, and other collaborators a claim-safe writing handoff
- [`paper-companion-standards.md`](paper-companion-standards.md)
  defines the numbers-first, figure-backed, anti-sprawl contract for blog posts,
  papers, and presentations
- [`figures/`](figures/)
  stores Graphviz source for paper/blog/presentation diagrams

These notes sit on top of the more operational boundary audit in
[`../platform/xoxdwm-boundary-audit.md`](../platform/xoxdwm-boundary-audit.md).

## Core rule

If a claim is about what the Dell 7810 hardware does, how it was modified, or
how its host timing/reset/NUMA behavior was characterized, this repo should be
the citation surface.

If a claim is about XR display-path success, headset bring-up, product-facing
BCI behavior, or deployment ops for `honey`, the primary citation surface is
still `XoxdWM`.
