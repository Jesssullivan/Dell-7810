# Honey One-Time RT Validation -- 2026-04-23

Owner lane: `TIN-397`

This note records the first Dell-owned one-time PREEMPT_RT validation boot on
`honey` after the generic low-latency baseline was closed on April 22, 2026.

## Captures

- pre-RT kernel lane status:
  `data/captures/honey/kernel-lane-status-pre-rt-reboot-2026-04-23.txt`
- pre-RT runtime confirmation:
  `data/captures/honey/kernel-runtime-pre-rt-reboot-2026-04-23.txt`
- post-RT reboot confirmation:
  `data/captures/honey/reboot-confirmation-post-rt-boot-2026-04-23.txt`
- post-RT kernel lane status:
  `data/captures/honey/kernel-lane-status-post-rt-boot-2026-04-23.txt`
- post-RT kernel baseline validation:
  `data/captures/honey/kernel-baseline-post-rt-boot-2026-04-23.txt`
- post-RT SMI validation:
  `data/captures/honey/smi-validate-post-rt-boot-2026-04-23.txt`
- post-RT return-to-generic confirmation:
  `data/captures/honey/reboot-confirmation-post-rt-return-generic-2026-04-23.txt`
- post-RT return-to-generic kernel lane status:
  `data/captures/honey/kernel-lane-status-post-rt-return-generic-2026-04-23.txt`

## What was done

The repo-owned one-time RT boot path was used exactly as documented:

1. confirm the persistent default stayed on generic `linux-xr`
2. consume the already-armed `next_entry` RT boot
3. reboot `honey`
4. verify the live RT signals
5. validate the repo-owned RT baseline and timing surfaces

No persistent default-kernel change was made during this run.

## Confirmed results

- `honey` booted the RT kernel:
  `6.19.5-rt1-8.xr.el10`
- `uname -v` contained `PREEMPT_RT`
- `/sys/kernel/realtime` was `1`
- the persistent default kernel remained generic:
  `/boot/vmlinuz-6.19.5-7.xr.el10`
- `saved_entry` remained generic
- `next_entry` was consumed and cleared after the RT boot
- the live RT boot preserved the full Dell low-latency cmdline posture:
  `19 / 19` reference tokens still matched

## Repo-owned validation result

The RT run was a real boot success, but not yet a clean repo-baseline pass.

### What passed

- base host fragment: `30 matched`, `0 mismatched`
- live RT signals: present and truthful
- low-latency cmdline posture: `19 matched`, `0 missing`
- bounded RT `hwlat` sample: `1 us`

### What failed

The RT overlay fragment currently fails against the live kernel config:

- `CONFIG_PREEMPT_VOLUNTARY` missing relative to the current validator
- `CONFIG_PREEMPT_NONE` missing relative to the current validator
- `CONFIG_PREEMPT_DYNAMIC` is `y`, but the current RT overlay expects `n`

This means the current repo-owned RT fragment is stricter than the live
`linux-xr` RT kernel that actually booted.

## Timing result

The post-RT bounded timing sample was mixed but useful:

- SMI count remained `16 in 10s` (`1.6/s`)
- tracefs `hwlat` fallback reported `1 us` max latency

So this first RT run did not remove the nonzero SMI count, but it also did not
show large hardware latency in the 10-second bounded sample.

## Stability note

Remote recovery after the RT reboot was slower and less smooth than the generic
lane:

- the first successful reconnect occurred after about `145s`
- SSH then became temporarily unreachable again before stabilizing enough for
  the repo-owned follow-on checks

That should be treated as a real part of the RT-lane result, not just operator
noise.

## Return to generic

After the RT evidence was captured, a follow-on controlled reboot was issued so
that `honey` would fall back to the persistent generic lane.

That return was confirmed:

- active kernel returned to `6.19.5-7.xr.el10`
- `uname -v` returned to `PREEMPT_DYNAMIC`
- `/sys/kernel/realtime` was absent again
- the persistent default kernel remained generic
- `next_entry` stayed empty after the return reboot

So the full one-time RT experiment is now closed end-to-end:

- arm RT through `next_entry`
- boot and validate RT once
- reboot and confirm the host is back on the generic fallback lane

## Chapel / NUMA follow-on

A Dell-owned Chapel host probe was attempted on this RT boot, but no result was
captured yet. The current blocker is still the local Chapel compiler build on
the operator machine, not a proved host-side Chapel failure on `honey`.

## Current conclusion

The first Dell-owned one-time RT validation on `honey` succeeded at the boot
control level and produced real RT evidence, but it does not yet justify
promoting RT beyond a gated validation lane.

The next sensible actions are:

- decide whether the RT overlay validator should be updated to match the live
  `linux-xr` RT kernel's `PREEMPT_DYNAMIC` posture
- gather a second RT reboot result to see whether the temporary SSH instability
  reproduces
- finish the first Dell-owned Chapel host result once the local compiler build
  is available
