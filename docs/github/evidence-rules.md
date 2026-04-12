# Evidence Rules

This document is the operating rulebook for GitHub issue execution on this repo.

It exists to close issue `#3`:

- https://github.com/Jesssullivan/Dell-7810/issues/3

## Core rule

No hardware-affecting issue is "done" because it sounds plausible. It is only done when the issue contains enough traceable evidence to let a future CAD or prototype step proceed without guesswork.

## Measurement issues

Applies to:

- `#4` lower rail and rear interface
- `#5` top latch geometry and motion
- `#2` GPU protrusion and bend envelope
- `#6` cable bundle and preferred exit zone

Minimum evidence:

- target feature IDs listed explicitly
- raw measurements recorded, not only conclusions
- at least one scale photo per interface feature
- notes on any uncertainty, distortion, or access limitation
- direct vs derived dimensions clearly identified

Done only if:

- the relevant CAD coupon issue can start without guessing

## Design issues

Applies to:

- `#7` lower rail coupon
- `#8` latch coupon
- `#9` rear-corner coupon
- `#10` cable opening test plate

Minimum evidence:

- link to the upstream measurement issue(s)
- named source file(s) or module(s)
- export artifact or render proof
- explicit note on what was left provisional

Done only if:

- the design can be regenerated from source
- the acceptance criteria avoid hidden hand edits

## Prototype issues

Applies to:

- `#11` first interface coupon set

Minimum evidence:

- which artifact revision was tested
- install or fit result for each coupon
- photos of fit or mismatch
- measured mismatch if the part fails
- follow-up geometry change note

Done only if:

- a concrete next CAD action is obvious from the result

## Meta issues

Applies to:

- `#1` GitHub setup
- `#3` evidence rules and taxonomy

Minimum evidence:

- repo-side files or settings actually exist
- live GitHub state matches the documented plan where applicable
- docs point to the active issue numbers, not stale assumptions

## Naming and traceability

Use these conventions in comments, notes, and commit messages when relevant:

- issue refs: `#4`, `#7`
- feature IDs: `IF-003`, `CBL-002`
- artifact names: `rail_coupon_revA.stl`
- photo names: `YYYYMMDD-s2-if-rail-front-01.jpg`

## Blocked vs done

Mark an issue blocked when:

- a required measurement cannot be captured cleanly
- the relevant hardware choice is still unresolved
- the next step would require guessed geometry

Do not close the issue to indicate "waiting on bench time." Keep it open and document the blocker.

## Preferred issue flow

1. Measurement issue closes uncertainty.
2. Design issue produces a coupon or part.
3. Prototype issue reports fit.
4. Follow-up design issue incorporates correction if needed.

## Required cross-links

Each issue comment or closeout should name the adjacent issue it unlocks:

- `#4` unlocks `#7` and contributes to `#9`
- `#5` unlocks `#8`
- `#6` unlocks `#10`
- `#7`, `#8`, `#9`, and `#10` feed `#11`
