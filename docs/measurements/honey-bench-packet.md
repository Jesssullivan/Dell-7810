# Honey Bench Packet

Primary issue lanes:

- `TIN-469` Session 01 enclosure execution
- `TIN-468` stock fan inventory and support-matrix baseline

This is the one-file packet for a productive `honey` bench window.

It is meant to combine:

- the Session 01 enclosure pass
- the first stock-fan inventory pass
- the already-generated placeholder coupon family you may want printed in
  parallel

## What to print now

Use:

- [`../../data/measurements/session-01-print-manifest.csv`](../../data/measurements/session-01-print-manifest.csv)

The current Session 01 coupon family is still placeholder geometry, but it is
useful for:

- bench handling practice
- labeling and organizing the coupon families
- checking whether the current coupon set covers the expected interfaces

Do not mistake a clean placeholder print for a validated fit.

## What to bring to the bench

- printed coupon family from the manifest
- calipers
- steel rule
- square
- tape and marker
- phone or camera
- card stock for profile transfers
- stock fan access tools if a fan must be exposed or removed for label capture

## Capture order for one efficient bench window

1. Session 01 enclosure context
   - GPU and cable envelope first
   - top latch and rear corner second
   - lower rail third
2. Stock fan inventory
   - identify the actual front/system-fan assembly
   - capture stock label, size, thickness, mount pattern, connector, header
     label, wire count, and control-path clues
3. Replacement-lane baseline
   - update the stock baseline row in the support matrix
   - do not move to Noctua fit claims yet unless the stock inventory is real

## Files to have open

- [`session-01-execution-packet.md`](session-01-execution-packet.md)
- [`session-01-result-template.md`](session-01-result-template.md)
- [`../../data/measurements/session-01-priority-log.csv`](../../data/measurements/session-01-priority-log.csv)
- [`../../data/measurements/honey-fan-inventory-template.csv`](../../data/measurements/honey-fan-inventory-template.csv)
- [`t7810-fan-support-matrix.md`](t7810-fan-support-matrix.md)
- [`../../data/measurements/honey-fan-support-matrix.csv`](../../data/measurements/honey-fan-support-matrix.csv)

## Minimum success condition

The bench window is already successful if it produces:

- nonzero Session 01 measurement rows with photo refs
- one truthful stock fan inventory row for the real front/system-fan zone
- one updated stock baseline row in the support matrix

That is enough to convert the repo from "candidate surfaces only" into
"candidate surfaces plus first real physical evidence."

## Nice-to-have, not required

- card-transfer profiles for awkward rail or rear-corner geometry
- first notes about whether the ordered Noctua models are even dimensionally
  plausible
- a blocked-result note that explicitly records why a zone could not yet be
  measured

## Do not do during this first bench window

- do not install replacement fans yet unless the stock zone is already
  inventoried
- do not run acoustic-lite work yet
- do not treat the printed placeholder coupons as proof of fit
- do not write SCAD updates without running the existing status/evidence/apply
  path
