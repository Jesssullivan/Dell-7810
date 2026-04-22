# Honey BIOS, C-States, And `linux-xr` Runbook -- 2026-04-22

Owner issue: `TIN-397`
GitHub mirror: `#17`

This note consolidates the currently scattered local flow for keeping `honey`
current on:

- Dell BIOS A34,
- low-latency BIOS posture,
- and the generic versus RT `linux-xr` kernel lanes.

It is an authority-import note, not a claim that the whole workflow has already
been rerun end-to-end inside this repo.

## Scope boundary

This repo should own:

- Dell 7810 BIOS update posture and flash procedure
- low-latency BIOS settings and C-state posture
- host validation after BIOS or kernel changes
- named-host evidence for generic and RT `linux-xr` lanes on `honey`

Sibling repos should keep:

- `linux-xr-fast`: public installer surface and release-distribution logic
- `XoxdWM`: boot-generation consumption, XR-oriented deployment logic, and
  software-facing support claims
- `lab` and `blahaj`: incidental host-role context only

The search across `lab` and `blahaj` did not turn up any stronger 7810 BIOS or
kernel authority than what already exists in `XoxdWM` and `linux-xr-fast`.

## What this repo already owns

Dell-owned surfaces already present here:

- `scripts/platform/dcc-configure-rt`
- `scripts/platform/smi-validate`
- `docs/platform/host-kernel-baseline.md`
- `docs/platform/bios-settings-record-template.md`
- `packaging/kernel/t7810-host-latency-base.config`
- `packaging/kernel/t7810-host-latency-rt.config`
- `packaging/kernel/t7810-host-latency.cmdline`
- `dhall/defaults/honey-bios-record-template.dhall`
- `dhall/defaults/honey-host-contract-template.dhall`

These cover the intended target posture, but they do not yet replace every
procedural step that still lives in sibling repos.

## External prior art that still matters

## 1. BIOS update and preflight flow in `XoxdWM`

Useful still-scattered artifacts in `../XoxdWM`:

- `just bios-download`
- `just bios-prepare-usb`
- `just bios-create-freedos-usb`
- `just bios-create-freedos-usb-remote`
- `just bios-extract`
- `just bios-verify honey`
- `just rollout-preflight honey`

The main useful procedural facts from those surfaces are:

- A34 is the target BIOS revision for the T7810.
- The preferred flash path is:
  `F12 -> BIOS Flash Update` from a FAT32 USB containing `T7810A34.exe`.
- FreeDOS and `Ctrl+Esc` recovery remain fallback paths, not the preferred one.
- `rollout-preflight` already treats BIOS A34 as the RT-ready baseline and warns
  on A02.

## 2. Host timing and boot-parameter posture in `XoxdWM`

The most important Dhall surfaces are now:

- `../XoxdWM/packaging/dhall/HostFacts.dhall`
- `../XoxdWM/packaging/dhall/HostTiming.dhall`
- `../XoxdWM/packaging/dhall/Platform.dhall`
- `../XoxdWM/packaging/dhall/BootParams.dhall`
- `../XoxdWM/packaging/dhall/defaults/honey-xr.dhall`

These establish the current operational posture that downstream boot-generation
consumers are using:

- BIOS A34 as the target firmware floor
- a TSC-reliable timing posture
- `intel_pstate=disable`
- `processor.max_cstate=1`
- `intel_idle.max_cstate=0`
- explicit workload isolation and IRQ-affinity defaults

Those facts should be described here as workstation authority even when they are
still consumed from `XoxdWM`.

## 3. Public install and release flow in `linux-xr-fast`

The public runtime-install surface currently lives in:

- `../linux-xr-fast/site/install.md`
- `../linux-xr-fast/site/install/rocky10-generic.sh`
- `../linux-xr-fast/site/install/rocky10-rt.sh`
- `../linux-xr-fast/site/docs/honey.md`

The high-signal facts from those files are:

- the generic lane is the documented default install path
- the RT lane is explicitly gated
- both install scripts support:
  `--print-assets`, `--download-only`, `--target-dir`, `--no-set-default`,
  `--with-devel`, and `--with-headers`
