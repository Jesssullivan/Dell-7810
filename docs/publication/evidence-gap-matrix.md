# Evidence Gap Matrix

This note turns the publication plan into a readiness check.

Use it before drafting a paper, presentation, or abstract.

Status meanings:

- `ready`: the repo already has enough material to support a scoped draft
- `partial`: the framing exists, but the evidence is still incomplete
- `blocked`: do not write this as a result yet

## Section readiness

| Section or claim block | Status | Existing repo support | Missing evidence |
| --- | --- | --- | --- |
| introduction and scope boundary | `ready` | publication notes, boundary audit, workstream status, research memos | none |
| platform context and modification rationale | `partial` | README, extant-art note, reset/power memo | filled power-path inventory, cleaner host inventory |
| measurement-first enclosure method | `ready` for methods, `blocked` for results | measurement plan, bench session, coupon matrix, SCAD apply and evidence scripts | real Session 01 measurements, fit results, measured coupon revisions |
| reset and host-platform methodology | `ready` for methods, `partial` for results | reset matrix, host-kernel docs, capture scripts, historical SMI baseline | fresh reset rows, filled BIOS record, current SMI/hwlat run |
| Chapel and PBT method story | `ready` for methods | analysis modules, tests, publication framing | none for method framing |
| Chapel / NUMA host results | `partial` | generic-lane repeat series, first RT-lane `HostNumaProbe`, matching RT Chapel-only repeat, raw captures, and Dhall records exist | stronger NUMA claims still need a decision on Chapel execution model; RT improvement is not established |
| enclosure results | `blocked` | placeholder coupons and measurement workflow | real bench measurements and fit outcomes |
| integrated host baseline table | `partial` | config fragments, tuned profile, reset docs | live BIOS settings, host inventory, current kernel validation |
| discussion of downstream XR, audio, or application context | `partial` | narrative lane rules, boundary docs, and [`rt-benefit-decision-framework-2026-04-26.md`](rt-benefit-decision-framework-2026-04-26.md) | real XR/audio/BCI benefit claims still need downstream C4 packets outside this host-results ledger |

## Figure readiness

| Figure candidate | Status | Existing repo support | Missing evidence |
| --- | --- | --- | --- |
| platform overview figure | `partial` | README, research memo, likely existing machine photos outside repo process | curated labeled photo set for publication use |
| measurement workflow diagram | `ready` | measurement docs, scripts, coupon matrix | optional polish only |
| repo boundary diagram | `ready` | boundary audit, duplication status, publication notes | optional polish only |
| host-method flow diagram | `ready` | reset matrix, kernel docs, Chapel/PBT lane docs | optional polish only |
| coupon result figure | `blocked` | placeholder STLs exist | real measured print iterations and bench photos |
| reset result timeline figure | `partial` | April 22 reset matrix exists | additional controlled runs |
| NUMA / Chapel result figure | `ready` for cautionary result, `blocked` for improvement result | generic-lane repeat series, first RT-lane host probe, and matching RT Chapel-only repeat exist | downstream benefit or quieter-load rerun before presenting RT as useful |

## Table readiness

| Table candidate | Status | Existing repo support | Missing evidence |
| --- | --- | --- | --- |
| feature ID to coupon family table | `ready` | printable coupon matrix | none |
| boundary table: host baseline vs XR overlay | `ready` | kernel-lane doc, boundary audit | none |
| duplication status table | `ready` | duplication status script and note | none |
| reset matrix summary table | `partial` | April 22 matrix exists | more rows from controlled runs |
| host baseline validation table | `partial` | kernel fragments and scripts exist | actual run outputs from `honey` |
| Chapel proof surface table | `ready` | analysis source and tests | none |
| measured enclosure interface table | `blocked` | feature register exists | Session 01 values |

## Most valuable missing evidence

If the goal is to strengthen publication readiness fastest, the best evidence
to gather next is:

1. full Session 01 measurements with photo refs and notes
2. one current `honey` host capture bundle:
   BIOS check, NUMA capture, SMI/hwlat run, reset-state capture
3. downstream audio/BCI/XR packet that tests whether RT changes real deadlines
   rather than host-characterization ratios
4. fresh `quickchpl` run output for paper tables that should cite live test
   execution instead of only source inspection
5. one curated labeled photo set for the modified workstation and printable
   coupon lane

## Writing-safe guidance

Until the blocked items above are cleared:

- write methods confidently,
- write scope and boundary sections confidently,
- write results cautiously or not at all,
- and do not promote placeholder artifacts into empirical findings.
