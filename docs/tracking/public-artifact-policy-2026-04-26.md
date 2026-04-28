# Public Artifact Policy - 2026-04-26

This note defines how `Dell-7810` should handle measured evidence if the repo
is made public.

## Policy

Raw host captures are evidence, but they are not automatically public artifacts.
They can contain:

- operator SSH targets and host nicknames,
- local operator paths,
- disk UUIDs, LVM IDs, filesystem IDs, and serial numbers,
- display EDID / DisplayID detail,
- tailnet or private-network reachability details,
- runner paths and service layout.

For public branches, prefer publishing:

- human-readable result notes under `docs/platform/`, `docs/research/`, and
  `docs/publication/`,
- aggregate CSVs under `docs/publication/data/`,
- sanitized summaries that preserve measurements and claim boundaries,
- machine-readable records only after reviewing host identifiers.

Keep raw captures private unless one of these is true:

- the raw file is intentionally part of the reproducibility record,
- unique identifiers have been redacted,
- or the public-readiness audit explicitly records why the disclosure is
  acceptable.

## Scan Command

Use the repo-owned scanner before preparing a public branch:

```bash
just public-readiness-scan
```

For a public candidate branch, use strict mode:

```bash
just public-readiness-scan --strict
```

Build the raw `honey` capture index with:

```bash
just public-capture-index
```

The generated table lives at
[`../publication/data/honey-public-capture-index-2026-04-26.csv`](../publication/data/honey-public-capture-index-2026-04-26.csv).
It is a triage surface, not a measurement authority. It points reviewers toward
the raw captures that should be removed, summarized, or intentionally retained
before public visibility.

The public candidate branch plan is
[`public-candidate-branch-plan-2026-04-28.md`](public-candidate-branch-plan-2026-04-28.md).
Use it as the release checklist after this policy classifies the raw artifacts.

Current draft-branch action counts:

| Public action | File count | Meaning |
| --- | ---: | --- |
| `private-or-sanitized-summary` | 72 | Keep raw file private by default, or replace with a reviewed summary. |
| `publish-derived-summary` | 32 | Prefer the derived publication data / result note over the raw file. |
| `public-ok` | 9 | No current scanner finding, but still review before public release. |

Current working branch expectation: strict mode is allowed to fail because the
branch still carries raw `honey` capture evidence. A public candidate branch
should either remove those raw captures, replace them with sanitized summaries,
or document why each remaining class of finding is intentional.

## Current Decision

For the Dell blog support path, public readers should land on summaries and
claim-boundary docs first. Raw host captures should not be treated as the
default public interface.
