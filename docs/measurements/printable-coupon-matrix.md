# Printable Coupon Matrix

This matrix connects Session 01 bench work to the specific measured parameters
and coupon families that should be printed next.

Use it to avoid two common failures:

- collecting measurements that never land in CAD, and
- printing coupons that are not traceable to named feature IDs.

## Session 01 printable set

| Coupon family | Primary feature IDs | Measured parameter targets | Output variants to print | Why this family exists |
| --- | --- | --- | --- | --- |
| Lower rail strips | `IF-003`, `IF-004F`, `IF-004M`, `IF-004R`, `IF-005F`, `IF-005M`, `IF-005R`, `IF-006`, `IF-007`, `IF-016` | `measured_lower_rail_length`, `measured_lower_rail_lip_depth_*`, `measured_lower_rail_groove_width_*`, `measured_lower_rail_z_offset`, `measured_lower_rail_thickness` | `rail_front`, `rail_mid`, `rail_rear` | Forces front/mid/rear drift to stay visible instead of being averaged into one fake-clean rail |
| Latch sweep | `IF-008`, `IF-009`, `IF-010`, `IF-011`, `IF-012`, `IF-015` | `measured_latch_x`, `measured_latch_z`, `measured_latch_depth`, `measured_latch_feature_width`, `measured_oem_panel_thickness_latch_zone` | `latch_depth_minus`, `latch_depth_nominal`, `latch_depth_plus` | Walks latch fit in deliberately around the measured engagement depth instead of trusting one nominal notch |
| Rear corner notch | `IF-013`, `IF-014` | `measured_rear_hook_depth` | `rear_notch` | Tests whether the rear keying depth is even close before a full corner shape is modeled |
| Rear tracing backer | `IF-014` | card-transfer profile plus photo evidence | `rear_backer` | Preserves datum orientation for a transferred card profile when the rear top corner is too messy for pure caliper capture |
| Cable opening family | `GPU-006`, `GPU-007`, `CBL-001`, `CBL-002`, `CBL-003`, `CBL-004`, `CBL-005` | `measured_bundle_width`, `measured_bundle_height`, `measured_largest_connector_diagonal`, `measured_preferred_cable_opening_x`, `measured_preferred_cable_opening_z`, `measured_preferred_cable_opening_width`, `measured_preferred_cable_opening_height` | `cable_brush`, `cable_split`, `cable_control` | Compares opening families against the real harness rather than arguing from visuals |
| Install path mockups | `PATH-001`, `PATH-002`, `PATH-003` | no SCAD parameter should be trusted until mockups exist | cardboard or foam-board only | Prevents shell height and hook geometry from outrunning install reality |

## Coupon command path

The coupon generator now supports a Session 01 family recipe:

```bash
just fit-coupons-session-01
just measurements-session-01-status
just measurements-session-01-evidence-status
just measurements-session-01-scad-preview
just measurements-session-01-apply-scad
```

That recipe currently generates local placeholder meshes. Public candidate
branches keep these outputs out of Git by default; the OpenSCAD source, recipe,
and print manifest are the reviewable authority until a measured or built
revision is intentionally promoted.

- `output/stl/rail_front_coupon_placeholder.stl`
- `output/stl/rail_mid_coupon_placeholder.stl`
- `output/stl/rail_rear_coupon_placeholder.stl`
- `output/stl/latch_depth_minus_coupon_placeholder.stl`
- `output/stl/latch_depth_nominal_coupon_placeholder.stl`
- `output/stl/latch_depth_plus_coupon_placeholder.stl`
- `output/stl/rear_notch_coupon_placeholder.stl`
- `output/stl/rear_backer_coupon_placeholder.stl`
- `output/stl/cable_brush_coupon_placeholder.stl`
- `output/stl/cable_split_coupon_placeholder.stl`
- `output/stl/cable_control_coupon_placeholder.stl`

They are still intentionally provisional until the measurement fields above stop
being zeroes.

Each coupon now carries an embossed family/variant/status code on the print
itself, such as `R-F PH`, `L-0 PH`, or `C-B M`, so bench photos and failed fit
attempts are easier to trace back to the right STL.

`measurements-session-01-evidence-status` is the photo-and-notes gate. It tells
you whether measured rows actually have usable evidence attached rather than
placeholder refs.

`measurements-session-01-scad-preview` is the bridge back into
`cad/openscad/lib/measured-params.scad`. It only trusts `nominal_mm` or a
single direct reading, and leaves ambiguous rows at `0` on purpose.

`measurements-session-01-apply-scad` is the safe dry-run. It shows the unified
diff that would be applied to `measured-params.scad`, but only for confirmed
assignments. Incomplete rows do not get written back as zeroes. Use
`just measurements-session-01-apply-scad-write` only after the status and
evidence checks look sane. The write path now refuses to run if measured rows
are missing real photo refs or notes.

## Evidence requirements per print

Every printed coupon revision should cite:

- the feature IDs it is intended to validate,
- the parameter names and values used to generate it,
- the photo IDs or card-transfer IDs that justify those values,
- and the outcome of the physical fit attempt.

## Minimum handoff standard before shell CAD

- rail family printed and at least one front/mid/rear coupon tested,
- latch family printed and one depth direction ruled out by evidence,
- rear notch and rear backer both tied to `IF-014` evidence,
- cable family compared against the real harness in the preferred opening zone,
- install-path mockups recorded before the shell height is treated as real.
