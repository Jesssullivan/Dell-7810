# BIOS Flash Procedure

Use this note when `honey` or another T7810 host is below BIOS `A34`.

This is the Dell-owned workstation procedure. It summarizes the prior art that
previously only lived in `XoxdWM` helper recipes.

## Target

- platform: Dell Precision Tower 7810
- target BIOS: `A34`
- expected update payload: `T7810A34.exe`

## Preferred path

Use the built-in Dell flash path:

1. Prepare a FAT32 USB stick.
2. Copy `T7810A34.exe` to the root of the stick.
3. Insert the stick into the workstation.
4. Reboot and press `F12` at the Dell logo.
5. Select `BIOS Flash Update`.
6. Browse to `T7810A34.exe`.
7. Begin the flash and wait for completion.

This is the preferred path because it avoids extra DOS or recovery scaffolding.

## Before flashing

- record the current BIOS version
- make sure AC power is stable
- stop any work that depends on the current host state
- capture any current BIOS settings that are easy to lose track of
- if the machine is in a degraded GPU or display state, recover that first

## After flashing

1. Reboot normally.
2. Verify the new BIOS version:

```bash
cat /sys/class/dmi/id/bios_version
cat /sys/class/dmi/id/bios_date
```

3. Re-check the low-latency BIOS posture:

```bash
just platform-bios-rt-check
```

4. Fill the BIOS settings record:

- `docs/platform/bios-settings-record-template.md`
- `dhall/defaults/honey-bios-record-template.dhall`

5. Re-run host validation:

```bash
just platform-smi-validate-full
just platform-save-numa-state-json tag=post-bios-flash
just platform-save-reset-state-json tag=post-bios-flash
```

## Fallback paths

These exist, but they are not the mainline procedure:

- FreeDOS boot USB that runs `T7810A34.exe`
- `Ctrl+Esc` recovery flash using `BIOS_IMG.rcv`

Use these only if the normal `F12 -> BIOS Flash Update` path is unavailable or
broken on the current revision.

## Ownership note

The USB-preparation helpers and recovery variants originated in `XoxdWM`.
This repo now owns the workstation-facing flash procedure itself.
