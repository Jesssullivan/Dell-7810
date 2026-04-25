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

## Current First Artifact Rule

For BoW-5, the safe first blog/presentation shape is:

- result: generic-lane Chapel probe ran twice on `honey`,
- method: Nix + Chapel + Dhall made the result replayable and citable,
- boundary: this is host characterization, not RT benefit and not an
  application benchmark,
- next evidence: fresh PBT run output, RT-lane Chapel capture, longer SMI /
  `hwlat` windows.

