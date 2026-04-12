# GitHub Project Setup

This repo is not GitHub-ready yet from an access perspective, but the project structure is clear enough to define the target issue and milestone setup now.

## Current status

As of April 12, 2026:

- local `origin` points to `Jesssullivan/Dell-7810`
- GitHub connector access is not available for this repo
- the GitHub app currently appears installed on `kulits`, not on `Jesssullivan/Dell-7810`
- local `gh` authentication is invalid

Implication:

- milestones, labels, and issues have not been created on the private repo yet
- repo-side templates can still be prepared locally now

## Recommended milestones

These map directly to the engineering plan already in the repo.

### M0 Project Framing

Purpose:

- repo skeleton
- research memo
- measurement workflow
- issue and GitHub operating model

Exit:

- first bench session is fully scripted

### M1 Interface Capture

Purpose:

- measure and validate OEM lower rail
- measure and validate top retention
- capture GPU and cable envelope
- print and test first interface coupons

Exit:

- lower rail, latch, rear-corner, and cable-opening coupons are based on measured data

### M2 Concept Down-Select

Purpose:

- choose shell architecture
- choose top retention strategy
- choose cable-entry hardware family
- decide whether PSU load path stays in-shell or moves to a cradle

Exit:

- one architecture is selected with no unresolved blockers

### M3 Alpha Prototype

Purpose:

- produce first metal or equivalent structural alpha
- validate install path, fit, and cable behavior

Exit:

- enclosure mounts safely and clears the real system

### M4 Beta Fabrication Package

Purpose:

- clean part modules
- generated outputs
- BOM and prototype foldback

Exit:

- package is ready for third-party quoting and iteration

## Recommended labels

Core labels:

- `measurements`
- `design`
- `research`
- `prototype`
- `documentation`
- `manufacturing`

State labels:

- `needs-data`
- `blocked`
- `ready`
- `in-progress`

Decision labels:

- `decision-latch`
- `decision-cable-entry`
- `decision-psu-support`
- `decision-shell-architecture`

## Recommended first issue set

Open these first and assign them to milestones immediately:

### M0

1. `[meta] establish GitHub milestones, labels, and issue templates`
2. `[meta] define issue taxonomy and prototype evidence rules`

### M1

1. `[measure] capture lower rail and rear interface geometry`
2. `[measure] capture top latch geometry and motion`
3. `[measure] capture GPU protrusion and connector bend envelope`
4. `[measure] capture real cable bundle envelope and preferred exit zone`
5. `[design] model lower rail fit coupon`
6. `[design] model latch fit coupon`
7. `[design] model rear-corner fit coupon`
8. `[design] model cable opening test plate`
9. `[proto] print and evaluate first interface coupon set`

### M2

1. `[design] choose P1/P2/P3 enclosure architecture`
2. `[research] shortlist cable-entry hardware for first prototype`
3. `[design] choose top retention strategy: OEM latch vs captive fasteners`
4. `[design] choose PSU support strategy: shell-aligned vs independent cradle`

### M3

1. `[design] define P1 shell blank`
2. `[design] define P2 utility cassette blank`
3. `[proto] build and review alpha enclosure`

### M4

1. `[design] generate manufacturing outputs for current prototype revision`
2. `[documentation] finalize BOM and fabrication notes`

## Recommended issue ordering

Do not open every future issue at once. Open:

- the 2 meta issues for M0
- the 4 measurement issues for M1
- the 4 coupon design issues for M1
- the 1 coupon prototype-review issue for M1

That is enough to drive the first real cycle without clutter.

## GitHub-side next actions once access is fixed

1. Install the GitHub app on `Jesssullivan/Dell-7810` or on the owning account with repo access.
2. Re-authenticate `gh`.
3. Create milestones M0 through M4.
4. Create the label set above.
5. Push the `.github/` templates from this repo.
6. Open the initial M0 and M1 issues.
