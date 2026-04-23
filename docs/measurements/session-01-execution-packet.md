# Session 01 Execution Packet

Owner issue: `TIN-469`
GitHub mirror: `#20`

This is the short operational packet for the first real enclosure measurement
pass.

Use this instead of re-reading the full measurement tree while standing at the
bench.

The detailed method still lives in:

- [`bench-session-01.md`](bench-session-01.md)
- [`printable-coupon-matrix.md`](printable-coupon-matrix.md)
- [`photo-shot-list.md`](photo-shot-list.md)

## Goal

Turn the enclosure lane from process scaffolding into first real geometry
evidence.

Success means:

- `session-01-priority-log.csv` is no longer `0 / 29`
- every measured row has photo refs or notes
- the repo can produce the first evidence-backed coupon or printable revision

## Bench kit

- calipers
- steel rule
- square
- tape / marker
- phone or camera
- card stock for profile transfers

## Required files before starting

- [`../../data/measurements/session-01-priority-log.csv`](../../data/measurements/session-01-priority-log.csv)
- [`photo-shot-list.md`](photo-shot-list.md)
- [`../../data/measurements/feature-register.csv`](../../data/measurements/feature-register.csv)

## Capture order

1. Upright context:
   `GPU-002`, `GPU-006`, `GPU-007`, `CBL-001..005`, `PATH-003`
2. Upright top/rear:
   `IF-008..015`, `PATH-002`
3. Side-down lower rail:
   `IF-003..007`, `IF-016`, `PATH-001`
4. Bench-side tracers:
   rear corner and lower rail profiles if direct numeric reads are weak

## Minimum discipline

- no guessed numbers
- no averaged-away stamped geometry
- no photo-less "I’ll remember it" rows
- no SCAD writes on incomplete evidence

## Post-session command path

Run in this order:

```bash
just measurements-session-01-status
just measurements-session-01-evidence-status
just measurements-session-01-scad-preview
just measurements-session-01-apply-scad
```

Only if the dry run is clean:

```bash
just measurements-session-01-apply-scad-write
```

## Expected repo outputs

- updated `data/measurements/session-01-priority-log.csv`
- photo refs for every measured row
- a short result note using
  [`session-01-result-template.md`](session-01-result-template.md)
- first evidence-backed coupon or explicit blocked-result note

## Decision rule

If the session ends with useful evidence but still not enough geometry for a
real coupon revision, record the blocked result explicitly.

`TIN-469` still counts as progress if it replaces silence with a truthful
evidence-backed blocker.
