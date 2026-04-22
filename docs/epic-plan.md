# Dell 7810 Top-Hat Epic Plan

## Objective

Design a replacement side/top enclosure for the Dell Precision Tower 7810 that:

- restores electrical and dust protection after removal of the OEM hinged side cover,
- creates headroom for oversized modern GPUs,
- provides a robust cable exit path for external power and peripherals,
- supports an elevated modular PSU or an external-PSU-adjacent mounting strategy,
- and yields a vendor-ready fabrication package built around laser-cut and bent sheet parts.

## Current system reality

The target chassis is already operating outside Dell's intended envelope:

- internal PSU upgraded from the stock 685/825 W class to a higher-power Dell unit,
- secondary modular PSU mounted externally and bridged into the system,
- current maximum draw estimated around 2300 W,
- OEM cover and hinge path removed to clear a large GPU,
- open chassis now presents dust, shock, and accidental-contact hazards.

This means the project is not a cosmetic side panel. It is an enclosure, mechanical integration, and serviceability project around a high-power modified workstation.

## Platform-risk note as of April 22, 2026

The workstation now has an additional prerequisite risk beyond enclosure geometry:

- `honey` has exhibited a bad reset path where warm-reboot or degraded display probing can lose connector state and push the RX 9070 into an unhealthy recovery state
- a manual hard reset restored both the Dell HDMI management display and the headset display path immediately
- this points to a likely interaction between the proprietary Dell power path, the external ATX assist path, and GPU reset or resume behavior

Implication:

- a full electrical redesign is still not the primary goal of this repo
- but bounded power-sequencing and recovery-architecture research is now in scope because it directly affects whether the modified chassis can serve as a stable development and validation surface

## Success criteria

- A closed enclosure can be installed and removed repeatably without forcing the chassis.
- The chosen GPU envelope clears the replacement shell with measured margin.
- Cable routing through the new panel does not chafe insulation or overload connector bend radii.
- The PSU support strategy survives handling, transport, and cable strain without panel distortion.
- Fabrication outputs can be quoted by a laser-cut/bent-sheet vendor without manual redraw.
- At least one alpha prototype is validated with 3D-printed fit coupons before metal.

## Non-goals for the first milestone

- Full electrical redesign of the workstation power architecture.
- Formal compliance or safety certification.
- Noise optimization.
- A universal panel for every Dell Precision tower variant.

## Workstreams

## 1. Interface capture

- Model the OEM cover interface, especially the lower tongue/groove and latch engagement.
- Measure the side opening perimeter, rear edge relationship, and top corner radii.
- Capture the current GPU and cable interference envelope in chassis coordinates.

## 2. Enclosure architecture

- Choose between a single folded shell, multi-piece shell, or shell plus bolt-on PSU outrigger.
- Decide whether the panel should remain quick-release or move to a hybrid quick-release plus screw-retained scheme.
- Decide where the large cable pass-through belongs: upper side, upper rear-side corner, or rear extension.

## 3. DFM and fabrication

- Pick initial material and thickness.
- Define which bends are mandatory versus which interfaces should be broken into separate parts.
- Keep laser-generated flat patterns and bend assumptions reproducible from source.

## 4. Prototype validation

- Print coupons for every OEM mating feature before full-shell metal.
- Build low-cost flat-pattern mockups in cardboard or thin plastic to validate access and cable sweep.
- Build a first metal alpha only after latch and rail coupons pass.

## Decision gates

## Gate A: OEM latch reuse

Pass if:

- latch engagement point is measurable and repeatable,
- printed coupons snap in and release cleanly,
- the added shell height does not create excessive moment load on the latch.

Fallback:

- reuse only the lower rail geometry and add hidden screws or captive thumbscrews at the top.

## Gate B: PSU support strategy

Options:

- shell-mounted elevated PSU shelf,
- separate external PSU bracket that keys off the shell,
- freestanding PSU cradle with only cable integration in the shell.

The shell-mounted option should be rejected if the panel would become a structural cantilever with poor transport robustness.

## Gate C: Cable pass-through strategy

Options:

- integrated brushed opening in a custom cutout,
- commercial split brush plate,
- modular sealed cable-entry frame instead of brushes.

Decision inputs:

- maximum connector cross-section,
- desired dust performance,
- serviceability after cables are already terminated,
- part cost and ease of replacement.

## Gate D: Shell architecture

Options:

- one-piece bent shell,
- top shell plus side wall,
- top shell plus removable cable/PSU cassette.

The architecture should bias toward manufacturability and field service, not elegance at all costs.

## Proposed milestone sequence

## M0. Project framing

Deliverables:

- this plan,
- measurement plan,
- research memo,
- repo scaffold.

Exit criteria:

- datums are defined,
- next measurement session is fully scripted.

## M1. Chassis interface capture

Deliverables:

- measurement log with photos,
- OpenSCAD datum model,
- first latch/rail/rear-edge coupons.

Exit criteria:

- OEM interface is reproduced well enough for printed fit checks.

## M2. Concept down-select

Deliverables:

- 2-3 enclosure concepts scored against serviceability, rigidity, airflow, and manufacturability,
- selected architecture with explicit rationale,
- candidate cable pass-through hardware shortlist.

Exit criteria:

- one concept is chosen with no unresolved blockers on PSU placement or cable routing.

## M3. Alpha mechanical prototype

Deliverables:

- laser-cut and bent alpha part package,
- assembly notes,
- installed alpha unit with recorded interferences and thermal observations.

Exit criteria:

- panel mounts safely,
- GPU and cable clearances are real,
- no critical access feature is blocked.

## M4. Beta fabrication package

Deliverables:

- cleaned OpenSCAD source,
- generated DXF/STL/STEP/PDF outputs,
- BOM for purchased pass-through hardware and fasteners,
- prototype findings folded back into the model.

Exit criteria:

- package is quote-ready for a third-party fabricator.

## Measurement-first deliverables

The next physical session should capture:

- full chassis envelope cross-check,
- OEM cover mating geometry,
- GPU highest-point and widest-point envelope,
- external PSU target envelope and cable bend radii,
- candidate cable pass-through cutout zones,
- rear and top access constraints during installation/removal.

Use the measurement plan and do not skip the photo log. The photos are part of the geometry record.
