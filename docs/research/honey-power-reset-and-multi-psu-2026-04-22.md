# Honey Power Reset And Multi-PSU Research - 2026-04-22

## Scope

This note captures the workstation-side power and reset behavior now blocking `honey` as a reliable BCI/XR development surface.

Repo boundary:

- `Jesssullivan/Dell-7810` owns chassis, power, enclosure, and workstation-specific hardware research.
- `Jesssullivan/XoxdWM` owns compositor, VR stack, packaging, and software validation.

This is not a full electrical redesign brief. It is a bounded research memo for the Dell Precision 7810 power architecture, reset behavior, and likely next design paths.

## April 22, 2026 evidence

### Failed state before manual hard reset

Observed live on `honey` during the April 22 investigation:

- all DRM connectors initially reported either `disconnected` or `unknown`
- probing `DP-2` in the degraded state produced:
  - `No EDID found on connector: DP-2`
  - `sdma0 timeout`
  - `device lost from bus`
  - failed GPU recovery
- earlier boot and resume logs also showed:
  - `Cannot find any crtc or sizes`
  - `Failed to exit BACO state`
  - SMU resume failures
- while the host was degraded, remote access split oddly:
  - Tailscale and public path behavior became unhealthy
  - direct LAN TCP/22 on the `honey` management LAN address still answered OpenSSH
  - SSH auth on that LAN path stalled after publickey offer instead of completing

Interpretation:

- the workstation was not simply "off"
- the GPU and host were in a partially alive but unhealthy reset / resume state
- the failure cut across display detection, GPU recovery, and host operability

### Healthy state after manual hard reset

After a hard manual reset, the Dell HDMI display immediately regained link and the workstation returned to a clean boot:

- boot time: `2026-04-22 01:19 EDT`
- `HDMI-A-2`: `connected`, `enabled`, `dpms=On`, `1920x1080` modes present
- `DP-2`: `connected`, `256`-byte EDID present, modes `5088x2544` and `3840x1920`
- EDID headers identified the two active paths cleanly:
  - `HDMI-A-2`: Dell vendor bytes `10 ac`
  - `DP-2`: Bigscreen path bytes `09 27 34 12`
- this boot did not show the earlier bad markers:
  - no `Cannot find any crtc or sizes`
  - no `No EDID found on connector: DP-2`
  - no `sdma0 timeout`
  - no `device lost from bus`

Interpretation:

- the GPU, Dell display path, and headset display path can coexist on this hardware
- the immediate blocker is not basic topology feasibility
- the failure is in reset sequencing, power behavior, or both

## Source-backed constraints

### Dell official constraints

Dell's T7810 spec sheet says the platform officially supports:

- `685W` or `825W` PSUs
- up to `300W` total graphics with the `825W` PSU

Sources:

- Dell Precision Tower 7810 technical specification:
  - https://i.dell.com/sites/doccontent/shared-content/data-sheets/en/Documents/Precision_Tower_7000_Series_7810_Spec_Sheet.pdf

Implication:

- the current `honey` build is outside Dell's intended power and graphics envelope
- any stable solution has to assume the platform power path is being extended beyond OEM assumptions

### Dell community evidence on distribution boards and rails

Dell community threads indicate:

- the `1300W` PSU uses a different power-distribution board than the `685W` or `825W` setups
- the `T5810/T7810` distribution board does not appear to expose all of the rail groups available from the `1300W` PSU
- the `T7910` board is the one associated with fuller `1300W` use and more direct GPU power connectivity

Sources:

- Precision T7810 PSU Upgrade:
  - https://www.dell.com/community/en/conversations/precision-fixed-workstations/precision-t7810-psu-upgrade/647f8e69f4ccf8a8def4a0a2
- T7810 with 1300W power supply:
  - https://www.dell.com/community/en/conversations/precision-fixed-workstations/t7810-with-1300w-power-supply/647f8ec1f4ccf8a8defb471f
- Dell T7810 / 7610 / 5810 10pin CPU connection to 8pin PCIe:
  - https://www.dell.com/community/en/conversations/precision-fixed-workstations/dell-t7810-7610-5810-10pin-cpu-connection-to-8pin-pcie/647f9837f4ccf8a8deb5002d

Implication:

- there is a real chance the present topology is rail-imbalanced or reset-fragile even if it works under steady state
- a serious redesign option is not just "bigger PSU", but "different distribution-board strategy"

### GPU-side power expectations

AMD's March 2025 quick reference guide lists the RX 9070 XT at:

- `304W` total board power
- `750W` recommended PSU
- `2x8-pin` required power connectors