- the public `honey` note says:
  generic `6.19.5-7.xr.el10` is the persistent default,
  RT `6.19.5-8.xr.el10` is installed,
  and a one-time RT boot succeeded

This should stay an external supplier surface, but the Dell repo should be the
place that explains how that supplier fits into the workstation validation flow.

Official Dell Command | Configure references also matter here:

- Dell says the latest Dell Command | Configure release is `5.2.2`, released in
  March 2026.
- Dell's current Linux install guide still says to download the tarball from
  Dell Support and install the included RPMs manually.
- Dell documents Linux support for Red Hat Enterprise Linux `8` and `9`, not
  Rocky `10`.

That means the current `honey` blocker is not "forgot to install a package from
dnf." It is "stage and validate a Dell-supplied DCC payload on a host that is
close to, but not identical with, Dell's documented Linux support surface."

There is also one useful legacy fact for the T7810 specifically:

- Dell's older Command Configure 3.0 driver details page explicitly lists the
  Precision Tower `7810` as a compatible system and Red Hat Linux `7.0` as the
  supported OS lane for that payload.
- The Dell payload is `command_configure-linux-3.0.0-509.tar.gz`, and its
  contents are:
  - `command_configure-linux-3.0.0-509.el7.x86_64.rpm`
  - `srvadmin-hapi-7.4.0-4.2.8.el6.x86_64.rpm`
- On April 22, 2026, `rpm -ivh --test --nosignature` on `honey`
  (`Rocky Linux 10.1`) completed without dependency failure.
- A rootless extraction probe also succeeded far enough to show that the legacy
  payload installs `cctk` at `/opt/dell/toolkit/bin/cctk`, and that the binary
  can start before failing on the expected "admin/root privileges required"
  check.

## Recommended Dell-owned run order

This is the run order that best matches the current local prior art.

## 1. Verify BIOS revision

Check whether `honey` is already on A34.

Use either:

- `just platform-bios-rt-check`
- `cat /sys/class/dmi/id/bios_version`
- the remote check pattern from `XoxdWM`'s `bios-verify`

If BIOS is below A34, update before calling the RT lane trustworthy.

## 2. Update BIOS to A34 if needed

Preferred path:

1. obtain `T7810A34.exe`
2. place it on a FAT32 USB stick
3. use `F12 -> BIOS Flash Update`

Fallback paths that exist in local prior art:

- FreeDOS boot USB
- `Ctrl+Esc` recovery flash using `BIOS_IMG.rcv`

The Dell repo should describe those fallbacks, but the mainline posture should
stay the simpler F12 flow.

## 3. Check and record low-latency BIOS posture

Run:

```bash
just platform-bios-rt-check
```

Current target settings from the Dell-owned check surface are:

- `usblegacy=disabled`
  legacy DCC 3 surface: `usbemu=disable`
- `cstates=c1`
  legacy DCC 3 surface: `cstatesctrl=disable` as the closest machine-readable
  low-latency approximation
- `intelturboboosten=disabled`
  legacy DCC 3 surface: `turbomode=disable`
- `intelspdstep=disabled`
  legacy DCC 3 surface: `speedstep=disable`
- `hpet=enabled`
- `computrace=deactivate`

Then fill the BIOS record surfaces:

- `docs/platform/bios-settings-record-template.md`
- `dhall/defaults/honey-bios-record-template.dhall`

Current live result as of April 22, 2026:

- the Dell repo staging helper succeeded against the known 7810-compatible
  payload, and `command_configure-linux-3.0.0-509` plus `srvadmin-hapi-7.4.0`
  are now installed on `honey`
- the repo-owned BIOS checker now runs truthfully on-host against
  `/opt/dell/toolkit/bin/cctk`
- initial checked posture was:
  - `usbemu=enable` (mismatch)
  - `cstatesctrl=disable` (acceptable legacy approximation to the intended C1-only target)
  - `turbomode=disable` (match)
  - `speedstep=disable` (match)
  - `hpet` unknown through legacy export
  - `computrace` unknown through legacy export
