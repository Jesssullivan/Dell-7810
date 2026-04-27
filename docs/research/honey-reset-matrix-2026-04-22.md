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
| C | April 22, 2026, pre-check at `01:50 EDT`, reboot completed into a new boot at `01:59 EDT`, Tailscale usable again around `02:02 EDT` | controlled warm reboot from a known-good state with Dell HDMI and Beyond attached | no | `connected` and `enabled` after reboot | `connected` after reboot | same benign boot markers as Run B; no `No EDID found`, `sdma0 timeout`, or `device lost from bus` | direct LAN SSH returned by `02:01:59`; Tailscale from `neo` stayed down through `02:01:26` and then recovered via DERP around `02:02:24` to `02:02:28` | pass, network-delayed |
| D | April 22, 2026, pre-check at `02:06 EDT`, services quiesced at `02:06:45` to `02:07:40 EDT`, new boot at `02:10 EDT` | historical warm reboot row after stopping `rke2-server`, `docker.service`, and `docker.socket` | no | `connected` and `enabled` after reboot | `connected` after reboot | same benign boot markers as Runs B and C; no `No EDID found`, `sdma0 timeout`, or `device lost from bus` | SSH and LAN `:22` returned by `02:10:40`; `tailscale ping` worked again by `02:11:04`, still via DERP | historical only, out of policy for future runs |

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

### Run C: controlled warm reboot from a known-good state

Observed on April 22, 2026:

- pre-reboot checks at `01:50:06 EDT` showed the same healthy baseline as Run B:
  - `card0-HDMI-A-2 status=connected enabled=enabled`
  - `card0-DP-2 status=connected enabled=disabled`
  - only the benign HDMI vendor infoframe warning plus `amdgpudrmfb` in the filtered kernel view
- the prior boot's shutdown sequence reached `systemd-reboot.service` successfully at `01:57:55`
- that shutdown was not fast:
  - multiple `cri-containerd-*` scopes timed out and were SIGKILLed before reboot completed
  - `systemd-shutdown` did not finish syncing filesystems and stop journald until `01:58:01`
- the new boot was live by `01:59`
- post-reboot checks over direct LAN SSH at `02:01:59 EDT` showed:
  - `card0-HDMI-A-2 status=connected enabled=enabled`
  - `card0-DP-2 status=connected enabled=disabled`
  - no bad amdgpu markers in the current boot
  - only `Failed to setup vendor infoframe on connector HDMI-A-2: -22` and `fb0: amdgpudrmfb frame buffer device`
- remote return was slower than local host recovery:
  - `tailscale ping honey` from `neo` stayed down through the watch window ending at `02:01:26 EDT`
  - direct LAN SSH to the `honey` management LAN address was already working by
    `02:01:59 EDT`
  - by `02:02:24` to `02:02:28 EDT`, Tailscale on `honey` was active again and `neo` could reach it, initially via `DERP(nyc)` rather than a direct path

Interpretation:

- this row did not reproduce the catastrophic GPU and display failure from Run A
- a clean warm reboot from a known-good starting state is possible on this hardware
- the remaining weakness in this row was delayed shutdown and network-path recovery, not a display or GPU crash

### Run D: warm reboot after quiescing `rke2` and Docker

Observed on April 22, 2026:

- before attempting the originally planned "graphics userspace shutdown" variant, the host was checked live:
  - `systemctl get-default` returned `multi-user.target`
  - `graphical.target` was inactive
  - `display-manager.service` was inactive
  - no active compositor, desktop shell, or XR userspace process was present in the process list
- that means the graphics-userspace row is currently not a meaningful separate variant on `honey`
- the next meaningful controllable variant was therefore service quiescence:
  - `rke2-server` stopped at `02:06:45 EDT`
  - `docker.service` and `docker.socket` were stopped by `02:07:40 EDT`
  - `containerd.service` stayed active because many orphaned `containerd-shim` processes remained after `rke2-server` stopped
- the rebooted system came up on a new boot at `02:10`
- post-boot checks showed:
  - `card0-HDMI-A-2 status=connected enabled=enabled`
  - `card0-DP-2 status=connected enabled=disabled`
  - no bad amdgpu markers in the filtered kernel view
  - only `Failed to setup vendor infoframe on connector HDMI-A-2: -22` and `fb0: amdgpudrmfb frame buffer device`
- remote return timing on this row was:
  - LAN `:22` and SSH back by `02:10:40 EDT`
  - `tailscale ping honey` working again by `02:11:04 EDT`
  - the recovered Tailscale path was still via `DERP(nyc)`, not direct
- prior-boot shutdown logs still showed significant container teardown pressure:
  - orphaned `containerd-shim` processes remained after `rke2-server` stop
  - multiple `cri-containerd-*` scopes still timed out and were SIGKILLed around `02:09:20`
  - `systemd-reboot.service` finished at `02:09:21`

Interpretation:

- pre-stopping `rke2` and Docker did not eliminate the container-driven shutdown problem
- it also did not reproduce the catastrophic display or GPU crash row
- compared with Run C, this row appears to have returned faster overall, but the reboot path is still being dominated by lingering container workload rather than graphics userspace
- this row should be treated as historical evidence only
- future reboot experiments should not intentionally stop `rke2-server`

## What this matrix already tells us

- `honey` is not failing because the physical display topology is impossible
- the catastrophic failure from Run A is real, but not every warm reboot reproduces it
- a controlled warm reboot from a known-good starting state can preserve both management and headset display lanes
- the planned "graphics userspace shutdown" row is currently not distinct on this host because `honey` is already running without an active graphical target or display manager
- `rke2-server` is part of the required `honey` surface and should not be intentionally stopped for future reboot experiments
- the remaining reliability problem is split across at least two layers:
  - GPU and display bad-state risk in Run A
  - delayed shutdown and remote-path recovery in Runs C and D
- remote-only recovery should still be treated as untrusted while these paths remain unresolved

## Missing matrix rows

These runs are still needed before making a bigger architectural call:

1. Controlled warm reboot with Dell-only display topology
2. Controlled warm reboot with Beyond-only display topology
3. Full power-off and cold boot without changing cabling
4. If safe, one run that isolates any secondary or external ATX assistance path so sequencing can be compared directly
5. A policy-safe reboot row that measures container-related shutdown latency without intentionally stopping `rke2-server`

## Capture procedure for future reset runs

Use this sequence for each future row added to the matrix.

Reusable repo-side helpers now exist for this:

- `just platform-capture-reset-state tag=<label>`
- `docs/platform/reset-run-template.md`

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
- do not intentionally stop `rke2-server` for matrix collection; preserve the cluster surface during future reboot experiments
- if the system drops into the known bad path, prefer a bounded evidence capture followed by a hard recovery rather than prolonged blind probing

## Current working conclusion

As of April 22, 2026, the reset matrix supports a narrow conclusion:

- the Dell 7810 `honey` host has a real bad-state path that survives normal software recovery poorly
- a hard reset restores the catastrophic bad row cleanly
- a controlled warm reboot from a known-good state can succeed for the GPU and both display lanes
- the historical Run D result suggests container workload still dominates shutdown timing, but future validation should preserve `rke2-server`
- the next engineering step is to keep expanding the matrix until the team can separate power/reset defects from slower network and service-return behavior
