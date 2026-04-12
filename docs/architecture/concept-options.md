# Concept Options

This document turns the abstract epic into concrete enclosure architectures. The goal is not to pick the prettiest model. The goal is to choose the concept with the best path through fit validation, fabrication, and safe serviceability.

## Design drivers

- oversized GPU clears the original side-cover plane,
- cable bundle may include bulky terminated connectors,
- external or elevated PSU integration adds real load and cable strain,
- OEM bottom rail interface is valuable if reusable,
- OEM top latch is attractive only if it survives the increased panel moment,
- the pass-through opening should not destroy primary bend integrity.

## Concept A: single-shell monocoque top-hat

Description:

- one main bent shell covers the original side opening and grows upward into a tent or wedge,
- cable pass-through is cut directly into the shell,
- optional PSU shelf is formed or bolted directly into the same shell.

Strengths:

- minimal part count,
- visually clean,
- easiest to understand in CAD.

Weaknesses:

- high structural demand on the main shell,
- long bends and large cutouts compete for the same sheet area,
- if the OEM top latch is reused, the new shell height increases leverage,
- any geometry mistake forces a rework of the entire shell.

Best use:

- only if the external PSU is decoupled from the shell and the cable opening can stay well away from major bends.

## Concept B: base shell plus removable utility cassette

Description:

- a primary shell handles chassis closure, fit, and general dust barrier,
- a secondary cassette or module carries the cable pass-through and optional PSU-adjacent hardware,
- the cassette bolts to the main shell and can be revised independently.

Strengths:

- separates chassis mating risk from utility-feature risk,
- lets the cable opening live in a flatter, more fabrication-friendly zone,
- supports multiple iterations of cable-entry hardware without scrapping the whole shell,
- offers a migration path from brush slot to split cable-entry frame,
- reduces the chance that the primary shell becomes a structural cantilever for the PSU.

Weaknesses:

- more parts and seams,
- more fasteners,
- requires deliberate seam design for stiffness and dust control.

Best use:

- strongest first-build architecture for this project.

## Concept C: exoshell frame with secondary skins

Description:

- a more structural outer frame references the OEM lower interface and possibly rear fasteners,
- separate top and side skins close the shape,
- external PSU mounts to the frame, not the skin.

Strengths:

- best structural path for a heavy or awkward PSU arrangement,
- skins can stay light and replaceable,
- easiest concept to evolve into a family of variants.

Weaknesses:

- most complex mechanically,
- highest part count,
- highest coordination cost between frame, skins, and OEM interface.

Best use:

- only if the PSU must physically ride on the enclosure and the utility cassette approach proves too weak.

## Decision matrix

Scores are 1-5 where 5 is best.

| Criterion | A Monocoque | B Shell + Cassette | C Exoshell + Skins |
| --- | --- | --- | --- |
| OEM fit-risk isolation | 2 | 5 | 4 |
| Cable-entry flexibility | 2 | 5 | 4 |
| PSU load-path safety | 2 | 4 | 5 |
| Fabrication simplicity | 4 | 3 | 2 |
| Prototype iteration speed | 2 | 5 | 3 |
| Serviceability | 3 | 5 | 4 |
| Overall first-milestone suitability | 2 | 5 | 3 |

## Recommendation

Recommend Concept B for M1-M3:

- main shell reuses the OEM lower rail first,
- top retention is validated separately and may end up as either the OEM latch or captive fasteners,
- utility cassette becomes the experimental zone for cable entry and PSU-adjacent features,
- if the PSU proves too heavy for shell-supported mounting, the cassette remains useful while the PSU moves to an independent cradle or bracket.

This keeps the hardest unknowns from piling into one sheet-metal part.

## Proposed physical split

## Part P1: chassis shell

- responsible for OEM fit,
- closes the open side and top volume,
- contains only the bends and interfaces needed to define the enclosure.

## Part P2: utility cassette

- mounts to P1 with captive hardware,
- contains the large cable opening and any brush/split-entry hardware,
- may also carry a light shelf, strain-relief bracket, or alignment fence for the external PSU.

## Part P3: PSU cradle or outrigger, optional

- independent load path if the PSU weight or cable pull would distort P1/P2,
- keys to P2 for alignment but does not rely on thin shell metal for primary strength.

## Decision triggers

Move from B to C if:

- the external PSU must be fully carried by the enclosure,
- cable pull or transport load clearly distorts the shell concept,
- or the chassis only offers safe retention if load is spread across multiple reinforced points.

Move from OEM latch reuse to captive fasteners if:

- latch location is hard to capture cleanly,
- printed latch coupons show inconsistent snap-in behavior,
- or the added shell height creates enough leverage to make the latch feel abusive.

## Manufacturing posture

- keep P1 bends conservative and away from the largest cutouts,
- make P2 the panel most likely to change between prototype rounds,
- preserve one-part-per-file export discipline for flat patterns.

## Immediate modeling order

1. lower rail and rear edge interface coupons,
2. top retention coupon,
3. P1 envelope shell,
4. P2 utility cassette blank panel,
5. cable-entry hardware variants inside P2,
6. optional P3 PSU support.