- the repo can now also affect that BIOS posture remotely from this checkout:
  `usbemu=disable` was written successfully on April 22, 2026 through the
  legacy DCC surface
- that write was then reboot-validated on `honey`:
  the post-reboot BIOS check still reported `usbemu=disable`, but the
  post-reboot bounded SMI sample still reported `16` SMIs in `10s`
- raw evidence now lives in:
  - `data/captures/honey/bios-export-2026-04-22.cctk`
  - `data/captures/honey/bios-check-2026-04-22.txt`
  - `data/captures/honey/bios-export-post-usbemu-disable-2026-04-22.cctk`
  - `data/captures/honey/bios-check-post-usbemu-disable-2026-04-22.txt`
  - `data/captures/honey/smi-validate-post-usbemu-disable-pre-reboot-2026-04-22.txt`
  - `data/captures/honey/reboot-confirmation-post-usbemu-disable-2026-04-22.txt`
  - `data/captures/honey/bios-export-post-reboot-usbemu-disable-2026-04-22.cctk`
  - `data/captures/honey/bios-check-post-reboot-usbemu-disable-2026-04-22.txt`
  - `data/captures/honey/kernel-baseline-post-reboot-usbemu-disable-2026-04-22.txt`
  - `data/captures/honey/smi-validate-post-reboot-usbemu-disable-2026-04-22.txt`

### Turn-key remote control path

The Dell repo now has a single operator surface for remote BIOS and SMI work on
`honey`:

- `scripts/platform/remote-bios-control`
- `just platform-bios-rt-check-remote`
- `just platform-bios-export-remote`
- `just platform-bios-usbemu-disable-remote`
- `just platform-bios-usbemu-enable-remote`
- `just platform-smi-validate-remote`

The important behavior is:

- the control path stages repo-owned scripts under `/tmp/dell-7810-platform`
  on the target host
- it uses the target host's own
  `~/.config/sops-nix/secrets/become/password` secret for sudo
- it does not require a Dell-7810 checkout on the target host
- BIOS writes should still be treated as "reboot pending" until the host is
  restarted and revalidated; the `usbemu=disable` experiment in this repo has
  now completed that cycle once and showed no observed improvement in the
  bounded post-reboot SMI sample

Example sequence:

```bash
just platform-bios-rt-check-remote
just platform-bios-usbemu-disable-remote
just platform-bios-export-remote > data/captures/honey/bios-export-post-usbemu-disable-2026-04-22.cctk
just platform-smi-validate-remote > data/captures/honey/smi-validate-post-usbemu-disable-pre-reboot-2026-04-22.txt
ssh jess@honey 'pw=$(cat ~/.config/sops-nix/secrets/become/password); printf "%s\n" "$pw" | sudo -S -p "" systemctl reboot'
just platform-bios-rt-check-remote > data/captures/honey/bios-check-post-reboot-usbemu-disable-2026-04-22.txt
just platform-smi-validate-remote > data/captures/honey/smi-validate-post-reboot-usbemu-disable-2026-04-22.txt
```

### Legacy DCC candidate ranking after the `usbemu` experiment

The current legacy CCTK export on `honey` also exposes:

- `usbwake=enable`
- `wakeonlan=enable`
- `deepsleepctrl=disable`
- `smarterrors=enable`
- `drmt=enable`
- `postmebxkey=on`

These should not be treated as equally likely next steps.

Most plausible low-risk next BIOS candidates:

- `usbwake`
  likely relevant only to wake behavior, but still a USB-related firmware path
- `wakeonlan`
  likely relevant only to S4/S5 wake behavior, but easy to describe and revert

Lower-value or higher-risk candidates:

- `deepsleepctrl`
  explicitly described by Dell as an S4/S5 power-state control, not a live
  runtime-latency control
- `smarterrors`
  only makes sense to disable if storage SMART signaling is a suspected source
- `drmt`
  Dell Reliable Memory Technology is not a casual toggle; disable only with a
  clear reason, because it changes memory-reliability posture

Not a runtime SMI candidate:

- `postmebxkey`
  only controls whether the MEBx hotkey is shown at POST

