# Measurement Plan

This project will fail if the chassis interface is hand-waved. Capture the enclosure in a consistent coordinate system and treat every OEM mating feature like a production interface.

## Coordinate system

Use one chassis-fixed coordinate system for every photo, sketch, and CAD datum:

- `X`: front to rear
- `Y`: left side outward from the chassis wall
- `Z`: bottom to top

Origin:

- front-bottom-left corner of the steel chassis body,
- excluding removable feet and excluding the side cover.

If a feature is easier to reach from another orientation, still record it back into this coordinate system.

## Required tools

- digital calipers
- steel ruler or machinist scale
- tape measure
- small machinist square
- straight edge
- angle finder or digital bevel gauge
- radius gauge if available
- masking tape and fine marker for temporary datum marks
- phone or camera for photo log
- optional contour gauge and transfer punches

## Measurement rules

- Measure each critical dimension at least three times.
- Record min, max, and nominal if the feature is irregular.
- Photograph every measured interface with the tool still in frame.
- Mark which measurements are direct and which are derived.
- Do not round early; record to the tool's resolution.
- Note whether the system was populated with the GPU, risers, and cable bundle when measured.

## Session 1: global chassis cross-check

Purpose:

- confirm the physical unit matches Dell's nominal envelope closely enough,
- establish confidence in the datum system before fine work.

Capture:

- overall height, width, depth,
- foot height,
- side opening size,
- top edge and rear edge straightness,
- panel opening perimeter relative to front and rear fixed surfaces.

## Session 2: OEM mating features

This is the most important session.

Capture:

- lower tongue, rail, tab, or groove geometry across the full mating edge,
- top latch position, travel, and engagement depth,
- rear-edge overlap or hook geometry,
- any local embosses, steps, offsets, or stiffening beads that affect fit,
- material thickness of the OEM panel where it mates to the chassis.

How:

- take broad measurements first to place each feature,
- then isolate local profiles with calipers, depth probe, and photos,
- print simple paper or cardboard profile tracers if needed,
- if geometry is hard to access, create a sacrificial gauge from stiff card and transfer it back to the bench.

## Session 3: internal interference envelope

Capture the as-built modified machine, not just the stock chassis.

Capture:

- motherboard plane to outermost GPU points,
- GPU top height relative to the original side-cover plane,
- PCIe power connector protrusion and cable bend envelope,
- CPU cooler and memory shroud heights,
- fan and airflow keep-out zones,
- any protrusions from the upgraded internal PSU and its harnesses.

Record the GPU envelope as a bounding box first, then add local critical protrusions.

## Session 4: external PSU and cable routing

Capture:

- desired PSU shelf or standoff location relative to the chassis,
- candidate load paths and possible hard mounting points,
- largest cable bundle cross-section that must pass through the new opening,
- minimum practical bend radius for the GPU harness bundle,
- cable exit angle that avoids connector side load.

Measure the real cable bundle with connectors installed. Do not size this opening from nominal wire diameters alone.

## Session 5: installation/removal path

Even if the final panel no longer follows the OEM 45-degree removal path, installation still needs a defined motion.

Capture:

- whether the panel can hook at the bottom and rotate closed,
- what rear I/O, desk clearance, or cable bundle geometry blocks installation,
- how much extra top volume can be added before the panel becomes awkward to install.

## Fit-check coupons to print before metal

Print these in cheap material first:

- lower rail/tongue engagement strip,
- top latch engagement block,
- rear top corner and rear edge hook interface,
- cable pass-through bezel or slot edge coupon,
- PSU shelf mounting tab coupon if the shell will carry load.

Each coupon should isolate one interface. Avoid printing an entire side panel to prove a single small dimension.

## Recommended tolerance posture

- OEM mating coupons: bias slightly undersized first and walk up to fit.
- Structural tabs and shelves: leave machining and bend allowances explicit in the CAD parameters.
- Cable openings: prototype the trim or brush system early because "looks large enough" is a trap.

## Decision points fed by measurement data

- Can the OEM latch be reused without overloading it?
- Is the lower rail geometry simple enough to capture parametrically?
- Does the GPU require a constant-height shell or a local blister/tent?
- Can the external PSU load path be carried by the shell safely?
- Is a long brush slot better than a framed split-entry product?

## What not to do

- Do not assume mirrored dimensions where you have not measured them.
- Do not assume stamped OEM offsets are cosmetic.
- Do not merge uncertain measurements into the main CAD without tagging them as provisional.
