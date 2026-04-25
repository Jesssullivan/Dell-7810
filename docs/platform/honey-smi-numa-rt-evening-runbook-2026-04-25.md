# Honey SMI/NUMA/RT Evening Runbook

Date: 2026-04-25

Purpose: collect the missing evidence for a defensible RT/SMI/NUMA/Chapel
writeup without turning the current blog draft into an unsupported claim.

## Current truth

- The generic-lane Chapel probe has two saved captures.
- Those two Chapel captures are not a kernel before/after comparison.
- Both captures are on `6.19.5-7.xr.el10`, generic lane,
  `PREEMPT_DYNAMIC`, same day, same host.
- The meaningful difference between them is capture/build path:
  Nix-prebuilt versus on-target build.
- RT was booted and validated separately on `6.19.5-rt1-8.xr.el10`.
- There is no saved RT-lane Chapel probe yet.
- Existing SMI/hwlat samples are short. They are enough to show nonzero SMI
  activity, not enough for a strong timing story.

## Claim gate

Do not publish a generic-versus-RT Chapel story until this packet exists:

1. Generic lane: repeated SMI/hwlat windows.
2. Generic lane: refreshed NUMA inventory and at least one Chapel probe capture.
3. RT lane: repeated SMI/hwlat windows from the same host posture.
4. RT lane: one Chapel probe capture from the same boot window, using a
   cached/prebuilt probe rather than building Chapel during the timing window.
5. Return-to-generic confirmation.

If only the generic packet exists, the safe story is still a methods/setup
note, not an RT result.

## Non-destructive generic packet

These commands do not schedule RT, reboot, or change BIOS settings.

Status: completed on 2026-04-25 with repeated 30s SMI/hwlat samples and a
store-prebuilt Chapel capture. See
[`honey-generic-smi-hwlat-series-2026-04-25.md`](honey-generic-smi-hwlat-series-2026-04-25.md).

```bash
just platform-kernel-status-remote target=jess@honey
just platform-smi-hwlat-series-remote \
  target=jess@honey \
  tag=generic-2026-04-25 \
  samples=3 \
  smi_duration=30 \
  hwlat_duration=30
# Uses an already-present Chapel store path on the target. Does not run
# nix build on honey during the timing window.
just chapel-host-capture-live-save-store \
  target=jess@honey \
  tag=generic-2026-04-25
```

Expected saved files:

- `data/captures/honey/smi-validate-generic-2026-04-25-sample-01.txt`
- `data/captures/honey/smi-validate-generic-2026-04-25-sample-02.txt`
- `data/captures/honey/smi-validate-generic-2026-04-25-sample-03.txt`
- optional, only if a Chapel 2.8.0 store path is already present:
  `data/captures/honey/chapel-host-probe-generic-2026-04-25.txt`

## RT packet

Only do this when the operator is ready for a one-time RT boot and fallback
verification. The helper preserves the persistent generic default, but a reboot
is still an operational event.

Before reboot:

```bash
just platform-kernel-status-remote target=jess@honey
just platform-kernel-schedule-next-rt-remote target=jess@honey
```

After the operator reboots and SSH returns:

```bash
just platform-kernel-status-remote target=jess@honey
just platform-validate-kernel-baseline-remote-rt target=jess@honey
just platform-smi-hwlat-series-remote \
  target=jess@honey \
  tag=rt-2026-04-25 \
  samples=3 \
  smi_duration=30 \
  hwlat_duration=30
# Uses an already-present Chapel store path on the target. The RT timing
# window should not include a compiler build.
just chapel-host-capture-live-save-store \
  target=jess@honey \
  tag=rt-2026-04-25
```

After returning to generic:

```bash
just platform-kernel-status-remote target=jess@honey
just platform-validate-kernel-baseline-remote target=jess@honey
```

Expected saved files:

- `data/captures/honey/smi-validate-rt-2026-04-25-sample-01.txt`
- `data/captures/honey/smi-validate-rt-2026-04-25-sample-02.txt`
- `data/captures/honey/smi-validate-rt-2026-04-25-sample-03.txt`
- optional, only if a Chapel 2.8.0 store path is already present:
  `data/captures/honey/chapel-host-probe-rt-2026-04-25.txt`

Known tooling caveat: if `platform-validate-kernel-baseline-remote-rt` stalls
while fetching or parsing the remote kernel config, do not let that block the
timing window. Save `platform-kernel-status-remote`, run the SMI/hwlat series,
and file the baseline-validator fix as tooling follow-up.

Chapel capture caveat: use `chapel-host-capture-live-save-store` for timing
packets. The older `chapel-host-capture-live-save-on-target` recipe is useful
for proving the full repo-local Nix build path, but it may build Chapel on
`honey`; that is not acceptable inside a timing characterization window.

## Interpretation rules

- Treat the Chapel speedup as characterization throughput, not application
  runtime performance.
- Treat SMI count and hwlat as host posture context for the Chapel run.
- Do not imply RT benefit unless generic and RT captures are paired.
- Do not imply XR or compositor benefit from this repo; that is a downstream
  `XoxDWM` `C4` claim.
- If SMI remains nonzero but hwlat stays low, say that directly. Do not call it
  "optimized" or "fixed."

## Blog posture

The blog draft should stay unpublished until the RT packet exists or until it is
intentionally rewritten as a methods-only setup note. The actual story is the
BCI/RT server characterization path; Chapel and `quickchpl` are the tools used
to make that path measurable and reviewable.
