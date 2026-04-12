# Bench Session 01

This is the first serious measurement pass. Its job is not to capture everything. Its job is to capture enough high-confidence geometry to decide:

- whether the OEM lower rail can be reused,
- whether the OEM top latch is worth preserving,
- how much GPU-driven overbuild the shell actually needs,
- and whether the cable opening wants a brush slot or a split-entry frame.

## GitHub issue mapping

- `#4`: lower rail and rear interface geometry
- `#5`: top latch geometry and motion
- `#2`: GPU protrusion and connector bend envelope
- `#6`: cable bundle and preferred exit zone

Use this session to close measurement uncertainty for those issues, not just to gather notes.

## Session objective

At the end of this session you should be able to populate:

- `IF-003` through `IF-014`
- `GPU-002`, `GPU-006`, `GPU-007`
- `CBL-001` through `CBL-003`
- `PATH-001`, `PATH-002`, `PATH-003`

If those are captured cleanly, the next CAD pass can produce real interface coupons instead of placeholders.

## Safety and staging

- Shut the workstation fully down.
- Disconnect AC power from both power supplies.
- Wait for fans and indicator lights to fully stop.
- Give yourself enough bench space to rotate the chassis without dragging cables.
- Keep the GPU and current external PSU wiring in the as-used state until the cable and interference photos are done.

Do not probe around a live or recently powered high-power dual-PSU system. This session is measurement, not live validation.

## Required tools on the bench

- digital calipers
- steel rule
- tape measure
- machinist square
- masking tape
- fine marker
- phone or camera
- cardboard strips or index card for tracing inaccessible profiles

## Orientation plan

The handling order below is deliberate. It minimizes flipping the machine back and forth.

## Orientation A: normal upright, open side facing you

Purpose:

- capture the global photo record,
- capture GPU overbuild and cable behavior before disturbing anything,
- mark provisional pass-through zones with tape.

Do now:

1. Take all global and context photos from the photo shot list.
2. Capture `GPU-002`, `GPU-006`, `GPU-007` for issue `#2`.
3. Capture `CBL-001`, `CBL-002`, `CBL-003` with the real cable bundle in a realistic routed condition for issue `#6`.
4. Mark one or two likely cable-exit zones with masking tape and photograph them.
5. Record `PATH-003` using a cardboard or foam mockup to test maximum practical top volume before the shape becomes obnoxious.

Notes:

- `GPU-002` is one of the most important numbers in the project. Do not estimate it from memory or visuals.
- For the cable bundle, measure the compressed envelope you are actually willing to route, not the absolute maximum you can force by crushing it.

## Orientation B: same upright position, zoom into top retention and rear corner

Purpose:

- capture top latch and rear-edge relationships while the chassis is still upright and easy to sight.

Do now:

1. Capture `IF-008` and `IF-009` from the chassis datum for issue `#5`.
2. Capture `IF-010` and `IF-011` at the top latch for issue `#5`.
3. Photograph latch motion for `IF-012` for issue `#5`.
4. Capture `IF-013` and `IF-014` at the rear top corner and rear edge for issue `#4`.
5. Record `PATH-002` by mocking the install/removal sweep against current desk or wall clearance.

Notes:

- If the latch geometry is hard to read directly, prioritize photos with scale and card gauges over forced caliper readings.

## Orientation C: lay chassis on the non-open side

Purpose:

- expose the lower rail and underside-facing interface features in the easiest measuring posture.

Protect the finish and avoid side-loading the GPU while rotating the chassis.

Do now:

1. Capture `IF-003`, `IF-004`, `IF-005`, `IF-006`, `IF-007` for issue `#4`.
2. Capture any obvious step, bead, or offset for `IF-016` for issue `#4`.
3. Test the hook-in motion concept with cardboard and record `PATH-001` as supporting evidence for issue `#4`.

Notes:

- Measure the lower rail front, middle, and rear. If the geometry drifts, keep the drift in the notes instead of averaging it away.
- If there is a formed lip or groove that is hard to reach, use card stock or tape as a transfer profile and photograph that profile on the bench next to a ruler.

## Orientation D: bench-side profile tracing

Purpose:

- convert awkward interface features into something that can drive a coupon.

Do now:

1. Make one simple card or stiff-paper transfer of the rear top corner profile if `IF-014` is messy.
2. Make one simple card or stiff-paper transfer of the lower rail profile if the groove geometry is not easy to describe numerically.
3. Photograph those tracers flat on the bench with a ruler and labels.

## Completion standard

This session is complete only if:

- all priority rows in `session-01-priority-log.csv` have either values or an explicit note explaining why the value could not be captured,
- every interface feature has at least one usable photo with scale,
- and you can point to a credible next coupon for rail, latch, rear corner, and cable opening.

## Expected outputs

- updated `data/measurements/session-01-priority-log.csv`
- updated `docs/measurements/measurement-log-template.md` or a working copy derived from it
- labeled photos
- one short note summarizing where the geometry is still uncertain
- GitHub comments on issues `#4`, `#5`, `#2`, and `#6` once the evidence is in hand

## Failure modes to avoid

- measuring the GPU after unplugging or rerouting the cables and then pretending the reading reflects the real installed state,
- averaging away irregular stamped geometry,
- taking context photos without scale,
- and letting “close enough” numbers into the latch or lower-rail interfaces.
