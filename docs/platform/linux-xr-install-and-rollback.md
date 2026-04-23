# `linux-xr` Install And Rollback

Use this note to keep the `honey` kernel lanes honest.

This repo does not own the public installer scripts. It owns the workstation
decision rule for when the generic lane stays default, when RT is tested, and
how to verify or roll back on the Dell 7810.

## Current policy

- generic `linux-xr` is the persistent default lane on `honey`
- RT is a gated validation lane
- RT should not become the default just because it booted once

## Generic install

Main public supplier surface:

```bash
curl -fsSL https://tinyland-inc.github.io/linux-xr/install/rocky10-generic.sh | bash
```

Useful staged flags:

- `--print-assets`
- `--download-only`
- `--target-dir <dir>`
- `--no-set-default`
- `--with-devel`
- `--with-headers`

## RT install

Main public supplier surface:

```bash
curl -fsSL https://tinyland-inc.github.io/linux-xr/install/rocky10-rt.sh | bash
```

For first-pass validation, prefer a staged posture:

```bash
curl -fsSL https://tinyland-inc.github.io/linux-xr/install/rocky10-rt.sh | \
  bash -s -- --no-set-default
```

## One-time RT boot rule

Do not change the persistent default kernel just to validate RT.

On `honey`, the safe Dell-owned posture is:

- keep the generic `linux-xr` kernel as the persistent default
- arm RT only as a one-time next boot
- verify RT on that one boot
- let the host fall back to the generic default on the following reboot unless
  there is explicit reason to promote RT further

The repo now has a remote control surface for that:

```bash
just platform-kernel-status-remote
just platform-kernel-schedule-next-rt-remote
just platform-kernel-clear-next-entry-remote
```

This uses `grub2-reboot` / `next_entry`, not `grubby --set-default`.
That is the key safety boundary for keeping `honey` functional as the fallback
server lane.

## Post-install verification

For any new kernel lane:

```bash
uname -r
```

For RT specifically:

```bash
uname -v
cat /sys/kernel/realtime
```

Expected RT signals:

- `uname -v` contains `PREEMPT_RT`
- `/sys/kernel/realtime` is `1`

Then run the Dell validation surfaces:

```bash
just platform-bios-rt-check
just platform-smi-validate-full
```

Current live reminder from the April 22, 2026 Dell baseline:

- the active generic host matched the Dell base kernel fragment `30 / 30`
- after the tuned-managed reboot, the same generic lane matched `19 / 19` of
  the low-latency cmdline reference tokens

So the generic lane is no longer merely "working"; it now also matches the
intended Dell host timing posture on the current baseline. The remaining gap is
not the generic cmdline lane, but the nonzero SMI count and the fact that RT is
still a separate validation branch.

## First one-time RT result

On April 23, 2026, the Dell-owned one-time RT boot rule was exercised on
`honey` without changing the persistent default kernel.

The useful result split is:

- success:
  - `6.19.5-rt1-8.xr.el10` booted
  - `uname -v` contained `PREEMPT_RT`
  - `/sys/kernel/realtime` was `1`
  - the persistent default stayed generic
  - `next_entry` was consumed and cleared
  - a follow-on reboot returned the host to the generic fallback lane
- not yet clean:
  - the first-pass Dell RT validator was stricter than the live shipped RT
    kernel and flagged `CONFIG_PREEMPT_DYNAMIC=y`
  - bounded SMI count remained `16 in 10s`
  - remote recovery was slower and less smooth than the generic lane

That is a real RT validation result, but not a promotion result.
The Dell RT validator has since been reconciled to the current supplier
semantics; the next RT boot should be checked again under that updated rule.
See `docs/platform/honey-rt-validation-2026-04-23.md`.

## Rollback rule

If the new kernel lane fails boot reliability, reset behavior, or host timing
checks, revert to the known-good generic default.

Typical boot-entry inspection:

```bash
sudo grubby --default-kernel
sudo grubby --info=ALL
```

Set the default back to the known-good generic XR kernel:

```bash
sudo grubby --set-default /boot/vmlinuz-<known-good-generic-xr>
```

Then reboot and verify the host is back on the expected lane:

```bash
uname -r
sudo grubby --default-kernel
```

## When to promote RT

Do not promote RT to the persistent default until all of the following are true:

- BIOS A34 is confirmed
- low-latency BIOS posture matches the target record
- reset behavior is acceptable on the current host state
- `just platform-smi-validate-full` is acceptable
- the actual XR or host workload being protected benefits from the RT lane

## Related local docs

- `docs/platform/honey-bios-cstates-and-linux-xr-runbook-2026-04-22.md`
- `docs/platform/host-kernel-baseline.md`
- `docs/platform/bios-settings-record-template.md`
