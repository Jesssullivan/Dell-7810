# T7810 Fan And Airflow Prior Art -- 2026-04-22

Owner issue: `TIN-396`
GitHub mirror: `#16`

This note started as a local-repo prior-art consolidation. It now also carries a
small external-source appendix for the specific front-fan / Noctua question so
the repo stops over-claiming what is actually known.

The active execution surfaces for this lane now live in:

- [`../measurements/t7810-fan-support-matrix.md`](../measurements/t7810-fan-support-matrix.md)
- [`../measurements/t7810-fan-noise-study-lite.md`](../measurements/t7810-fan-noise-study-lite.md)
- `data/measurements/honey-fan-support-matrix.csv`
- `data/measurements/honey-fan-noise-runs.csv`

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

## 3. External sources that constrain the claim surface

Three outside sources matter enough to shape the Dell-side wording:

1. Dell's T7810 owner's manual confirms that the machine has a removable
   system-fan assembly and multiple board fan connectors, including
   `HDD1 fan`, `system-fan`, and `system-fan 1` connectors. That is useful
   because it confirms serviceability and multiple fan/control zones, but it
   does **not** publish a clean consumer-facing "just buy this 120 mm fan"
   answer.
2. Noctua's OEM-system FAQ explicitly warns that Dell systems often use
   proprietary headers, pin alignments, or control methods and that Noctua does
   not officially support Dell systems as drop-in fan targets.
3. Parts-market listings repeatedly associate the T5810/T7810/T7910 family with
   at least one Foxconn `PVA120K12N-P01` `12V 0.90A` `120 x 120 x 38 mm`
   `4-wire` fan. That is useful as a sourcing clue, but it is still weaker than
   a measured `honey` inventory and should not be treated as final fit truth.

What this means in practice:

- "the T7810 definitely uses a generic retail 120 x 25 mm front fan" is too
  strong
- "the T7810 has a serviceable fan assembly and the parts market strongly hints
  at at least one 120 x 38 mm OEM fan in the family" is defensible
- "Noctua should drop in directly" is not defensible yet

## 4. What the local repo constellation does not currently provide

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

- treat standard `120 x 120 x 25 mm` `4-pin PWM` fans as the first aftermarket
  candidate family, not as a proven OEM dimensional match
- treat Noctua `NF-F12 PWM`, Noctua `NF-P12 redux-1700 PWM`, and ARCTIC
  `P12 PWM PST` as the local first-pass candidates because there is already
  nearby documentation for them
- treat `be quiet!` as an explicit research gap, not an implied peer that is
  already validated in the local docs
- keep stock Dell fans and Dell headers outside the aftermarket-PWM authority
  lane until their connectors, pinouts, and control model are measured

The safest first front-fan story for this repo is therefore:

- stock front-fan geometry and wiring must be measured on `honey`
- aftermarket 120 mm PWM candidates may still be prepared in parallel
- but adapter and control assumptions cannot be treated as settled until the
  stock inventory is real

## What this repo still needs to capture

Before the Dell repo can claim a proper 7810 fan-mod authority surface, it still
needs:

- a zone-by-zone inventory of every current fan in `honey`
- which zone is actually the front intake / system-fan assembly versus CPU or
  other local fan surfaces
- physical dimensions for each stock fan position
- thickness and mount-pattern measurements for each stock fan position
- connector family, wire count, power source, and tach / PWM availability for
  each stock fan
- header label and verified pin order for each stock fan
- whether the motherboard, BMC, or another Dell control path owns each fan zone
- which fan zones are affected by the third-party GPU alarm behavior
- whether a front-bank standard-PWM lane can coexist with the current Dell
  control path or needs a separate adapter / splitter strategy

Use:

- `data/measurements/honey-fan-inventory-template.csv`
- `data/measurements/honey-fan-support-matrix.csv`

as the first structured capture surface instead of freehand notes.

## Recommended next captures

1. Record the actual `honey` fan inventory:
   location, quantity, stock label, size, thickness, mount pattern, connector,
   header label, wire count, and control source.
2. Capture whether `gpu-dell-quiet` is still required after the latest BIOS and
   kernel posture changes.
3. Verify whether the stock front-fan assembly actually corresponds to the
   `120 x 120 x 38 mm` vendor-market clue or something narrower.
4. Verify whether the front-fan zone can ever be treated as standard PWM
   electrically, or whether it always needs an adapter / isolated control path.
5. Decide whether the first aftermarket target is:
   front intake only, rear exhaust only, or a broader mixed-fan strategy.
6. If a standard-PWM lane is pursued, validate at least:
   Noctua `NF-F12 PWM`, Noctua `NF-P12 redux-1700 PWM`, and ARCTIC
   `P12 PWM PST`.
7. Add one explicit `be quiet!` candidate only after a real local measurement
   or sourcing note exists.

## Provenance

Primary local and external sources for this note:

- `../XoxdWM/packaging/scripts/gpu-monitor`
- `../XoxdWM/justfile`
- `../server-fan-splitter-pcb/docs/`
- `../server-fan-splitter-pcb/published/releases/v0.1-evt-a0-r15/docs/`
- Dell Precision Tower 7810 Owner's Manual:
  `https://dl.dell.com/content/manual26064352-dell-precision-tower-7810-owner-s-manual.pdf?language=en-us`
- Noctua OEM-system compatibility FAQ:
  `https://www.noctua.at/en/support/faqs/can-i-use-noctua-fans-in-my-system-from-acer-apple-dell-hp-lenovo-or-other-major-brands`
- Noctua PWM white paper:
  `https://noctua.at/pub/media/wysiwyg/Noctua_PWM_specifications_white_paper.pdf`
- Noctua `NF-P12 redux-1700 PWM` specifications:
  `https://www.noctua.at/en/products/nf-p12-redux-1700-pwm/specifications`
- Dell / Foxconn fan-market clues:
  `https://www.serverworlds.com/dell-8pxm2-precision-t5810-t7810-t7910-cooling-fan-pva120k12n-p01/`
  and
  `https://www.pchub.com/foxconn-pva120k12n-p01-server-round-fan-pva120k12n-p01-p212366`
