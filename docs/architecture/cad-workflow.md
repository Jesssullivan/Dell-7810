# CAD Workflow

This repo should borrow the clarity of Voron-style open hardware repos without blindly copying printer-specific conventions.

## External references

- Voron Tap repository structure:
  https://github.com/VoronDesign/Voron-Tap
- OpenSCAD documentation:
  https://openscad.org/documentation
- BOSL2 tutorials and library docs:
  https://github.com/revarbat/BOSL2/wiki/Tutorials
- NopSCADlib project:
  https://github.com/nophead/NopSCADlib
- SendCutSend getting started:
  https://sendcutsend.com/guidelines/getting-started/

## What to copy from Voron-style repos

Useful patterns from the public Voron Tap structure:

- clear separation between source CAD, released STLs, documentation, images, and BOM,
- human-readable top-level docs,
- generated artifacts committed only when they correspond to a known design revision.

That suggests the right end-state here is:

- source CAD under `cad/`,
- manufacturing outputs under `output/`,
- visual references under `images/` later,
- manuals and assembly notes under `docs/`,
- BOM at the top level once the COTS shortlist stabilizes.

## Recommended OpenSCAD paradigm

Use OpenSCAD as the geometry source of truth, with four layers:

## 1. documented constants

- OEM published dimensions and fabrication defaults,
- used only until measured values replace them.

## 2. measured parameters

- chassis interface values captured from the real machine,
- stored separately so uncertain data is easy to audit.

## 3. parts

- individual manufacturable parts,
- one module per part,
- explicit material thickness and bend assumptions.

## 4. assemblies

- reference-only models that show fit, envelopes, and installed relationships.

This means no part should exist only inside an assembly module.

## Recommended library posture

### BOSL2

Good fit for:

- attachments and relative positioning,
- path/region operations,
- shaped masks, chamfers, and more expressive geometry helpers.

Why it fits this project:

- the enclosure will likely benefit from attachable reference geometry, path-driven cutouts, and cleaner module composition than raw OpenSCAD alone.

Use it selectively. Do not make the repo depend on BOSL2 before the core interfaces are measured and stable.

### NopSCADlib

Good fit for:

- standard hardware modeling,
- BOM generation support,
- assembly views and repeatable exports.

Why it is not the core geometry library here:

- this project is sheet-metal-first, not printed-parts-first,
- the chassis fit problem is custom geometry, not a library-parts problem.

Recommendation:

- keep NopSCADlib optional for later COTS modeling and documentation, not required for the first milestone.

## Modeling rules

- Keep 2D cut profiles explicit wherever possible.
- Derive 3D shell concepts from flat or profile logic rather than ad hoc boolean sculpting.
- Keep one source module per manufactured part.
- Keep fit coupons separate from production parts.
- Treat vendor hardware footprints as imported or referenced envelopes, not hand-waved rectangles.

## Export rules

SendCutSend's current public guidance says they accept 2D vector files such as DXF and 3D files such as STEP/STP, in 1:1 scale, with one part per file.

That means:

- one manufactured part per export file,
- no mixed assemblies in vendor deliverables,
- no hand-edited DXF,
- bend notes and flat-pattern assumptions must be reproducible from source.

## Suggested near-term repo evolution

Short term:

- keep the current `cad/openscad/lib` and `cad/openscad/src` split,
- add `cad/openscad/src/parts` and `cad/openscad/src/assemblies` when the first real part modules exist,
- add `images/` once printed coupons or installed prototypes exist.

Medium term:

- add `output/dxf` and `output/pdf` generation targets,
- add a release-style folder naming convention for prototype drops,
- add a BOM revision table.

## Recommended first real CAD targets

1. `part_lower_rail_coupon`
2. `part_latch_coupon`
3. `part_rear_edge_coupon`
4. `part_p1_shell_blank`
5. `part_p2_utility_cassette_blank`
6. `asm_chassis_plus_shell`
7. `asm_shell_plus_utility_cassette`
