# T7810 Fan And Airflow Prior Art -- 2026-04-22

Owner issue: `TIN-396`
GitHub mirror: `#16`

This note is a local-repo prior-art consolidation, not a general internet
survey.

Its job is to answer a narrower question:

- what fan-control and aftermarket-airflow work already exists in the local
  repo constellation,
- what parts of that work are actually relevant to a Dell Precision Tower 7810,
- and what still needs to be measured here before this repo can claim an
  authority surface for 7810 fan modification.

## Local prior art that already exists

## 1. Stock Dell chassis fan behavior on `honey`

The only clearly Dell-7810-specific fan-control artifact found in sibling repos
today is the `dell-quiet` path in:

- `../XoxdWM/packaging/scripts/gpu-monitor`
- `../XoxdWM/justfile` via `just gpu-dell-quiet honey`

That script records an important real-world fact for this workstation:

- the T7810 ramps chassis fans in response to an unrecognized third-party GPU
  such as the RX 9070 XT
- there is a working `ipmitool raw ...` path that suppresses that response
- the suppression is not persistent across BIOS update or AC power loss

That means the repo already has one real fan-related authority seam:

- Dell stock fan policy and alarm behavior are part of workstation validation,
  not just case cosmetics

## 2. Aftermarket standard PWM fan path

The strongest local aftermarket-fan prior art is not in `XoxdWM`; it is in the
adjacent `../server-fan-splitter-pcb` project.

That repo is not a T7810 project, but it does capture useful reusable evidence
for a standard `4-pin PWM` fan lane:

- a compatibility gate that explicitly targets standard PC `4-pin PWM` fans
- rejection of stock peripheral-powered chassis fans, `2-wire`, `3-wire`, and
  unknown high-current server fans
- a passive splitter path using one motherboard PWM header and three fan outputs
- long-run cable strategy for a front fan wall / cable-transition layout

Relevant local candidate fan families from that repo:

| Fan family | Local prior art | Current role |
| --- | --- | --- |
| Noctua `NF-F12 PWM` | explicit compatibility candidate | premium low-current validation set |
| Noctua `NF-P12 redux-1700 PWM` | explicit compatibility candidate | slightly higher-current validation set |
| ARCTIC `P12 PWM PST` | explicit compatibility candidate | budget validation set |
| Noctua `NA-SEC3` | explicit extension-set reference | `3x 600 mm` PWM extension baseline |

Connector and cable-side prior art from the same repo:

- Molex `47053-1000` as the board-side male header family
- Molex `47054-1000` as the matching cable housing family
- one-tach-only splitter behavior as the expected motherboard-monitoring model
- routing assumptions for a fan-wall or cable-transition mounting position

## 3. What the local repo constellation does not currently provide

The local search did not find the following:

- any `be quiet!` fan-family evaluation
- any Dell 7810-specific mapping of stock fan part numbers
- any Dell 7810-specific mapping of stock fan connector families
- any recorded 7810 motherboard fan-header current limit
- any recorded adapter path from Dell stock fan wiring to standard aftermarket
  PWM fans
- any measured statement about which 7810 fan zones are practical to replace
  without breaking thermal monitoring or firmware behavior

That absence matters. It means this repo should not currently talk as if
Noctua, ARCTIC, or `be quiet!` support on the 7810 is already validated.

## Practical boundary for this repo

Dell-7810 should own two separate but related fan surfaces:

1. stock Dell fan-control behavior on the modified workstation
2. aftermarket standard-PWM fan adaptation candidates for enclosure work

Those are not the same problem.

The first is already evidenced by the `gpu-monitor` / `dell-quiet` behavior.
The second is still mostly at the "adjacent reusable art" stage.

## Current candidate aftermarket lane

If this repo wants a first bounded aftermarket lane without pretending more than
it knows, the safest starting posture is:

- treat standard `120 x 120 x 25 mm` `4-pin PWM` fans as the first candidate
  family
- treat Noctua `NF-F12 PWM`, Noctua `NF-P12 redux-1700 PWM`, and ARCTIC
  `P12 PWM PST` as the local first-pass candidates because there is already
  nearby documentation for them
- treat `be quiet!` as an explicit research gap, not an implied peer that is
  already validated in the local docs
- keep stock Dell peripheral-powered fans outside the aftermarket-PWM authority
  lane until their connectors and control model are measured

## What this repo still needs to capture

Before the Dell repo can claim a proper 7810 fan-mod authority surface, it still
needs:

- a zone-by-zone inventory of every current fan in `honey`
- physical dimensions for each stock fan position
- connector family, wire count, power source, and tach / PWM availability for
  each stock fan
- whether the motherboard, BMC, or another Dell control path owns each fan zone
- which fan zones are affected by the third-party GPU alarm behavior
- whether a front-bank standard-PWM lane can coexist with the current Dell
  control path or needs a separate adapter / splitter strategy

Use:

- `data/measurements/honey-fan-inventory-template.csv`

as the first structured capture surface instead of freehand notes.

## Recommended next captures

1. Record the actual `honey` fan inventory:
   location, quantity, size, connector, wire count, and control source.
2. Capture whether `gpu-dell-quiet` is still required after the latest BIOS and
   kernel posture changes.
3. Decide whether the first aftermarket target is:
   front intake only, rear exhaust only, or a broader mixed-fan strategy.
4. If a standard-PWM lane is pursued, validate at least:
   Noctua `NF-F12 PWM`, Noctua `NF-P12 redux-1700 PWM`, and ARCTIC
   `P12 PWM PST`.
5. Add one explicit `be quiet!` candidate only after a real local measurement
   or sourcing note exists.

## Provenance

Primary local sources for this note:

- `../XoxdWM/packaging/scripts/gpu-monitor`
- `../XoxdWM/justfile`
- `../server-fan-splitter-pcb/docs/`
- `../server-fan-splitter-pcb/published/releases/v0.1-evt-a0-r15/docs/`
