# Honey Reset Matrix - 2026-04-22

Owner issue: `TIN-339`

## Scope

This note turns the April 22, 2026 `honey` investigation into a reset-focused matrix instead of a general power-architecture memo.

Repo boundary:

- `Jesssullivan/Dell-7810` owns workstation power, reset, enclosure, and platform-specific hardware behavior.
- `Jesssullivan/XoxdWM` owns compositor, VR stack, packaging, and software validation.

This document records what actually happened on `honey`, what is still unknown, and how future reset tests should be captured.

## Host and topology under test

- host: `honey`
- platform: Dell Precision Tower 7810
- kernel on the healthy recovery boot: `6.19.5-7.xr.el10`
- GPU: AMD Radeon RX 9070-class card on `0000:05:00.0`
- management display path: Dell HDMI display on `HDMI-A-2`
- headset display path: Bigscreen Beyond path on `DP-2`

## Recorded reset matrix

| Run | Date and evidence window | Reset / trigger path | AC power break | HDMI-A-2 | DP-2 | Kernel markers | Remote operability | Outcome |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A | April 22, 2026, `00:39` to `00:41` on the prior boot | degraded runtime state followed by display probing in the bad state | no | absent from the useful display path | present but EDID failed | `Cannot find any crtc or sizes`, `No EDID found on connector: DP-2`, `ring sdma0 timeout`, `device lost from bus` | Tailscale unhealthy, LAN TCP/22 still answered, SSH auth stalled after publickey offer | fail |
| B | April 22, 2026, fresh boot at `01:19 EDT` after manual hard reset | full manual hard reset | yes | `connected`, `enabled`, Dell EDID present, `1920x1080` modes present | `connected`, `256`-byte EDID present, `5088x2544` and `3840x1920` modes present | only benign display init markers on this path, including `Failed to setup vendor infoframe on connector HDMI-A-2: -22` and `fb0: amdgpudrmfb frame buffer device` | SSH and Tailscale recovered; host stable enough for normal remote inspection | pass |

## Evidence behind each run

### Run A: degraded pre-hard-reset state

Observed from the prior boot logs and live checks:

- `journalctl -k -b -1` showed repeated `Cannot find any crtc or sizes` events on April 22, 2026 at `00:39:52`
- `journalctl -k -b -1` then showed `No EDID found on connector: DP-2` at `00:41:13`
- the same boot then showed `ring sdma0 timeout` at `00:41:15`
- the GPU followed with `device lost from bus!` at `00:41:15` and again at `00:41:18`
- older logs from April 13, 2026 on the same host also showed reset and resume instability:
  - `Failed to exit BACO state!`
  - `Failed to SetDriverDramAddr!`
  - `resume of IP block <smu> failed -62`

Interpretation:

- this was not a simple display-not-awake case
- the failure crossed display enumeration, GPU recovery, and host usability
- the exact triggering sequence was not a cleanly controlled warm reboot, so this run is strong evidence of a bad reset path but not yet a complete reboot matrix entry

### Run B: hard-reset recovery boot

Observed live after the manual hard reset:

- `who -b` reported boot time `2026-04-22 01:19`
- connector state remained stable on follow-up checks from the healthy boot:
  - `card0-HDMI-A-2 status=connected enabled=enabled`
  - `card0-DP-2 status=connected enabled=disabled`
- the Dell display path and Beyond display path both had `256`-byte EDIDs
- the current healthy boot did not show the degraded-path markers
- the only relevant display lines on this boot were:
  - `Failed to setup vendor infoframe on connector HDMI-A-2: -22`
  - `fb0: amdgpudrmfb frame buffer device`

Interpretation:

- the workstation can simultaneously support the Dell management display and the headset display path
- a hard power break clears the bad state in a way that softer recovery did not
- this strongly implicates reset sequencing, power sequencing, or both

## What this matrix already tells us

- `honey` is not failing because the physical display topology is impossible
- the most credible fault domain is reset and power behavior around the GPU and attached displays
- a manual hard reset is currently the only observed recovery path that restores both management and headset display lanes
- remote-only recovery should be treated as untrusted while this remains unresolved

## Missing matrix rows

These runs are still needed before making a bigger architectural call:

1. Controlled warm reboot from a known-good starting state with both Dell HDMI and Beyond attached
2. Controlled warm reboot with Dell-only display topology
3. Controlled warm reboot with Beyond-only display topology
4. Controlled warm reboot after explicitly shutting down graphics userspace
5. Full power-off and cold boot without changing cabling
6. If safe, one run that isolates any secondary or external ATX assistance path so sequencing can be compared directly

## Capture procedure for future reset runs

Use this sequence for each future row added to the matrix.

### Before reset

Record:

- `date`
- `hostname`
- `who -b`
- `uname -r`
- `uptime`
- `for d in /sys/class/drm/card0-*; do printf "%s status=%s enabled=%s\n" "$(basename "$d")" "$(cat "$d/status" 2>/dev/null)" "$(cat "$d/enabled" 2>/dev/null)"; done`
- `journalctl -k -b | rg -n "No EDID found|Cannot find any crtc|sdma0|device lost from bus|BACO|smu|vendor infoframe|amdgpudrmfb" -S`

### Reset action

Record exactly one of:

- warm reboot
- OS shutdown followed by front-panel power-on
- manual hard reset
- full AC removal / restore

Also record cabling state:

- Dell HDMI attached or detached
- Beyond attached or detached
- any external or secondary PSU path enabled, disabled, or modified

### After reset

Record the same connector and kernel checks again, plus:

- whether SSH returned cleanly
- whether Tailscale returned cleanly
- whether the Dell display linked
- whether the Beyond display exposed EDID and expected modes
- whether any GPU recovery, timeout, or bus-loss markers appeared

## Safety notes

- avoid aggressive debugfs forcing or repeated live connector pokes while the host is already degraded
- do not treat a partially alive SSH port as proof that the workstation is in a safe state
- if the system drops into the known bad path, prefer a bounded evidence capture followed by a hard recovery rather than prolonged blind probing

## Current working conclusion

As of April 22, 2026, the reset matrix supports a narrow conclusion:

- the Dell 7810 `honey` host has a real bad-state path that survives normal software recovery poorly
- a hard reset restores the system cleanly
- the next engineering step is to expand this matrix with controlled reboot rows before escalating to a more complex multi-GPU architecture
