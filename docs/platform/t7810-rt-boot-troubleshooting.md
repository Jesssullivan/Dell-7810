# T7810 RT Boot Troubleshooting

Use this note when a Dell Precision 7810 boots, stalls, or recovers differently
under the `linux-xr` PREEMPT_RT lane than it does under the generic lane.

The kernel package and installer are supplied by `tinyland-inc/linux-xr`. The
host-side diagnosis, fallback decision, and acceptance evidence belong here.

## Boundary

`linux-xr` may say:

- which RT kernel package was built,
- which installer or rollback surface exists,
- and which kernel features the package is expected to provide.

`Dell-7810` decides:

- whether `honey` can safely boot that RT kernel,
- whether the generic lane remains the persistent default,
- whether BIOS, SMI, C-state, and NUMA posture are acceptable,
- and whether the RT lane has reached `C1`, `C2`, or `C3` in the
  [`rt-research-contract.md`](rt-research-contract.md) claim ladder.

## Safe first debug posture

Do not make RT the persistent default while debugging boot behavior.

Use the one-time Dell control surface:

```bash
just platform-kernel-status-remote
just platform-kernel-schedule-next-rt-remote
just platform-kernel-clear-next-entry-remote
```

That preserves the generic `linux-xr` kernel as the fallback server lane while
still allowing a deliberate RT validation boot.

## Early boot visibility

PREEMPT_RT kernels can fail quietly during early boot because modern printk
uses threaded console behavior. Before console kthreads exist, a hang can look
like a black screen rather than a conventional panic.

Useful temporary debug parameters:

```text
earlyprintk=vga,keep ignore_loglevel debug initcall_debug nosmp nosoftlockup
```

Use them only for diagnosis. They are not the normal low-latency posture.

Progressive isolation:

- if `nosmp` works, retry with `maxcpus=1`, then `maxcpus=2`, then larger CPU
  counts until the break point is clear
- if timer behavior is suspected, test a conservative clock path with
  `clocksource=jiffies nohpet notsc`
- if local display output is still unavailable, use the internal T7810
  `SERIAL1` header with
  `earlyprintk=serial,ttyS0,115200 console=ttyS0,115200n8`

## Likely T7810-specific failure factors

These are diagnostic hypotheses, not claims that every RT boot failure has the
same cause.

| Factor | Why it matters on this host |
| --- | --- |
| Early console behavior | PREEMPT_RT can hide early hangs until console threads exist. |
| BIOS and microcode level | Factory-era firmware had older ACPI and timer behavior. `honey` is now on BIOS A34, so new results should cite current A34 evidence rather than older A02 assumptions. |
| SMI activity | C610/Wellsburg firmware can still generate management SMIs that stall all CPUs. Dell owns SMI measurement and mitigation evidence. |
| Dual-socket timer synchronization | Cross-socket TSC and APIC timer paths add risk during early scheduler and timer bring-up. |
| Deep C-state transitions | Deep idle states can add wake latency; the Dell reference posture limits the host to shallow states for RT validation. |

## SMI and timer inspection

Run these from a known-good kernel before blaming the RT package itself:

```bash
sudo hwlatdetect --duration=60 --threshold=10
sudo rdmsr -p 0 0x34
timeout 10s bash -c 'true'
sudo rdmsr -p 0 0x34
dmesg | grep -i hpet
dmesg | grep -i tsc
cat /sys/devices/system/clocksource/clocksource0/available_clocksource
```

The Dell-owned validator wraps the important parts of this path:

```bash
just platform-smi-validate-full
```

## C610 SMI register landmarks

The full SMI baseline is in [`t7810-smi-baseline.md`](t7810-smi-baseline.md).
The register landmarks most relevant to RT boot diagnosis are:

| Bit | Name | Diagnostic relevance |
| --- | --- | --- |
| 0 | `GBL_SMI_EN` | Global SMI enable. Do not clear this casually. |
| 3 | `LEGACY_USB_EN` | Legacy USB emulation SMI source. |
| 5 | `APMC_EN` | Software SMI via APM port. |
| 13 | `TCO_EN` | Watchdog-related SMI source. |
| 14 | `PERIODIC_EN` | Periodic management SMI source. |
| 17 | `LEGACY_USB2_EN` | USB 2.0 legacy emulation SMI source. |

## Fallback posture

If PREEMPT_RT is not reliable enough for the workstation role, keep the generic
`linux-xr` lane as the persistent default and use a generic full-preemption
fallback only as a clearly labeled compromise:

```text
preempt=full threadirqs
```

That fallback is useful for comparison because it provides full kernel
preemption and threaded IRQ handlers, but it is not equivalent to PREEMPT_RT
and must not be counted as `C1` or `C2` RT evidence.

## Record updates

After any RT boot experiment, update or regenerate:

- `docs/platform/honey-rt-validation-*.md`
- `dhall/defaults/honey-rt-validation-*.dhall`
- `data/captures/honey/kernel-*`
- `docs/tracking/measured-evidence-map.md`
- `docs/tracking/rt-smi-numa-chapel-focus-2026-04-25.md`

If a downstream XR or BCI result depends on the outcome, update the consumer
repo only after the Dell-owned evidence exists.
