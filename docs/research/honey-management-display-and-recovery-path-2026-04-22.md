# Honey Management Display And Recovery Path - 2026-04-22

## Scope

This note pulls the management-display findings for `honey` into one place.

It is not a new measurement campaign. It is a bounded design note distilled
from:

- [`honey-reset-matrix-2026-04-22.md`](honey-reset-matrix-2026-04-22.md)
- [`honey-power-reset-and-multi-psu-2026-04-22.md`](honey-power-reset-and-multi-psu-2026-04-22.md)

Repo boundary:

- `Jesssullivan/Dell-7810` owns the workstation-side management display and
  recovery-path design.
- `Jesssullivan/XoxdWM` may depend on that recovery path, but it does not own
  the hardware design evidence behind it.

## What the April 22 evidence already shows

### In the degraded state, remote operability was not enough

From the reset matrix and power/reset note:

- the bad state left the useful display path absent or degraded,
- Tailscale health became unreliable,
- direct LAN TCP/22 still answered but SSH auth stalled after publickey offer,
- GPU-side error markers included `No EDID found on connector: DP-2`,
  `sdma0 timeout`, and `device lost from bus`.

That means "some network response still exists" is not a sufficient recovery
surface for this host when it falls into the bad path.

### After hard reset, the Dell HDMI path became the trusted operator surface

On the healthy post-reset boot:

- `HDMI-A-2` came back `connected` and `enabled`,
- the Dell monitor exposed normal `1920x1080` modes,
- `DP-2` also returned with valid EDID and expected Beyond-class modes,
- the current boot no longer showed the degraded-path amdgpu markers.

This is the strongest current evidence that a management-display lane is not
optional on this machine. It is part of how the workstation becomes trustworthy
again after recovery.

### Healthy operation can preserve both display roles at once

The reset matrix already shows that:

- the Dell HDMI management display can coexist with the headset display path,
- a controlled warm reboot from a known-good state preserved both paths,
- the display problem is therefore not "too many displays" in the abstract.

The current engineering problem is reset and power behavior, not a fundamental
incompatibility between the management display and the XR display path.

## Current design conclusion

Treat the management display as a first-class host requirement:

- it is the lowest-friction local truth surface after reset and recovery,
- it should not be treated as expendable cabling once the XR path is working,
- and case, cable-routing, and power-path decisions should preserve it.

For this repo, "management display recovery" currently means:

- keep a dependable HDMI-attached operator display lane available,
- record its state explicitly in reset runs,
- and avoid designs that force XR bring-up to be the only way to trust the
  machine again.

## Immediate implications for ongoing work

### Reset and platform work

- future reset rows should keep recording both `HDMI-A-2` and `DP-2`,
- remote-only recovery should stay classified as untrusted while the bad path
  remains unresolved,
- any new platform claim about display recovery should cite the reset matrix
  first.

### Enclosure and cable work

- preserve a practical management-display cable route in the enclosure design,
- do not make service access to the management path harder than it is today,
- treat management-display access as part of maintainability, not a cosmetic
  afterthought.

### Publication framing

- hardware-facing claims about recovery and host trust belong in this repo,
- XR/runtime-facing claims about what software did on the recovered host belong
  in `XoxdWM`.

## Source documents

- [`honey-reset-matrix-2026-04-22.md`](honey-reset-matrix-2026-04-22.md)
- [`honey-power-reset-and-multi-psu-2026-04-22.md`](honey-power-reset-and-multi-psu-2026-04-22.md)