Source:

- AMD Radeon RX 9000 Series quick reference guide:
  - https://www.amd.com/content/dam/amd/en/documents/partner-hub/radeon/radeon-rx-9000-series-quick-reference-guide-non-competitive.pdf

Implication:

- the GPU is firmly in the class where weak cabling, marginal rail allocation, or reset-path current transients are credible failure contributors
- any pigtailed or ambiguous GPU feed should be treated as suspect until disproven

April 26 addendum:

- AMD's reference-level page and quick reference describe the RX 9070 XT as a
  `2x8-pin` card, but board-partner models differ.
- ASUS Prime Radeon RX 9070 XT OC lists `3 x 8-pin` and a `750W` recommended
  PSU.
- Gigabyte Radeon RX 9070 XT Gaming OC lists `8 pin*3` and an `850W`
  recommended PSU.
- `honey` should therefore treat the installed 9070 XT as a `3x8-pin`
  auxiliary-power card until the exact board label and connector photo are
  recorded.

Sources:

- AMD Radeon RX 9070 XT product page:
  - https://www.amd.com/en/products/graphics/desktops/radeon/9000-series/amd-radeon-rx-9070xt.html
- ASUS Prime Radeon RX 9070 XT OC tech specs:
  - https://www.asus.com/us/motherboards-components/graphics-cards/prime/prime-rx9070xt-o16g/techspec/
- Gigabyte Radeon RX 9070 XT Gaming OC specs:
  - https://www.gigabyte.com/us/Graphics-Card/GV-R9070XTGAMING-OC-16GD/sp

Working conclusion:

- A 3x8-pin board should be powered by three connector feeds that are real,
  rated, and traceable back to the supplying PSU or distribution board.
- A chain such as proprietary Dell VGA header -> intermediate adapter ->
  PCIe adapter may physically fit, but it is not evidence of an electrically
  acceptable feed.
- If the T7810 distribution board exposes only one credible GPU auxiliary
  output in the current chassis, keep using the external ATX GPU supply until
  the board, cable, and rail contract are measured or redesigned.
- The 1300W Dell PSU brick alone does not solve this; the limiting object is
  the T7810 power-distribution board and cable breakout.

Do not treat any CPU/EPS, SATA, Molex, or undocumented 4-pin/mini-fit output as
PCIe GPU power unless the pinout, wire gauge, connector rating, over-current
behavior, and rail source are documented. EPS and PCIe 8-pin connectors are
not interchangeable even when plastic keying can be adapted.

### ATX control-signal constraints

Intel's ATX design guide defines:

- `PS_ON#` as an active-low motherboard control signal
- `PWR_OK` as the signal that rails are within regulation and power is good

Sources:

- Intel ATX Version 3.0 design guide, `PS_ON#`:
  - https://edc.intel.com/content/www/us/en/design/ipla/software-development-platforms/client/platforms/alder-lake-desktop/atx-version-3-0-multi-rail-desktop-platform-power-supply-design-guide/2.0/ps-on-required/
- Intel ATX Version 3.0 design guide, `PWR_OK`:
  - https://edc.intel.com/content/www/us/en/design/ipla/software-development-platforms/client/platforms/alder-lake-desktop/atx-version-3-0-multi-rail-desktop-platform-power-supply-design-guide/2.0/2.1a/pwr-ok-required/

Implication:

- if an external ATX PSU is being coordinated with a proprietary Dell primary, proper control should be built around explicit enable / good-state signaling
- "secondary PSU comes up because a rail happens to appear live" is a weak architecture compared with deliberate sync logic

### Add2PSU assumptions

The Add2PSU manual describes a relay board that:

- expects a standard ATX `24-pin` secondary PSU connection
- senses primary-PSU activity from a `4-pin Molex` feed
- turns the secondary PSU on and off in sync with the primary

Source:

- Add2PSU user manual:
  - https://manuals.plus/asin/B0711WX9MC

Implication:

- Add2PSU-class boards are designed around commodity ATX-primary assumptions
- they may still be useful as a design reference, but not as proof that the current Dell-primary / external-ATX arrangement is electrically well-defined

## Working hypotheses

### H1. Warm reboot is leaving the GPU or display path in a bad resume state

Evidence:

- `Failed to exit BACO state`
- SMU resume failure logs
- bad-state display probing on the previous boot
- hard reset immediately cleared the condition

This is currently the strongest software-plus-firmware explanation.

### H2. The external ATX assist path is not reset-safe under the current sequencing

Evidence:

- the build is outside OEM power assumptions
- the T7810 board and distribution path appear rail-constrained compared with larger Dell workstation variants
- the failure clears only when power is broken hard enough to fully reset the platform