Current evidence says BIOS-side iteration should slow down unless a candidate
has a strong reason. After `usbemu=disable`, reboot, and revalidation:

- the bounded SMI sample remained about `16-17` events per `10s`
- the built-in tracefs `hwlat` fallback reported only `2 us` max latency over
  a 10-second sample

That means the next high-value lane is no longer "toggle BIOS options until the
SMI counter goes to zero." It is "improve host posture and keep measuring":

- low-latency cmdline closure
- tuned-profile closure
- repeated `hwlat` / SMI captures

## 4. Keep the generic `linux-xr` lane as the persistent default

Current local prior art says the generic lane is the stable default on `honey`.

Use the public supplier surface when needed:

```bash
curl -fsSL https://tinyland-inc.github.io/linux-xr/install/rocky10-generic.sh | bash
```

For more conservative or staged work, use flags like:

- `--print-assets`
- `--download-only`
- `--target-dir`
- `--no-set-default`

The Dell authority part is not the download script itself. It is the decision
that the generic lane remains the persistent default until RT passes the local
latency and reset checklist again.

As of the April 22, 2026 live validation pass, the generic lane also fails the
entire low-latency cmdline reference set and is still on the wrong tuned
profile:

- base kernel fragment: `30 / 30` matched
- low-latency cmdline tokens: `0 / 19` matched
- active tuned profile: `throughput-performance`

## 5. Treat RT as a gated validation lane

The RT lane should be installed and tested deliberately, not promoted by habit.

Use the public supplier surface as needed:

```bash
curl -fsSL https://tinyland-inc.github.io/linux-xr/install/rocky10-rt.sh | bash
```

For first-pass validation, prefer a non-default or staged posture where
practical, then verify:

- `uname -v` contains `PREEMPT_RT`
- `/sys/kernel/realtime` is `1`

The local public prior art still says:

- one-time RT boot succeeded
- RT is not yet the normal persistent default

## 6. Re-run host validation after BIOS or kernel changes

After any BIOS or kernel lane change, the Dell repo should drive the validation:

```bash
just platform-smi-validate-full
just platform-save-numa-state-json tag=post-change
just platform-project-host-inventory-dhall output/capture-json/numa-post-change.json
just platform-save-reset-state-json tag=post-change
```

Then update:

- BIOS record
- host inventory
- reset-run note / Dhall record
- any SMI or latency evidence note

## What still needs to move here

The biggest remaining authority gaps in this repo are:

- a promoted BIOS settings record after the first live legacy-DCC machine check
- a filled host inventory and reset-run record produced from a real `honey` run
- a post-change SMI or hwlat report after BIOS, tuned, and cmdline closure

The first two procedure gaps now have seeded Dell-owned docs:

- `docs/platform/bios-flash-procedure.md`
- `docs/platform/linux-xr-install-and-rollback.md`

The repo also now has seeded staging/code surfaces for legacy DCC:

- `scripts/platform/stage-legacy-dcc-7810`
- `scripts/platform/dcc-configure-rt`

## What should not be absorbed wholesale

This repo should not absorb:

- the public Pages install scripts from `linux-xr-fast`
- `XoxdWM`'s full boot-generation pipeline
- software-facing support claims about XR runtime success

Those remain downstream consumer surfaces.

## Provenance

Primary local sources for this note:

- `../XoxdWM/justfile`
- `../XoxdWM/packaging/dhall/`
- `../XoxdWM/docs/support-matrix.md`
- `../XoxdWM/docs/status.md`
- `../XoxdWM/docs/roadmap-2026-q2.md`
- `../linux-xr-fast/site/install.md`
- `../linux-xr-fast/site/install/rocky10-generic.sh`
- `../linux-xr-fast/site/install/rocky10-rt.sh`
- `../linux-xr-fast/site/docs/honey.md`
- <https://www.dell.com/support/kbdoc/en-us/000178000/dell-command-configure>
- <https://www.dell.com/support/manuals/en-us/command-configure/dcc_5.x_ig/install-dell-command-configure-on-red-hat-enterprise-linux-8-and-9>
- <https://www.dell.com/support/home/en-pr/drivers/driversdetails?driverid=2v66r>
