# T7810 Fan Noise Study Lite

Owner issue: `TIN-468`
GitHub mirror: `#19`

This is the lightweight acoustic branch for the fan lane.

It is not meant to become a publication-grade study unless the basic support
matrix already shows that a candidate is physically and electrically viable.

## Decision rule

Do the support matrix first.

Only do the acoustic branch when:

- the stock zone is measured,
- the candidate is at least `boot-safe`,
- and there is a real decision to make between two viable options.

## Minimum equipment

- one measurement microphone with a fixed placement
- REW for SPL and spectrum capture
- stable room and host placement
- optional NUT / UPS status note if mains state or load stability matters during
  the run

## Minimum run design

Use a simple repeated layout rather than an elaborate study:

1. stock baseline run
2. candidate A run
3. candidate B run if needed

For each run, keep constant where possible:

- room
- mic position
- host orientation
- side panel / top-hat configuration
- GPU state
- tuned/kernel posture
- whether `gpu-dell-quiet` is active

## Suggested operating points

Use a small set of comparable operating points:

- idle / near-idle
- steady working state
- any fixed fan-control point that can be repeated safely

If fixed PWM or RPM control is not actually available on the tested zone, say
that plainly and record the closest reproducible host state instead.

## What to record

Use:

- [`../../data/measurements/honey-fan-noise-runs.csv`](../../data/measurements/honey-fan-noise-runs.csv)

Record at minimum:

- candidate id
- target zone
- host state
- whether `gpu-dell-quiet` was active
- SPL reading
- noise floor
- REW file or exported artifact reference
- notes about tonal noise or objectionable character

## What not to overdo

Do not spend time on:

- publication-grade microphone calibration notes
- exhaustive RPM sweep studies
- elaborate reverberation control
- repeated runs across many rooms or days

unless the fan lane has already produced a clearly worthwhile replacement path.

## Practical success condition

This acoustic branch is already useful if it can answer:

- "is the replacement obviously worse?"
- "is it materially quieter at the same practical host state?"
- "does the Dell-specific control path negate the expected acoustic gain?"
