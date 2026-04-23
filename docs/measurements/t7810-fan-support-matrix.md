# T7810 Fan Support Matrix

Owner issue: `TIN-468`
GitHub mirror: `#19`

This is the working support matrix for stock-fan capture and candidate
replacement validation on `honey`.

It is intentionally lighter than a formal acoustic study.

The primary question is:

- can a candidate fan be fitted and operated safely enough on the Dell 7810 to
  deserve ongoing use?

The secondary question is optional:

- is the candidate acoustically better enough to justify the change?

Use the CSV at:

- [`../../data/measurements/honey-fan-support-matrix.csv`](../../data/measurements/honey-fan-support-matrix.csv)

as the machine-readable row surface.

## Status model

Each candidate should advance through these gates:

1. `identified`
   model is known and worth testing
2. `inventory-blocked`
   stock fan zone or control path is still not measured well enough
3. `dim-fit`
   physical size, thickness, and mount pattern look plausible
4. `electrical`
   connector, pinout, tach/PWM posture, and control ownership are understood
5. `boot-safe`
   host boots and the fan operates without immediate failure or instability
6. `alarm-safe`
   Dell fan alarms, GPU-triggered noise behavior, and control-path regressions
   are understood or absent
7. `acoustic-lite`
   optional REW / mic comparison captured
8. `supported`
   enough evidence exists to write a cautious repo recommendation

Do not skip from `identified` to `supported`.

## Minimum support gates

A fan candidate should not be treated as supported until all of the following
are true:

- the target stock zone has been inventoried
- the candidate physically fits or the adapter/mount path is explicit
- the electrical/control path is understood
- the host boots safely with the candidate installed
- Dell-specific alarm or fan-ramp behavior is checked

Acoustic work is optional and should happen after those support gates.

## Initial candidate set

The current first-pass matrix should at least carry:

- stock Dell system/front fan baseline
- Noctua `NF-F12 PWM`
- Noctua `NF-P12 redux-1700 PWM`
- any additional user-owned candidates as separate rows

## Recommended execution order

1. Fill the stock fan inventory first:
   use [`../../data/measurements/honey-fan-inventory-template.csv`](../../data/measurements/honey-fan-inventory-template.csv)
2. Add or confirm the target replacement rows in the support matrix CSV.
3. Run dimensional and electrical gates before any acoustic comparison.
4. Capture acoustic-lite runs only for candidates that survive the support
   gates.

## Evidence expectations

Each matrix update should point at at least one of:

- photo-backed inventory notes
- stock or candidate dimensional measurements
- BIOS / host capture notes if fan control behavior changes
- acoustic run logs if noise work is attempted

## Cross-repo rule

If `XoxdWM` still needs `gpu-dell-quiet` or another operational fan workaround,
that is a downstream consumer of this matrix, not a replacement for it.