This is currently the strongest power-architecture explanation.

### H3. The workstation needs a management-display lane independent of XR bring-up

Evidence:

- once the Dell monitor returned, the workstation became much easier to trust as a host again
- the headset display path and the HDMI management path can coexist in the healthy boot

This does not prove a separate management GPU is required, but it strongly argues for a deliberate recovery-display design.

## Design options now worth tracking

## 1. Harden the current dual-PSU structure

Required:

- verify the 9070 power feed uses three separate, rated PCIe power leads, not
  a daisy-chained branch or adapter chain from one Dell header
- document exactly how the external ATX PSU is currently started and what rails it serves
- test whether a stable sync board or signal-cleanup path can make warm reboot reliable

Pros:

- lowest mechanical disruption
- may solve the problem if sequencing and wiring are the real faults

Cons:

- still depends on non-OEM topology
- may leave the workstation with fragile recovery characteristics

## 2. Build a daughterboard or signal-conversion path

Concept:

- derive an ATX-safe secondary enable path from a stable Dell-primary signal or power-good condition
- avoid crude passive hacks that assume Dell proprietary behavior matches standard ATX timing

Pros:

- keeps the existing mechanical power concept
- gives a cleaner contract between proprietary and ATX domains

Cons:

- requires board-level design, verification, and bench instrumentation
- wrong assumptions here could be destructive

## 3. Revisit the Dell distribution-board strategy

Concept:

- evaluate whether a T7910-style board and associated wiring path is the right long-term way to expose more honest GPU power within Dell's ecosystem
- evaluate whether a purpose-built T5810/T7810 distribution-card upgrade or a
  T7910-derived harness can expose enough independent, rated PCIe feeds for a
  3x8-pin card without external ATX assistance

Pros:

- could reduce custom interconnect work
- may align better with Dell workstation rail distribution

Cons:

- nontrivial swap effort
- unclear mechanical and harness compatibility until measured
- still unsafe to assume without pinout, rail, and cable-rating proof

## 4. Add a management-display recovery lane

Concept:

- keep the Dell HDMI display as the deliberate recovery path
- optionally move to a separate low-power management GPU if same-GPU recovery remains too fragile

Pros:

- fastest path to keeping `honey` operable as a workstation
- avoids conflating "XR render path" with "host is recoverable"

Cons:

- may not solve the root power/reset defect
- a second GPU adds slot, thermal, and cable pressure

## Recommended next experiments

1. Preserve the current healthy boot as the baseline:
   - record connector state
   - record `journalctl -k -b` amdgpu / DRM lines
   - record exact cabling and which PSU feeds which loads

2. Verify GPU cabling:
   - confirm the exact RX 9070 XT board model and whether it requires `2x8-pin`,
     `3x8-pin`, or a `12V-2x6`/adapter path
   - for a `3x8-pin` board, confirm whether all three connectors are fed by
     separate PCIe leads from a rated PSU output
   - if any connector is fed by a pigtailed branch or Dell-header adapter
     chain, treat that as a first-class remediation item

3. Run a controlled reset matrix:
   - warm reboot with Dell HDMI attached
   - warm reboot with headset attached
   - warm reboot with both attached
   - hard reset equivalents
   - capture connector and kernel state after each

4. Identify the present external-ATX control method:
   - direct jumper
   - relay board
   - daughterboard
   - manually switched
   - other

5. Decide whether the next prototype is electrical or architectural:
   - if warm reboot only fails under the current multi-PSU topology, prioritize sync / daughterboard work
   - if warm reboot fails even with simplified power, treat GPU / firmware / platform resume as the lead suspect

## Linear issue map

- `TIN-337`: stabilize honey warm-reboot / display-reset behavior on the Dell 7810 platform
- `TIN-338`: research Dell 7810 proprietary PSU, distribution-board, and multi-PSU sync options
- `TIN-339`: capture a reset matrix for honey across warm reboot, hard reset, and display topology changes
- `TIN-340`: define a management-display / out-of-band recovery path for honey independent of the XR GPU

## Notes on confidence

- the Dell spec sheet and Intel ATX documentation are primary sources
- the AMD quick reference guide is a primary vendor source for GPU power expectations
- the Dell community threads are not formal engineering documentation, but they are the most specific currently available public evidence for T7810 vs T7910 distribution-board and rail behavior
- the recommendation to avoid assuming Add2PSU works safely out of the box on a proprietary Dell primary is an engineering inference from the Add2PSU operating model, not a claim from Dell or Intel
