# Repo Health Reality Check -- 2026-04-23

This note is a dated repo-health and symbiosis check for:

- `Dell-7810`
- `XoxdWM`
- the current Linear / Git / evidence alignment

Use it when the question is not "what is the ideal boundary?" but:

- what is actually healthy right now,
- what is still fuzzy,
- and what should be tackled next without inventing a fake sense of closure.

## 2026-04-24 addendum

The branch and CI surface moved again after this note was first written:

- `jess/tin-339-capture-honey-reset-matrix` is now clean and tracking origin
- the branch now also carries the first Dell Chapel CI move toward the
  GloriousFlywheel self-hosted contract
- that contract is still anchored to `honey`-labeled `tinyland-nix` runners,
  and `Dell-7810` is not yet enrolled in a compatible ARC runner set
- current Dell dogfood runs are queued without runner assignment, so the
  self-hosted CI path is not yet live for this repo
- the old `ubuntu-latest` portable lane remains retired
- the live blocker looks like runner scope/enrollment mismatch, not a known
  repo-side contract bug

## Short read

The two-repo relationship is now structurally healthy.

The weak points are no longer ownership confusion. They are evidence gaps and
branch-shape drift.

As of 2026-04-23:

- `Dell-7810` is clean and ahead of origin by 13 commits
- `XoxdWM` is clean on `codex/reality-authority-surface`
- cross-repo duplication is controlled at `0` exact duplicate pairs and `5`
  derived forks
- cacheable Chapel CI is being rewired toward the GloriousFlywheel self-hosted
  contract; the old `ubuntu-latest` portable lane is retired, but live repo
  enrollment still blocks that path today
- the Dell host-evidence lane is real
- the enclosure, stock-fan, and Chapel live-results lanes are still not closed

## Git health

## Dell-7810

- branch: `jess/tin-339-capture-honey-reset-matrix`
- status: clean
- ahead of origin: `13`

What is good:

- the branch contains real committed work, not loose working-tree drift
- the repo now has dated status notes, measured-evidence notes, and explicit
  fan/support tracking surfaces

What is weak:

- the branch is still semantically broader than `TIN-339`
- it now contains reset, BIOS, tuned, RT-prep, fan-lane, boundary, and tracking
  work that really belong to several issue lanes

## XoxdWM

- branch: `codex/reality-authority-surface`
- status: clean

What is good:

- the repo is clean and its Dell-facing boundary notes are already in place
- software-facing `honey` proofs can now point back to Dell evidence instead of
  trying to own the raw host facts

What is weak:

- `XoxdWM` still carries operational and derived-fork surfaces that require
  discipline to keep from becoming shadow authorities

## Symbiosis health

The relationship is healthy in the most important sense:

- `Dell-7810` owns raw host evidence and host-safe summaries
- `XoxdWM` owns downstream software proofs and deployment/boot operations

That is now reinforced by:

- [`../platform/authority-map.md`](../platform/authority-map.md)
- [`../platform/xoxdwm-boundary-audit.md`](../platform/xoxdwm-boundary-audit.md)
- [`../platform/xoxdwm-symbiosis-touchpoints.md`](../platform/xoxdwm-symbiosis-touchpoints.md)
- [`measured-evidence-map.md`](measured-evidence-map.md)

## Duplication health

Current duplication state:

- exact duplicates: `0`
- derived forks: `5`
- missing pairs: `0`

This is acceptable.

It means the repos are no longer silently cloning each other, but they still
share a small number of intentionally diverged surfaces.

The current weak touchpoints are:

- stock fan findings
- enclosure findings
- Chapel live host results

Those are weak because the evidence is not finished, not because the ownership
rule is unclear.

## Evidence health

## Strong

- `honey` reset and power evidence
- BIOS export and machine-check evidence
- bounded SMI samples and tracefs `hwlat`
- generic low-latency kernel posture closure
- NUMA capture and host inventory records

## Weak

- Session 01 enclosure evidence: still `0 / 29`
- stock fan inventory: still unmeasured
- replacement fan support claims: still candidate-only
- Chapel live host result note: still missing

The important reality check is:

- host-platform evidence is no longer fictional
- enclosure and fan-mod evidence are still mostly prospective

## Linear health

The project now has issue coverage for the main missing lanes:

- `TIN-396`: fan families / stock control / aftermarket adaptation
- `TIN-397`: BIOS A34 / C-state / `linux-xr` flow consolidation
- `TIN-398`: cross-repo kernel-posture truth audit
- `TIN-468`: fan support matrix and acoustic-lite lane
- `TIN-469`: Session 01 execution and first printable revision
- `TIN-470`: Dell Chapel lane closure with first live host result

GitHub mirrors now exist for:

- `#16`, `#17`, `#18`, `#19`, `#20`, `#21`

That means the earlier tracking-gap complaint is no longer true.

The remaining planning weakness is not missing issues. It is that the active
Git branch still bundles work from several of them.

## Repo health verdict

If scored bluntly:

- boundary health: strong
- provenance health: strong
- git cleanliness: strong
- issue coverage: now strong
- branch scoping: medium
- host evidence health: medium to strong
- enclosure evidence health: weak
- fan evidence health: weak
- Chapel live-results health: weak

## Recommended next scopes

1. `TIN-469`
   Execute Session 01 and create the first real enclosure evidence.
2. `TIN-468`
   Capture the stock fan inventory before stronger replacement claims.
3. `TIN-470`
   Close the first Dell-owned Chapel live-results note.
4. only after those:
   continue deeper RT or additional fan/noise work

## Recommended discipline

- keep `XoxdWM` consuming Dell host facts by reference
- keep raw measurement artifacts in Dell-7810
- avoid letting the current `TIN-339` branch become the permanent catch-all
- prefer future branch cuts that line up with `TIN-468`, `TIN-469`, and
  `TIN-470`
