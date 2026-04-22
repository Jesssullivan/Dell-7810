# T7810 Host Kernel Artifacts

This directory carries the generic Dell 7810 host-kernel posture extracted from the mixed `XoxdWM` lane.

## Files

- `t7810-host-latency-base.config`
  generic host baseline for timing, recovery, tracing, and systemd compatibility
- `t7810-host-latency-rt.config`
  minimal RT overlay applied only after the base posture is proven stable
- `t7810-host-latency.cmdline`
  runtime boot posture for low-latency host work on `honey`

## Validation

Use the repo-owned validator:

```bash
just platform-validate-kernel-baseline
just platform-validate-kernel-baseline-rt
```

Those wrap:

- [`scripts/platform/validate-host-kernel-baseline`](/Users/jess/git/Dell-7810/scripts/platform/validate-host-kernel-baseline)

The validator can also compare arbitrary files:

```bash
bash scripts/platform/validate-host-kernel-baseline \
  --config /boot/config-$(uname -r) \
  --cmdline-file /proc/cmdline
```

## Important boundary

These artifacts do not carry:

- Bigscreen Beyond quirk patches
- AMD DSC fixes
- XR-specific kernel packaging claims

Those remain overlay concerns outside this generic host baseline.
