# Measured Evidence Map

Last updated: 2026-04-25.

This note answers a narrower question than the authority map:

- what has actually been measured or captured,
- what is still only scaffold or prior art,
- and which repo is allowed to summarize those results versus own the raw
  evidence.

Use this together with:

- [`../platform/authority-map.md`](../platform/authority-map.md) for repo ownership
- [`../platform/xoxdwm-boundary-audit.md`](../platform/xoxdwm-boundary-audit.md)
  for boundary policy
- [`workstream-status-2026-04-22.md`](workstream-status-2026-04-22.md) for the
  broader status narrative

## Short read

- Dell-7810 now has real measured host evidence for `honey`:
  reset behavior, BIOS posture, bounded SMI samples, tracefs `hwlat`,
  kernel-baseline closure, and NUMA inventory.
- Dell-7810 does not yet have real enclosure geometry measurements:
  Session 01 is still `0 / 29`.
- Dell-7810 does not yet have a real 7810 fan-mod evidence lane:
  there is prior art and candidate documentation, but no zone-by-zone fan
  inventory, no connector mapping, and no validated Noctua fit or control path.
- `XoxdWM` may summarize workstation results when XR work depends on them, but
  it should not become the raw measurement authority for Dell-7810 host facts.

## Measured and captured in Dell-7810

| Surface | Status | Canonical path | Notes |
| --- | --- | --- | --- |
| Historical T7810 SMI baseline | measured, historical | [`../platform/t7810-smi-baseline.md`](../platform/t7810-smi-baseline.md) | Imported from `XoxdWM`, but canonical here going forward |
| `honey` reset and display recovery | measured | [`../research/honey-reset-matrix-2026-04-22.md`](../research/honey-reset-matrix-2026-04-22.md) | Real dated reset-path evidence |
| `honey` power and multi-PSU posture | measured / researched | [`../research/honey-power-reset-and-multi-psu-2026-04-22.md`](../research/honey-power-reset-and-multi-psu-2026-04-22.md) | Real wiring and recovery observations, still incomplete as a full inventory |
| `honey` live baseline | measured | [`../platform/honey-live-baseline-2026-04-22.md`](../platform/honey-live-baseline-2026-04-22.md) | Repo-owned summary of the April 22 live host state |
| BIOS export and machine check | measured | `data/captures/honey/bios-*.cctk`, `data/captures/honey/bios-check-*.txt` | Legacy DCC evidence, not guessed posture |
| Current SMI samples | measured | `data/captures/honey/smi-validate-*.txt`, [`../platform/honey-generic-smi-hwlat-series-2026-04-25.md`](../platform/honey-generic-smi-hwlat-series-2026-04-25.md) | Multiple bounded runs exist in this repo; the 2026-04-25 generic series uses repeated 30s windows |
| Current `hwlat` samples | measured | `data/captures/honey/smi-validate-*.txt`, [`../platform/honey-generic-smi-hwlat-series-2026-04-25.md`](../platform/honey-generic-smi-hwlat-series-2026-04-25.md) | Captured through the tracefs `hwlat` fallback in the Dell-owned validator |
| Generic low-latency kernel posture | measured | `data/captures/honey/kernel-baseline-*.txt` | Generic lane now closes against the Dell baseline artifacts |
| NUMA host inventory | measured | `data/captures/honey/numa-baseline-2026-04-22.json`, [`../../dhall/defaults/honey-host-inventory-2026-04-22.dhall`](../../dhall/defaults/honey-host-inventory-2026-04-22.dhall) | Real live capture, then projected into records |
| Live Chapel host probe on generic lane | measured | `data/captures/honey/chapel-host-probe-baseline.txt`, `data/captures/honey/chapel-host-probe-turnkey.txt`, `data/captures/honey/chapel-host-probe-generic-2026-04-25.txt`, [`../../dhall/defaults/honey-chapel-host-probe-baseline-2026-04-23.dhall`](../../dhall/defaults/honey-chapel-host-probe-baseline-2026-04-23.dhall), [`../../dhall/defaults/honey-chapel-host-probe-generic-2026-04-25.dhall`](../../dhall/defaults/honey-chapel-host-probe-generic-2026-04-25.dhall) | Real live generic-lane result plus same-evening store-prebuilt capture; under the current `CHPL_LOCALE_MODEL=flat` posture, `Sublocales: 0` is consistent with Chapel's locale model docs |

## Not yet measured in Dell-7810

| Surface | Status | Current path | Blocker |
| --- | --- | --- | --- |
| Session 01 enclosure geometry | unmeasured | `data/measurements/session-01-priority-log.csv` | Bench execution has not happened yet |
| Measured coupon revisions | unmeasured | `output/stl/` | Current coupons are placeholders only |
| OEM interface SCAD params | mostly unmeasured | `cad/openscad/lib/measured-params.scad` | Waiting on Session 01 |
| `honey` fan inventory | unmeasured | `data/measurements/honey-fan-inventory-template.csv` | No zone-by-zone inventory yet |
| 7810 front-fan replacement fit | unmeasured | [`../research/t7810-fan-and-airflow-prior-art-2026-04-22.md`](../research/t7810-fan-and-airflow-prior-art-2026-04-22.md) | No stock-size or mount-pattern measurements on `honey` yet |
| Noctua or other aftermarket validation on 7810 | unmeasured | same prior-art note | No live connector, control, or thermal validation yet |
| PREEMPT_RT Chapel host probe result | unmeasured | `docs/platform/` + future capture files | Generic-lane probe now exists; RT-lane Chapel result is the next live follow-on |

## What XoxdWM may summarize but should not own as raw measurement truth

| XoxdWM surface | Allowed role | Not allowed role |
| --- | --- | --- |
| `docs/support-matrix.md` `honey` rows | software-facing summary of host state | source of truth for raw BIOS, SMI, reset, or NUMA measurements |
| `docs/honey-substrate-proof-2026-04-22.md` | downstream XR proof that depends on a prepared host | replacement for the Dell raw host evidence |
| `packaging/dhall/defaults/honey-*.dhall` | operational boot-entry truth | measurement ledger for the workstation hardware |
| `analysis/src/bci/` modules | application-side workload code that happens to target the T7810 | proof that the host itself is characterized |

The practical rule is:

- if the artifact is a raw host capture, bench measurement, photo-backed
  geometry record, BIOS export, SMI sample, or host inventory record, keep it
  in Dell-7810
- if the artifact is a software proof that consumes that host state, it may
  live in `XoxdWM`

## Current cross-repo boundary issues

1. Ownership is clearer than measurement completion. The Dell repo now owns the
   host evidence lane, but the enclosure lane and fan-mod lane are still mostly
   unmeasured.
2. `XoxdWM` still carries five derived-fork surfaces, which is acceptable for
   now but means provenance discipline still matters.
3. `XoxdWM` application analysis code still mentions the T7810 heavily in
   comments and examples; that is fine, but it should not be mistaken for host
   measurement authority.
4. The Dell repo still needs one explicit enclosure execution issue and one
   Dell-owned Chapel live-results issue if planning is to line up with the
   evidence surfaces.

## Immediate next evidence-producing work

1. Execute Session 01 and turn the enclosure lane into real geometry evidence.
2. Fill the `honey` fan inventory template with real stock fan, connector, and
   control-path measurements before claiming any 7810 front-fan mod posture.
3. Keep `XoxdWM` on summary-only references for host facts unless a new live XR
   result truly depends on a fresh Dell-side measurement.
4. Use `TIN-468` and the fan support matrix surfaces for candidate validation
   rather than letting ordered fan parts turn into untracked bench drift.
