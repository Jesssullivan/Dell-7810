# Case Work Todo

This is the current punch list for the enclosure lane.

The repo already has a good measurement framework, but the critical gap is execution:

- `cad/openscad/lib/measured-params.scad` still has zeroes for nearly every OEM interface, GPU, cable, and PSU datum.
- `data/measurements/session-01-priority-log.csv` is still an empty shell.
- the committed STL outputs are explicitly placeholder artifacts, not validated fit coupons.

Use [`docs/measurements/printable-coupon-matrix.md`](./printable-coupon-matrix.md)
with `just fit-coupons-session-01` to keep each new coupon tied to named
feature IDs and measured parameter fields.

After every bench pass, run `just measurements-session-01-status`,
`just measurements-session-01-evidence-status`, and
`just measurements-session-01-apply-scad` before touching
`cad/openscad/lib/measured-params.scad`.

## Immediate measurement blockers

- Capture the full Session 01 set from `docs/measurements/bench-session-01.md`:
  `IF-003`, `IF-004F` through `IF-005R`, `IF-006` through `IF-015`, `GPU-002`, `GPU-006`, `GPU-007`, `CBL-001` through `CBL-003`, and `PATH-001` through `PATH-003`.
- Add the tape-marked preferred cable-opening zone so `CBL-004` and `CBL-005` stop living only as intentions.
- Record lower-rail drift front, middle, and rear instead of averaging it away into one false-clean dimension.
- Record whether the current GPU feed uses independent PCIe leads or a daisy-chained branch while the cable bundle is being measured.
- Capture at least one card-transfer profile for the rear top corner and one for the lower rail if caliper access is poor.

## Evidence hygiene that still needs to happen

- Put real photo IDs next to every measurement row in `session-01-priority-log.csv`.
- Mark every derived number as derived and name the direct inputs in the notes.
- Keep the GPU and cable harness in the as-used state until `GPU-007` and `CBL-*` are done.
- Write down the current external PSU location and cable route while the workstation is still in its real operating topology.

## Printable gaps

The current printable set is not yet good enough for data gathering:

- `rail_coupon_placeholder.stl` only represents a simplified groove/lip concept. It does not encode front/mid/rear drift, vertical datum, or material-thickness uncertainty.
- `latch_coupon_placeholder.stl` only exercises width and depth. It does not yet anchor to measured latch position, motion path, or local panel thickness.
- `rear_coupon_placeholder.stl` only captures a single depth-style notch, which is too weak for a messy compound corner.
- `cable_coupon_placeholder.stl` is a generic slot test plate. It does not yet compare actual hardware families or the preferred cutout zone.

## Next printable artifacts to model

- Lower rail coupon set:
  one strip each for front, middle, and rear, labeled with sample position and revision.
- Latch coupon family:
  at least three depth variants around the measured latch engagement so the fit can be walked in deliberately.
- Rear-corner tracing backer:
  a flat printable reference plate that mates to a transferred card profile and preserves datum orientation.
- Cable-opening test plate set:
  one long brushed-slot concept, one split-entry frame footprint, and one intentionally oversized control plate.
- Installation-path mockups:
  cardboard or foam-board templates that test `PATH-001`, `PATH-002`, and `PATH-003` before metal.

## Acceptance criteria before real shell CAD

- `measured-params.scad` has nonzero values for the lower rail, latch, rear hook, bundle width/height, and preferred cable-opening zone.
- Each coupon is tied to named feature IDs and photo evidence.
- At least one coupon revision has been physically tested for rail, latch, rear corner, and cable opening.
- The repo can explain why the chosen cable-entry direction is a long brush slot, split-entry frame, or another hardware family instead of a guess.

## After the next bench session

1. Update `data/measurements/session-01-priority-log.csv`.
2. Fold confirmed values into `cad/openscad/lib/measured-params.scad`.
3. Replace placeholder coupon geometry with measured variants.
4. Record the first printable revisions and bench results in issue-linked notes.
