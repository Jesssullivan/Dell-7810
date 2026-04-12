# Measurement Log Template

Use one table per session and keep photo filenames alongside the numbers.

| Session | Feature ID | Description | Datum Reference | Tool | Reading 1 | Reading 2 | Reading 3 | Nominal | Direct or Derived | Photo | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| M1 | IF-001 | Example: lower rail overall length | X from origin | Calipers | 0 | 0 | 0 | 0 | Direct | IMG_0000 | Replace example row |

## Suggested feature ID groups

- `ENV-*`: global envelope
- `IF-*`: OEM interface
- `GPU-*`: internal interference
- `PSU-*`: PSU support and bracket
- `CBL-*`: cable bundle and pass-through
- `PATH-*`: installation path and removal sweep

## Photo naming

Use deterministic names so the CAD notes can cite them:

- `YYYYMMDD-session-feature-seq.jpg`
- example: `20260412-m2-if-rail-01.jpg`

## Derived dimensions

If a dimension is calculated from two direct measurements, write the formula in Notes. Derived numbers without traceability will become rework later.
