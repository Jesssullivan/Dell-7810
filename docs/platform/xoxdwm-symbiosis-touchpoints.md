# Dell-7810 / XoxdWM Symbiosis Touchpoints

This note is narrower than the authority map.

It answers:

- where the two repos are supposed to touch,
- what kind of data is allowed to cross that boundary,
- and what should happen when a host-facing fact changes.

Use this with:

- [`authority-map.md`](authority-map.md)
- [`xoxdwm-boundary-audit.md`](xoxdwm-boundary-audit.md)
- [`../tracking/measured-evidence-map.md`](../tracking/measured-evidence-map.md)
- [`../tracking/rt-smi-numa-chapel-focus-2026-04-25.md`](../tracking/rt-smi-numa-chapel-focus-2026-04-25.md)

## Short rule

`Dell-7810` owns raw host evidence.

`XoxdWM` owns downstream software proofs that may depend on that host state.

The touchpoint is therefore:

- raw evidence and host-safe summaries flow out of Dell-7810,
- downstream software claims in `XoxdWM` point back to that evidence,
- boot and deployment operations do not get copied into Dell-7810 just because
  they mention `honey`.

## Stable touchpoints

| Touchpoint | Dell-7810 role | XoxdWM role | Rule |
| --- | --- | --- | --- |
| reset, power, display recovery | canonical raw evidence | cite only when XR work depends on it | do not restate raw rows in `XoxdWM` |
| BIOS, SMI, kernel posture | canonical host validation | summarize current host assumptions in support/proof docs | every host-posture claim should be link-backed |
| fan behavior and thermal-control quirks | canonical stock-fan and replacement evidence | consume only if GPU/XR work is affected | keep raw fan inventory and support matrix in Dell-7810 |
| NUMA host inventory and host probes | canonical host-characterization results | consume as host assumptions for application work | keep application-side BCI results in `XoxdWM` |
| boot topology and deployment state | summarize only the host-safe outcome | canonical operational source | keep Dhall boot generations and storage migration in `XoxdWM` |
| XR runtime and compositor proofs | out of scope except for host preconditions | canonical | Dell may reference preconditions only |

## What should happen when a host-facing fact changes

1. Update the raw evidence in Dell-7810 first.
2. Update the Dell host-facing summary next.
3. Update any `XoxdWM` software-facing summary that depends on the changed fact.

That means:

- BIOS or kernel-posture changes start here
- new reset-path evidence starts here
- stock fan or replacement-fan findings start here
- `XoxdWM` follows after the Dell-side evidence exists

## Fan-specific touchpoint

The fan lane is now an explicit symbiosis case:

- Dell-7810 owns stock fan inventory, replacement support status, acoustic
  notes, and any control-path validation
- `XoxdWM` may continue to carry the `gpu-dell-quiet` operational workaround,
  because that is a running-host mitigation used during software work

The split is:

- "what does the T7810 fan system actually do?" belongs here
- "what workaround do I apply during XR/software operation?" may stay there

If the fan-replacement lane produces a result that changes whether
`gpu-dell-quiet` is still needed, the update order should be:

1. Dell raw evidence
2. Dell summary docs
3. `XoxdWM` operational note or recipe

## Derived-fork touchpoint rule

There are still derived-fork surfaces across the repos.

When one changes:

- update the Dell-facing provenance note if the change affects host behavior
- update the `XoxdWM` copy only if its software or operational role still
  requires that copy
- do not let a convenience copy become the quieter "real" source by accident

The current derived-fork inventory remains the one reported by:

- `just platform-xoxdwm-duplication-status`

## Operator-wrapper touchpoint rule

`XoxdWM` may keep `honey` convenience wrappers when they are part of the live
XR/operator flow. Examples include `just smi-validate` and
`just bios-tuned-deploy`, which already prefer the Dell-owned validator or tuned
profile when the sibling repo is present.

That wrapper pattern is acceptable only if:

- the wrapper clearly names the Dell-owned source when it uses one
- raw measurement output is copied back into Dell-7810 if it becomes evidence
- the Dell-owned script, profile, or runbook remains the place to change host
  validation behavior
- the XoxDWM wrapper remains operational glue rather than a second evidence
  ledger

## Current weak touchpoints

These are still structurally weak and should be handled carefully:

- fan findings, because the repo now has candidate models but not measured stock
  fan inventory yet
- enclosure findings, because Session 01 is still unmeasured
- RT benefit interpretation, because Dell now has generic and RT Chapel repeat
  packets but the result is cautionary rather than a downstream software win

## Immediate follow-on discipline

- any new `XoxdWM` statement about `honey` fan behavior should link back to the
  Dell fan support matrix once it exists
- any new Dell host-facing result that software depends on should identify the
  likely `XoxdWM` consumer surface
- any new `XoxdWM` statement about RT benefit should link back to
  [`../publication/rt-benefit-decision-framework-2026-04-26.md`](../publication/rt-benefit-decision-framework-2026-04-26.md)
  and then provide its own C4 frame/deadline evidence
- do not create second copies of stock-fan inventories, support matrices, or
  acoustic run logs in `XoxdWM`
