# Honey Management Display And Recovery Path - 2026-04-22

Owner issue: `TIN-340`

## Scope

This note defines the recovery-display and out-of-band direction for `honey` after the April 22, 2026 reset investigation.

Repo boundary:

- `Jesssullivan/Dell-7810` owns workstation-specific recovery architecture, power sequencing, enclosure, and bench-side operability.
- `Jesssullivan/XoxdWM` owns compositor, VR stack, packaging, and software validation.

This is not a full remote-management implementation guide. It is the design note for how `honey` should remain recoverable while the XR lane is still unstable.

## Problem statement

The April 22 investigation established three things:

1. `honey` can reach a degraded GPU state where display probing, amdgpu recovery, and remote operability all become unreliable.
2. A manual hard reset restored both the Dell HDMI display path and the headset display path.
3. The Dell HDMI display made the workstation materially easier to trust and recover once it came back.

That proves a management-display lane is useful. It does not yet prove that the current management-display lane is independent enough.

## Current recovery surface

Observed live on April 22, 2026:

- `lspci -nn | rg -i "vga|3d|display"` showed only one display adapter:
  - `05:00.0` AMD Navi 48 / Radeon RX 9070-class GPU
- current useful display outputs are all on that same GPU:
  - `HDMI-A-2` for the Dell management display
  - `DP-2` for the Bigscreen Beyond display path
- on the healthy post-hard-reset boot:
  - `HDMI-A-2` was `connected` and `enabled`
  - `DP-2` was `connected`
- on the degraded pre-hard-reset path:
  - `DP-2` lost EDID
  - amdgpu hit `sdma0` timeouts
  - the device was reported lost from the bus

Implication:

- the Dell HDMI display is currently a management display only in the practical sense
- it is not yet independent of the XR GPU in the architectural sense

## Requirements for the recovery path

The recovery lane should satisfy these requirements, in order:

1. Preserve local console visibility when the XR stack or headset path is unhealthy.
2. Avoid depending on the headset display path for basic host recovery.
3. Reduce the chance that one GPU fault removes both XR and host-visibility paths at the same time.
4. Add as little new power, thermal, and cable pressure as possible while the PSU-sequencing question is still open.
5. Keep the design simple enough to validate incrementally on the bench.

## Recovery options

## 1. Same-GPU HDMI management display

Definition:

- keep the Dell display permanently attached to `HDMI-A-2` on the RX 9070
- treat it as the standard host-recovery display

Strengths:

- already proven to work on the healthy recovery boot
- no additional slot or card required
- zero new driver surface compared with the current host

Weaknesses:

- not independent of the XR GPU
- if the 9070 falls into the known bad reset path, the management display can disappear with it
- still forces recovery to share power and reset fate with the highest-risk GPU in the system

Assessment:

- useful as the immediate baseline
- insufficient as the final answer if `honey` is expected to be recoverable during XR or GPU faults

## 2. Separate low-power management GPU

Definition:

- add a second display adapter used only for firmware, console, and Dell display output
- reserve the RX 9070 for XR and high-performance graphics work

Strengths:

- creates a genuinely separate display lane
- keeps the Dell monitor available even if the XR GPU is wedged, absent, or being reworked
- supports a cleaner mental model: one device for management, one for XR

Weaknesses:

- adds slot, airflow, and cable complexity
- still does not become true server-style out-of-band management on its own
- can be the wrong move if the main issue is solved cleanly by PSU sequencing work

Selection constraints:

- prefer a bus-powered or otherwise very low-power card
- do not choose a second high-draw GPU just to gain console visibility
- the management adapter should be boring, stable, and non-ambitious

Assessment:

- strongest medium-term option if same-GPU recovery continues to be fragile
- much better fit than a sophisticated multi-GPU render design

## 3. USB graphics or other userspace-only console path

Definition:

- use a USB display adapter or similar userspace-managed path to preserve a screen

Strengths:

- low mechanical effort

Weaknesses:

- poor fit for firmware, boot, and degraded-kernel recovery
- not trustworthy when the host is already sick
- does not provide a credible recovery lane for this class of fault

Assessment:

- reject as the primary recovery design

## 4. Remote power and capture around the management lane

Definition:

- add supporting recovery infrastructure such as remotely controlled power and console capture around whichever management-display lane is chosen

Strengths:

- directly addresses the lesson from April 22, 2026 that a hard reset can be the real recovery action
- improves recoverability even if the display decision remains unchanged

Weaknesses:

- more moving pieces
- still needs a display source worth capturing

Assessment:

- important, but complementary rather than sufficient by itself

## Recommended architecture

### Phase 1: keep the Dell HDMI lane as the required baseline

Immediately:

- keep the Dell monitor connected as the standard recovery display on every bench session
- do not treat headset-only bring-up as an acceptable debug posture
- continue capturing `HDMI-A-2` and `DP-2` state in every reset-matrix row

Reason:

- this is already proven useful and costs nothing

### Phase 2: prefer a separate management GPU over a complex multi-GPU render design

If warm-reboot and reset behavior remain fragile after PSU-sequencing work:

- add a low-power management GPU dedicated to the Dell display and host console
- keep the RX 9070 dedicated to XR and heavy graphics work

Reason:

- this produces real separation between "host recoverable" and "XR render path healthy"
- it is far simpler and safer than jumping to a sophisticated multi-GPU render topology

### Phase 3: pair the chosen display lane with remote recovery controls

If `honey` remains a critical remote BCI/XR development surface:

- add remote-controlled power cycling or equivalent bench-safe recovery control
- add capture or KVM support only after the display source is stable and worth capturing

Reason:

- April 22 already showed that hard reset can be the decisive recovery step

## Decision rule

Use this rule to decide whether to stay with same-GPU HDMI or move to a separate management GPU:

- if the next controlled reset-matrix runs show reliable warm reboot with the Dell HDMI lane preserved, keep the single-GPU management display for now
- if the 9070 continues to take both XR and management visibility down together, move to a separate low-power management GPU before exploring more elaborate graphics architectures

## What not to do yet

- do not escalate immediately to a sophisticated multi-GPU render or display-composition design
- do not add a second high-power GPU just to create a recovery lane
- do not treat a same-GPU HDMI monitor as true out-of-band management

## Current working conclusion

As of April 22, 2026, `honey` should be treated as follows:

- required now: Dell HDMI display remains attached as the standard recovery display
- preferred next escalation: separate low-power management GPU if reset fragility persists
- not yet justified: complex multi-GPU rendering architecture
