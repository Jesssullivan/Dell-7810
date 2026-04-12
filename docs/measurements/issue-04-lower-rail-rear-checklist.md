# Issue 04 Checklist

Target issue:

- https://github.com/Jesssullivan/Dell-7810/issues/4

This checklist is intentionally narrower than `bench-session-01.md`. It exists to finish issue `#4` with no ambiguity about what must be measured and what evidence is required.

## Scope

Primary target feature IDs:

- `IF-003`
- `IF-004`
- `IF-005`
- `IF-006`
- `IF-007`
- `IF-013`
- `IF-014`

Secondary supporting IDs:

- `IF-016`
- `PATH-001`

## Required tools

- digital calipers
- steel rule
- machinist square
- masking tape and fine marker
- phone or camera
- index card or thin cardboard for profile transfer

## Pass / fail rule

Issue `#4` is not complete unless:

- every primary target feature ID has either a measured value or a stated reason it could not be captured,
- each interface zone has at least one usable scale photo,
- lower rail geometry is described well enough to start issue `#7`,
- rear corner geometry is described well enough to start issue `#9`.

## Execution sequence

## 1. Context photos

Take before fine measurements:

- full lower rail, front-to-rear
- rear top corner overall
- rear edge overlap or hook overall

Do not move on until these exist.

## 2. Lower rail broad placement

Capture:

- `IF-003`
- `IF-006`

Method:

- measure total usable engagement length along the rail
- measure rail vertical offset from chassis bottom datum
- repeat each at least three times

Evidence required:

- one full-length rail photo with ruler
- one datum photo showing where the bottom reference was taken

## 3. Lower rail local profile

Capture:

- `IF-004`
- `IF-005`
- `IF-007`

Method:

- take front, center, and rear profile readings if accessible
- if calipers cannot reach cleanly, make a card transfer and photograph it flat with scale
- note any front-to-rear drift instead of averaging it away

Evidence required:

- one close-up profile photo with scale
- one note describing whether the profile is constant or varying

## 4. Rear edge and rear top corner

Capture:

- `IF-013`
- `IF-014`

Method:

- measure rear overlap or hook depth directly if possible
- create a card transfer for the rear top corner if the geometry is compound or obstructed

Evidence required:

- one rear-corner photo with scale
- one transferred profile photo if the corner is not trivially rectangular

## 5. Supporting stamped geometry

Capture:

- `IF-016`

Method:

- look for beads, steps, or offsets near the lower rail and rear edge that would interfere with a flat coupon assumption

Evidence required:

- one photo showing the offset with a scale reference

## 6. Hook-in path sanity check

Capture:

- `PATH-001`

Method:

- use a simple cardboard strip to test how a replacement panel would engage the lower rail before rotating upward

Evidence required:

- one photo or note explaining where the motion would bind first

## Required outputs

After the bench session, update:

- `data/measurements/session-01-priority-log.csv`
- `cad/openscad/lib/measured-params.scad` for clean values only
- issue `#4` with a comment summarizing evidence and remaining uncertainty

## Handoff

Issue `#4` unlocks:

- `#7` lower rail fit coupon
- `#9` rear-corner fit coupon

If either interface remains uncertain, do not advance both. Split the handoff by certainty.
