# Honey P4 Visual First-Frame Operator-Window Packet — 2026-07-06

Status: **PREPARED / UNEXECUTED.** This is a D13 operator-window packet. Nothing
in this document has been run. It authorizes nothing by itself. It is executed
only in an attended lab window with Jess present, after the preconditions below
are re-verified live. Prepared by the Cordillera push wave (agent lane, read-only
inputs) on 2026-07-06.

Home tracker: [`TIN-346`](https://linear.app/tinyland/issue/TIN-346) (honey VR
smoke repeatability — Urgent / In Progress). The complete packet also lives as a
`TIN-346` comment stamped `[cordillera-2026-07-06]`.

## Authority split (why this doc lives here)

`Dell-7810` owns the **host-mutation mechanics** of this window: kernel
acquire/install/rollback on the T7810, `/boot` capacity, GRUB default vs one-time
next-boot, reboot, `rke2` HA safety, and the read-only host preflight. This is
the same lane as
[`linux-xr-install-and-rollback.md`](linux-xr-install-and-rollback.md),
[`kernel-lane.md`](kernel-lane.md),
[`honey-boot-device-map-2026-04-26.md`](honey-boot-device-map-2026-04-26.md), and
the characterization-window / reset-run runbooks already in this tree.

The **XR probe** half (OpenXR/Monado session bring-up, DSC/PPS capture semantics,
the HID display-wake sequence, and the P4 evidence gate) is owned by
[`Jesssullivan/XoxdWM`](https://github.com/Jesssullivan/XoxdWM) and is
**referenced, not restated** here (see
[`kernel-lane.md`](kernel-lane.md) — XR display patches and HMD bring-up stay in
XoxdWM). The kernel *artifact* (the DSC PPS debugfs carry) is owned by
[`tinyland-inc/linux-xr`](https://github.com/tinyland-inc/linux-xr) (PR #69).
`rockies` records only the composition consequence
([`docs/p4-composition-gate.md`](https://github.com/tinyland-inc/rockies/blob/main/docs/p4-composition-gate.md))
and owns none of the execution.

## Named host

- `honey` / Dell Precision T7810.
- GPU: AMD RX 9070 XT (Navi 48 / RDNA4, `1002:7550`) at PCI `05:00.0`, NUMA node 0.
- HMD: Bigscreen Beyond 2e (`35bd:0101` panel controller; `35bd:0202` Bigeye) on
  `card0-DP-1`. Tracking: two `28de:2102` Valve VR radios; `28de:2300`
  Watchman/Tundra tracker.
- Dell management panel: `card0-HDMI-A-1`.
- Boot stack (do not confuse): `/boot` + ESP on the Micron SATA SSD `/dev/sda`
  (`/boot` -> `/dev/sda2`); root LVM `rl00-root` on the Crucial NVMe `/dev/nvme0n1`.
  See [`honey-boot-device-map-2026-04-26.md`](honey-boot-device-map-2026-04-26.md).

## Current state (re-verify at the window — this is ~7 weeks stale)

- Running kernel: `6.19.5-11.xr.el10` (xr11), the persistent GRUB default and
  known-good generic lane (validated under `TIN-1180`, Done 2026-05-17).
- Proof-ladder classification: **P3 pass / P4 fail**. Freshest evidence is the
  2026-05-16 lab pass: OpenXR session reached `FOCUSED` with `3561x3561` eye
  swapchains and a same-boot DP-1 lease/link/DSC-active proof, but the goggles
  never retained visible non-black output.
- Leading root-cause hypothesis: **retained panel/display-state failure**.
  `35bd:0101` accepts `OnHidOpen`, `SetVideoConfig dp_training=1`, backlight gain,
  and unmute, but `video_state` stays at `0:DP Init` and backlight readback stays
  `0.0`. A sub-second edge-light/backlight flash during Dell/display init is
  panel-power evidence, **not** P4.
- `rke2-server` active — honey is a live 3-node HA control-plane / etcd member.
  **Never stop `rke2` as a reset lever (D13).**
- Sources (owning repos): XoxdWM
  [`status.md`](https://github.com/Jesssullivan/XoxdWM/blob/main/docs/status.md),
  [`support-matrix.md`](https://github.com/Jesssullivan/XoxdWM/blob/main/docs/support-matrix.md),
  [`research/honey-beyond-black-display-history-2026-05-16.md`](https://github.com/Jesssullivan/XoxdWM/blob/main/docs/research/honey-beyond-black-display-history-2026-05-16.md).

## Kernel option matrix (operator rules at the window)

| Option | Kernel | What it buys | Cost / risk | Verdict |
| --- | --- | --- | --- | --- |
| **A (primary)** | rebuilt `kernel-xr-6.19.5-12.xr.el10` (DSC-observability; carries linux-xr PR #69 read-only PPS debugfs at `dbfcd3938a2f3`) | Adds the **read-only PPS debugfs surface** so packed DSC PPS can be captured during a live OpenXR presentation, closing the "is DSC the black-screen cause?" question. | xr11 **already carries the DSC *fix*** (`0007-vesa-dsc-bpp.patch`, BPP parser + QP/RC), so this is **observability only, not a visual fix**. Requires an artifact rebuild (see Precondition P0). Adds `/boot` pressure + one reboot. | Per operator ruling on `TIN-346` ([audit-2026-07-01]: "DSC observability kernel install first"), this is the directed path. |
| **B (deferred / blocked)** | fresh xr12 → 7.1.y rehome candidate (ruling A, 2026-07-06) from the K-PORT lane | The live-stable-line rehome the ROCm/display ingestion wants long-term. | **Not available.** As of 2026-07-06 there is **no 7.1.y branch or PR in linux-xr** and no landed K-PORT PR; a fresh 7.1.y base is unproven on honey and would need its own `TIN-1180`-class boot validation before any XR attempt. | Do **not** use this window. May supersede A in a later window *iff* K-PORT lands, ports the DSC/PPS carries, and passes honey boot-validation. |
| **A′ (fallback)** | stay on `6.19.5-11.xr.el10` (xr11) | Runs the P3→P4 probe + read-only Watchman/HID audit + human observation with **no kernel mutation**, directly testing the leading (panel-state) hypothesis. | Skips PPS capture (xr11 does not expose the PPS debugfs surface). | Use if the artifact rebuild is not feasible in the window, or if `/boot`/`rke2` gates fail. Lowest risk. |

**Boot-safety model (all options):** arm any new kernel as a **one-time next
boot** via `grub2-reboot` / `next_entry`, **not** `grubby --set-default`. Keep
xr11 as the persistent default so a plain reboot returns to known-good. This is
the Dell "one-time RT boot rule" applied to the diagnostic kernel
([`linux-xr-install-and-rollback.md`](linux-xr-install-and-rollback.md)).

## Preconditions (all must hold before any mutation)

- **P0 — DSC-observability artifact must be rebuilt (BLOCKER for Option A).**
  The originally-built artifact `kernel-xr-rpms-generic` from linux-xr Actions run
  `25710987473` (`6.19.5-12.xr.el10`, 134 MB) **expired 2026-06-11** (90-day
  retention); it is no longer downloadable. Before the window, re-dispatch
  `.github/workflows/build-kernel.yml` on linux-xr `xr/main` (`variant=generic`)
  to regenerate `kernel-xr-6.19.5-12.xr.el10` (or a newer xrN carrying PR #69),
  and record the fresh run ID + artifact name. Owning repo: **linux-xr**.
  Pre-stage this **before** the attended window to compress duration.
- **Fresh preflight capture (D13-required).** From `neo`, in the `rockies` repo:
  `bazel/capture-tinyland-lab-host-rollout-preflight.sh --host honey`. This is
  read-only (no installs/kernels/bootloader/DM/reboot). It records: kernel,
  `boot_id`, `df -h / /boot /boot/efi`, installed kernel packages, wayland
  sessions, `/boot` vmlinuz/initramfs file sizes, and (privileged)
  `grubby --default-index/--default-kernel/--default-title`, `grub2-editenv list`,
  and `grubby --info=ALL`. Save to
  `.artifacts/tinyland-lab-host-rollout-preflight/<UTC>-honey.txt`.
- **`/boot` capacity gate.** Last known: **278 MB free / 68% used** (`TIN-1180`,
  post-xr11-cleanup). A new kernel + initramfs is ≈100–150 MB. **Gate:** confirm
  ≥ ~180 MB free after accounting for the new kernel. If tight, remove **one**
  obsolete kernel FIRST (candidate: the `6.19.5-9.xr.el10` xr9 rollback), keeping
  xr11 default + stock `6.12.0-124.8.1.el10_1` + rescue. This mirrors the proven
  `TIN-1180` "remove obsolete kernel first" pattern.
- **`rke2` HA state check.** `systemctl is-active rke2-server` = `active`; confirm
  the 3-node control plane / etcd quorum can tolerate honey rebooting (honey
  briefly down). If quorum cannot tolerate it, **abort before reboot**. Never
  stop/drain/restart `rke2` (D13).
- **Altar-independence: n/a.** honey is a server (Dell-7810 XR target + rockies
  bazel-proof host), not the ALTAR candidate (that is `yoga`). No altar coupling
  to clear.
- **Sudo/become lane.** `just honey-sudo-check honey` (XoxdWM) — host-local
  sops-nix become; no hard-coded password in run notes.
- **Display topology written into run notes.** Dell HDMI connected? BS2E DP path
  connected/enumerated? BS2E has historically needed a **physical reseat** to
  appear as a connected DRM connector with EDID (2026-05-05 precedent). Do not
  proceed to OpenXR until `card0-DP-1` shows `connected` + non-zero EDID.
- **Consumer readiness confirmed** (see "Compositor readiness" below) — the P4
  frame path is proven to P3; no compositor work gates this window.

## Ordered action set (attended window)

**Phase 0 — pre-change capture & gates (read-only).**
1. Fresh preflight capture (above); confirm kernel/boot_id/`/boot` free/grubby
   default.
2. `/boot` gate; `rke2` health; `just honey-sudo-check honey`; topology note.
3. Read-only panel-state baseline: `just honey-watchman-readonly-audit honey`
   (records `28de:2300` / `35bd:0101` hidraw inventory + descriptors; no writes).
4. Read-only XR baseline on xr11: `just honey-openxr-status honey` and
   `just honey-kernel-dsc-truth honey auto` (expected `pps_available=false` on
   xr11 — this is the "before" for the PPS surface).

**Phase 1 — kernel acquire (Option A).** Download the rebuilt
`kernel-xr-6.19.5-12.xr.el10` RPM set (from the fresh Actions artifact, P0) to a
staging dir on honey. (Option A′ skips Phases 1–6.)

**Phase 2 — `/boot` headroom (only if the gate failed).** Remove one obsolete
kernel (e.g. `dnf remove kernel-xr-6.19.5-9.xr.el10`) via the established path;
re-verify `/boot` free. Never remove xr11, stock, or rescue.

**Phase 3 — install, no default change.** `sudo dnf install
./kernel-xr-6.19.5-12.xr.el10*.rpm`. Do **not** set default. Verify the new entry
with `sudo grubby --info=ALL`. Capture a post-install / pre-reboot preflight.

**Phase 4 — arm one-time boot.** `sudo grub2-reboot <index-of-xr12-entry>` (leave
`grubby --default-kernel` = xr11). Confirm `grub2-editenv list` shows `next_entry`
set to the xr12 entry.

**Phase 5 — attended reboot.** Exactly one attended warm reboot. Do **not** touch
`rke2`. Watch the Dell panel + BS2E for boot-time display events; record any
transient edge-light/backlight event per the XoxdWM P4 template.

**Phase 6 — post-boot verify.** `uname -r` = `6.19.5-12.xr.el10`; `boot_id`
changed; `rke2-server` active; SELinux `Enforcing`. Capture a post-boot preflight.

**Phase 7 — display/Mesa/Vulkan userspace verify (display-first, NO HIP).**
Per [`rockies` `manifests/dependencies/rocm.yaml`](https://github.com/tinyland-inc/rockies/blob/main/manifests/dependencies/rocm.yaml)
(`TIN-2575`), confirm the pinned Rocky 10 userspace is present at the recorded
`export_line` versions: `mesa-* 25.0.7-6.el10_1`, `libdrm 2.4.123-1.el10`,
`vulkan-loader 1.4.313.0-1.el10`, `vulkan-tools 1.4.313.0-1.el10`,
`amd-gpu-firmware / linux-firmware 20260107-19.2.el10_1`. `rocm.yaml` records
these as **already installed on honey** — this is a **verify, not an install**.
Install **nothing** from the HIP/ROCm-compute stack (D4 display-first).

**Phase 8 — P3→P4 probe (XoxdWM-owned; per the evidence template).**
Follow [`honey-p4-visual-first-frame-evidence-template.md`](https://github.com/Jesssullivan/XoxdWM/blob/main/docs/honey-p4-visual-first-frame-evidence-template.md)
and [`honey-pps-diagnostic-runbook-2026-05-12.md`](https://github.com/Jesssullivan/XoxdWM/blob/main/docs/honey-pps-diagnostic-runbook-2026-05-12.md):
1. Bring up compositor + Monado user services; if the compositor was restarted,
   restart `exwm-vr-monado.service` so Monado reacquires the DP-1 lease (the
   2026-05-16 lease-reacquire rule).
2. `just honey-kernel-dsc-truth honey auto` — now with `pps_available=true`;
   capture `pps_sha256`, `pps_bits_per_pixel_x16`, `pps_pic_*`, `pps_slice_*`,
   `pps_rc_ranges_bpp8_444_patched/_stock`.
3. `just honey-openxr-smoke honey -- --timeout 120` — `hello_xr -g Vulkan`
   selects Monado / Bigscreen Beyond, creates `3561x3561` eye swapchains, reaches
   `READY -> SYNCHRONIZED -> VISIBLE -> FOCUSED`. Confirm DP-1 lease/link/DSC
   active. Capture the panel `video_state` during the active session.

**Phase 9 — HID display-wake init hypothesis test (leading root cause).**
- **Default (read-only):** the `just honey-watchman-readonly-audit honey`
  inventory from Phase 0 plus the live `video_state` read in Phase 8.
- **Operator-gated write sub-step (explicit approval REQUIRED, not default):**
  drive the `35bd:0101` wake sequence
  (`810600220000` ×3, `810600220100`, `810600220200`) and, if approved, the
  `28de:2300` Watchman video-config path. **Watchman report IDs and side effects
  are not fully understood** — the black-display history explicitly warns "do not
  replay unknown Watchman reports until the report IDs and side effects are
  understood." **Abort this sub-step on any unexpected Watchman/hidraw state
  change.** Treat any panel wake as diagnostic until a **sustained non-black
  frame** is human-observed.

**Phase 10 — human observation + classification.** Per the template's Human
Visual Observation section, set `visual_observed=yes|no|not_observed`. If `yes`,
re-run the smoke with the confirmation gate:
`EXWM_VR_VISUAL_OBSERVED=yes EXWM_VR_VISUAL_OBSERVER=<id>
EXWM_VR_VISUAL_CONFIRMATION=VISIBLE_NON_BLACK just honey-openxr-smoke honey -- --timeout 120`.
Before any P4-pass claim, run `just honey-p4-evidence-check <filled-packet>.md`
and `./packaging/scripts/exwm-vr-p4-evidence-check --require-p4 <filled-packet>.md`.

**Phase 11 — capture the evidence packet.** Fill the XoxdWM
`honey-p4-visual-first-frame-evidence-template.md`; post the tracker comment draft
to `TIN-346` and GitHub `#49`; link any Dell-7810 host/reset artifact and the
linux-xr artifact used.

## Rollback path

- **Default is self-rollback:** because xr12 was armed one-time only (Phase 4), a
  plain reboot returns honey to xr11 (persistent default). No action needed to
  recover the known-good lane.
- **If booted into xr12 and it misbehaves:**
  `sudo grubby --set-default /boot/vmlinuz-6.19.5-11.xr.el10`, reboot, verify
  `uname -r` and `sudo grubby --default-kernel`. Rollback set on honey: **xr11
  (primary known-good)**, `6.19.5-9.xr.el10` (xr9), stock
  `6.12.0-124.8.1.el10_1`, rescue.
- **To retire the diagnostic kernel after the window:** `sudo dnf remove
  kernel-xr-6.19.5-12.xr.el10`; re-verify `/boot` free and `grubby --default-kernel`.
- **`rke2`:** no rollback step ever touches `rke2`.

## Abort criteria

- `rke2` control-plane quorum cannot tolerate honey rebooting → abort before
  reboot; fall back to Option A′ (probe on xr11 without reboot) or reschedule.
- `/boot` free below the required threshold after removing one obsolete kernel →
  abort the kernel swap; fall back to Option A′.
- Fresh artifact rebuild (P0) unavailable/failed → fall back to Option A′ or
  reschedule.
- BS2E not enumerating as a `connected` DRM connector with EDID → do not proceed
  to OpenXR; narrow to enumeration/reseat (2026-05-05 precedent), record, stop.
- Any unexpected Watchman/hidraw state change during the Phase 9 write sub-step →
  abort the write path immediately; keep read-only evidence.
- Dell panel instability or degraded remote recovery → abort, roll back to xr11.

## Expected duration

≈ 2.0–3.0 h attended (excluding the pre-staged artifact rebuild): preflight +
gates ~15 min; kernel install + one-time-arm + reboot + verify ~20–30 min;
userspace verify ~10 min; P3→P4 probe + PPS capture ~30–45 min; HID sub-step +
human observation ~20–30 min; evidence packet ~15 min. **Pre-stage the P0
rebuild + download before the window** to keep the attended block tight.

## Success framing + interim milestones (from the current P3-pass/P4-fail state)

- **Full success (window goal):** **P4 pass** — human-observed *sustained*
  non-black BS2E output, evidence-checker-clean, landed on `TIN-346`. This flips
  the `rockies` P4 composition-gate consequence: the XoxdWM XR session stops being
  composition-blocked at P4 (P5 fresh-boot repeatability then becomes the next
  XoxdWM gate, not a rockies concern).
- **Strong interim (most likely; NOT a wasted window):** P3 re-confirmed on the
  diagnostic kernel **plus the first live-session packed-PPS capture** (rules DSC
  in/out as the black-screen cause) **plus a Watchman `video_state` read during an
  active `FOCUSED` session**. This is exactly the "Safe Next Evidence" the
  black-display history asks for, and it materially advances the retained-panel-
  state root cause.
- **Diagnostic interim (Option A′):** P3 re-confirmed + read-only Watchman/HID
  audit refreshed *with services up during a live session* → narrows the panel-
  state lane without a kernel mutation.
- **Milestone floor:** any recorded classification (host/substrate,
  packaging/deployment, compositor/runtime, product/visual) per the template is a
  milestone. The window is "wasted" only if it produces no recorded
  classification.

## Compositor readiness — is the window worth scheduling? Yes.

- **XoxdWM PR #112** (`harvest/native-authority-residue-20260701`, updated
  2026-07-02) is a **DRAFT preservation branch** of native-authority worktree
  residue, explicitly *"not intended to merge as-is"* (the compositor pod
  cherry-picks). It is **not** a frame-loop implementation and **not** on the P4
  critical path. Its useful cherry-pick candidates (e.g. `honey-p4-gate-test.el`,
  `honey-display-regression-test.el`, `compositor/src/vr/anchor.rs`, P4 proof
  templates) do not gate this window.
- **The P4-consuming frame path is already proven to P3:** `ewwm-compositor`
  grants a real `wp_drm_lease_v1` DRM lease to Monado; Monado + the packaged
  `hello_xr` reach `FOCUSED` with `3561x3561` eye swapchains; and the compositor
  has separately rendered a **full known-pixel framebuffer to the Dell DRM
  output** (2026-05-15 white-pattern readback, `nonzero_bytes=8294400`). Frame
  submission works; the block is **panel display-state retention, not compositor
  readiness**.
- **Therefore a P4-pass is immediately consumable:** the smoke client renders
  frames now, and a real XR session post-P4 uses the same proven
  lease/compositor path (Smoke tier). No compositor work is required to make this
  window productive.

## Non-claims / gates honored

- This packet installs nothing, reboots nothing, and touches no host until an
  attended operator window with a fresh live preflight (D13).
- No upstream sends of any kind. The Bigscreen Beyond EDID upstream lane is
  decided **HOLD** (D15).
- `rke2` is never stopped, drained, or restarted (D13).
- Display-first only; the HIP/ROCm-compute stack is out of scope (D4).
- The XR-probe internals, the P4 gate definition, and the PPS/DSC/HID semantics
  are owned by XoxdWM/linux-xr and referenced here, not redefined (D11).

## Cross-references

- Tracker: `TIN-346` (home), `TIN-1180` (Done — the xr11 kernel-swap precedent
  this reuses), `TIN-2578` (P4 gate ratified), `TIN-2575` (`rocm.yaml`
  display-first), `TIN-398` (C0–C4 claim ladder).
- linux-xr: PR #69 (`dbfcd3938a2f3`, DSC PPS debugfs carry, merged 2026-05-12);
  rebuild via `.github/workflows/build-kernel.yml` on `xr/main`.
- XoxdWM: `honey-p4-visual-first-frame-evidence-template.md`,
  `honey-pps-diagnostic-runbook-2026-05-12.md`,
  `honey-fresh-boot-runbook-2026-04-26.md`,
  `research/honey-beyond-black-display-history-2026-05-16.md`, `support-matrix.md`,
  `status.md`.
- Dell-7810: [`linux-xr-install-and-rollback.md`](linux-xr-install-and-rollback.md),
  [`kernel-lane.md`](kernel-lane.md),
  [`honey-boot-device-map-2026-04-26.md`](honey-boot-device-map-2026-04-26.md),
  [`reset-run-template.md`](reset-run-template.md).
- rockies: [`docs/p4-composition-gate.md`](https://github.com/tinyland-inc/rockies/blob/main/docs/p4-composition-gate.md).
