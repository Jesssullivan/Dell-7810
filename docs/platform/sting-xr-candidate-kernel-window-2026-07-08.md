# Sting XR-Candidate Kernel-Window Operator Packet — 2026-07-08

Status: **PREPARED / UNEXECUTED.** This is a D13 operator-window packet. Nothing
in this document has been run. It authorizes nothing by itself. It is executed
only in an attended lab window with Jess present, after the preconditions below
are re-verified live. Prepared by the Cordillera ratification wave (agent lane,
read-only probes only) on 2026-07-08 under operator ratification R2 (`[cordillera-2026-07-08]`).

Home tracker: [`TIN-2582`](https://linear.app/tinyland/issue/TIN-2582) (sting
xr-kernel lag + `/boot` capacity — the Cordillera fleet-hygiene gap). The window
packet is posted as a `TIN-2582` comment stamped `[cordillera-2026-07-08]` and
cross-linked on [`TIN-346`](https://linear.app/tinyland/issue/TIN-346) (honey P4
first-frame — where the actual Beyond-2e visual diagnosis stays).

---

## ⚠ Load-bearing hardware-delta finding (read first)

Operator ratification **R2** designated `sting` as the XR-candidate / diagnosis
host on the premise that it *"shares similar hardware to honey."* A read-only SSH
probe battery on 2026-07-08 confirms that premise **for the chassis/platform and
refutes it for the GPU** — and the GPU is the load-bearing component for this
specific (Bigscreen Beyond 2e first-frame / AMD-DSC) diagnosis.

| Component | honey (XR host) | sting (candidate) | Verdict for this diagnosis |
| --- | --- | --- | --- |
| Chassis / platform | Dell Precision Tower 7810 | Dell Precision Tower 7810 (`Dell Inc. / Precision Tower 7810`, confirmed via DMI) | **Same** — kernel/boot/NUMA/RKE2 mechanics transfer |
| GPU | AMD RX 9070 XT (Navi 48 / RDNA4, `1002:7550`, `amdgpu`) | **2× NVIDIA GK107 [NVS 510]** (`10de:0ffd`, rev a1) on the **`nouveau`** driver, at PCI `02:00.0` + `03:00.0` | **Materially different** — see transfer table below |
| Display pipe | DisplayPort 1.4 **with DSC** (needed to light the Beyond 2e native panels) | NVS 510 = **DisplayPort 1.2, no DSC**; 8× Mini-DP outputs (`card0-DP-1..4`, `card1-DP-5..8`) | Cannot drive the Beyond 2e at native mode |
| OpenXR/Vulkan runtime | Mesa RADV 25.0.7 (RDNA4, full Vulkan) | Mesa 25.0.7 present, but on **Kepler/nouveau there is no viable modern Vulkan/OpenXR path** (NVK requires Turing+; the last proprietary NVIDIA driver supporting Kepler is the EOL 470 legacy branch, which does not support Rocky 10 / kernel 6.19) | No Monado / `hello_xr -g Vulkan` path |

**Bottom line:** the *kernel + `/boot` + reboot + RKE2-quorum-safety* half of this
window is fully valid on `sting` and de-risks the honey xr line. The *GPU / DSC /
Bigscreen-first-frame diagnosis* half is **not reproducible on `sting`** and does
**not** transfer to honey. The linux-xr **PR #69** carry is an **AMD DSC PPS
debugfs** surface (`amdgpu`-only); on a NVIDIA-only host it never binds a device
and captures nothing. Steps 4–5 below are therefore recorded as **BLOCKED / NOT
RECOMMENDED on `sting`**, with the actual Beyond-2e P4 diagnosis routed back to
the honey packet (`TIN-346`). This is the honest hardware-delta the operator
asked to have surfaced before the physical move.

### What transfers to honey vs what does not

- **Transfers (same T7810 platform):** the `/boot` cleanup procedure; the xr9→xr11
  kernel catch-up and rollback mechanics; the one-time-next-boot GRUB rule; the
  linux-xr generic supplier surface; the RKE2 embedded-etcd-member reboot-safety
  model; a **boot-validation of the diagnostic kernel *package* on a T7810
  chassis** (does the RPM install and boot cleanly on this hardware class).
- **Does NOT transfer:** any AMD DSC PPS capture (no `amdgpu` on sting); any
  Beyond-2e panel-state / `video_state` / HID display-wake observation (no
  DSC-capable DP pipe, no OpenXR/Vulkan path on Kepler/nouveau); any P3→P4 visual
  first-frame conclusion. Those remain honey-only work under `TIN-346`.

---

## Authority split (why this doc lives in Dell-7810)

`sting` is a **Dell Precision Tower 7810**, the same platform the Dell-7810
platform lane already owns for `honey`. Per
[`docs/platform/README.md`](README.md), this repo owns *"workstation power and
reset behavior, Dell 7810 BIOS/SMI/recovery-path characterization, and
low-latency host validation that depends on T7810 hardware specifics."* A kernel
install / `/boot` cleanup / attended-reboot window on a T7810 is exactly that
host-mutation-mechanics lane — the same lane as
[`linux-xr-install-and-rollback.md`](linux-xr-install-and-rollback.md),
[`kernel-lane.md`](kernel-lane.md), and
[`reset-run-template.md`](reset-run-template.md). This packet is a **direct
adaptation of the sibling** [`honey-p4-visual-first-frame-operator-window-2026-07-06.md`](honey-p4-visual-first-frame-operator-window-2026-07-06.md),
reusing its structure, boot-safety model, and rollback discipline (per the R2
directive: reuse, do not reinvent; adapt host names/connectors).

Scope boundaries honored:
- The **XR-probe internals** (OpenXR/Monado bring-up, DSC/PPS semantics, the P4
  gate) stay owned by [`Jesssullivan/XoxdWM`](https://github.com/Jesssullivan/XoxdWM)
  and are **referenced, not restated** — and are BLOCKED on sting regardless.
- The **kernel artifact** (DSC PPS debugfs carry) is owned by
  [`tinyland-inc/linux-xr`](https://github.com/tinyland-inc/linux-xr) (PR #69).
- `sting`'s **fleet / cluster / storage / RKE2 identity** is owned by
  [`tinyland-inc/lab`](https://github.com/tinyland-inc/lab)
  (`inventory/host_vars/sting.yml`, `TIN-295` maintenance, `TIN-617` HA) and by
  `blahaj` for cluster-facing truth — **cross-linked here, not duplicated**.
- `rockies` records only the composition consequence
  ([`docs/p4-composition-gate.md`](https://github.com/tinyland-inc/rockies/blob/main/docs/p4-composition-gate.md))
  and the fleet-hygiene anchor (`TIN-2582`, surfaced by
  `docs/cordillera-machine-matrix-2026-07-06.md`).

> Home-repo note: the counter-argument is that `sting`'s fleet identity lives in
> `lab`, so a `lab/docs/agent-notes/` home would also be defensible. This packet
> is homed in Dell-7810 because (a) `sting` is literally a T7810 and this is a
> T7810 host-mutation-mechanics window, (b) it is a direct adaptation of the
> honey packet that lives in this exact directory and references the same sibling
> mechanics docs, and (c) the only precedent for a kernel-install operator-window
> *packet* of this shape is here, not in `lab`. `lab` remains the owner of
> sting's Ansible/Nix/cluster config and is cross-linked.

## Named host

- `sting` / Dell Precision Tower 7810 (DMI: `Dell Inc.` / `Precision Tower 7810`).
- Role: RKE2 **server / embedded-etcd member** (compute-expansion node); etcd
  member id `1c95c2eabb6abf01` in the honey/sting/bumble three-server quorum
  (`TIN-617`). A live tcfs FUSE mount is present at `/home/jess/tcfs`.
- GPU: **2× NVIDIA GK107 [NVS 510]** (`10de:0ffd`) on `nouveau`, PCI `02:00.0`
  and `03:00.0`. DRM connectors: `card0-DP-1..4`, `card1-DP-5..8` (all
  DisplayPort). **No AMD GPU present; no `amdgpu`/`radeon` module loaded.**
- Display manager: **GDM active**; wayland-sessions = `gnome` / `gnome-wayland`
  only (no Budgie/labwc, no `xoxdwm`/`exwm-vr` — sting is **not** an XR-configured
  host and, per `TIN-2582` non-claims, is **not** a Budgie host).
- Boot stack: `/boot` -> `/dev/nvme0n1p2` (1 GB partition), ESP ->
  `/dev/nvme0n1p1` (`/boot/efi`), root LVM `rl-root` on `/dev/nvme0n1p3`. Cluster
  storage (rancher/containerd/nix/data) is on separate `sda`/`sdb`/`nvme1n1` LVM
  — **do not confuse the boot NVMe with the cluster storage disks.**

## Current state (re-verify at the window — probed read-only 2026-07-08)

- Running kernel: **`6.19.5-9.xr.el10` (xr9)**. Installed kernel-xr packages:
  `kernel-xr-6.19.5-7.xr.el10` (xr7) **and** `kernel-xr-6.19.5-9.xr.el10` (xr9);
  stock `kernel-6.12.0-124.47.1.el10_1` also installed. `honey` and `mbp-13` run
  **xr11 (`6.19.5-11.xr.el10`)** — sting lags the published line by two xr revs.
- `/boot`: **73% used, ~232 MB free** (`849M` total, `617M` used on
  `/dev/nvme0n1p2`). `/boot` contents: `vmlinuz` + `initramfs` for stock 6.12,
  xr7, xr9, plus a rescue image; xr7/xr9 each carry a ~155 MB initramfs + ~40 MB
  kdump image. **The stale xr7 line is the obvious removable** (two revs back, not
  running, not the immediate rollback).
- OS: Rocky Linux 10.1 (Red Quartz). Mesa 25.0.7-6. Home-Manager generation 35
  (current, 2026-07-06). No passwordless sudo (attended-window sudo only).
- `rke2-server` **active**; `rke2-agent` inactive. sting is a live etcd voter.

## RKE2-scoped safety note (D13 — load-bearing)

`sting` is one of **three** RKE2 server / embedded-etcd voters
(honey `b1d6b8eb8ff1b710`, sting `1c95c2eabb6abf01`, bumble `97469e6753157feb`;
`TIN-617`). An odd-3 etcd quorum tolerates **exactly one** member down. Therefore:

- A single attended `sting` reboot is quorum-safe **only if honey and bumble are
  both healthy etcd members at reboot time.** Confirm all three are `Ready` /
  etcd-healthy **before** arming any reboot. If honey or bumble is down/unhealthy,
  **abort before reboot** — do not create a two-of-three-down condition.
- **Never stop, drain-as-a-reset-lever, or `systemctl stop rke2-server` on sting**
  (or honey/bumble). The reboot lets `rke2-server` restart cleanly on its own;
  that is the only RKE2 state change permitted, and it is a restart, not a stop.
- Workload mobility off sting is a known **expected-red** gate (`TIN-617`:
  `honey-drain-readiness` / production-HA blockers). Pods on sting will be briefly
  unavailable across the reboot. For a brief single-node reboot this is acceptable
  **iff** the operator has confirmed no non-replicated critical workload is
  pinned sting-only at window time. Optionally `kubectl cordon sting` before and
  `uncordon` after; do **not** hard-drain (mobility is not proven).
- This is **not** the honey/sting HA design work — that stays `TIN-617`. This
  window only reboots sting once for a kernel catch-up.

## Kernel option matrix (operator rules at the window)

| Option | Kernel | What it buys | Cost / risk | Verdict |
| --- | --- | --- | --- | --- |
| **A (primary)** | catch up to `kernel-xr-6.19.5-11.xr.el10` (xr11), the current published line (linux-xr release `v6.19.5-xr11`) | Converges sting to the fleet xr line (`TIN-2582` acceptance); removes the xr7/xr9 lag; keeps sting a healthy current-line xr server. | One `/boot` cleanup + one attended reboot on an etcd member. No GPU/XR risk. | **Directed path.** This is the real, transferable value of the sting window. |
| **B (optional, low-value on sting)** | add the DSC-observability diagnostic kernel `kernel-xr-6.19.5-12.xr.el10` (carries linux-xr PR #69 AMD DSC PPS debugfs) | On sting, buys **only** a *T7810-chassis boot-validation of the diagnostic RPM* (does it install + boot cleanly). | The PR #69 debugfs surface is **`amdgpu`-only and inert on sting** (NVIDIA-only host); adds `/boot` pressure + a second reboot for near-zero diagnostic return. Requires the P0 artifact rebuild. | **Defer.** Only do this if the operator specifically wants the package boot-validated on a T7810 before the honey install. It produces **no** DSC/PPS data on sting. |
| **A′ (fallback)** | stay on xr9, `/boot` cleanup only | Reclaims `/boot` headroom (remove xr7) with no kernel change. | Leaves sting behind the published xr line. | Use if the xr11 acquire is unavailable in the window, or if the RKE2 quorum gate fails. Lowest risk. |

**Boot-safety model (all options):** stage the new kernel with
**`--no-set-default`** and arm it as a **one-time next boot** via `grub2-reboot` /
`next_entry`, **not** `grubby --set-default`. Keep the current known-good default
until the new kernel is boot-validated; only then promote xr11 to the persistent
default (keeping xr9 as the recorded rollback). This is the Dell "one-time boot
rule" from [`linux-xr-install-and-rollback.md`](linux-xr-install-and-rollback.md).

## Preconditions (all must hold before any mutation)

- **Fresh preflight capture (D13-required).** From `neo`, in the `rockies` repo:
  `bazel/capture-tinyland-lab-host-rollout-preflight.sh --host sting`. Read-only
  (no installs/kernels/bootloader/DM/reboot). Records kernel, `boot_id`,
  `df -h / /boot /boot/efi`, installed kernel packages, wayland sessions,
  `/boot` vmlinuz/initramfs sizes, and (privileged) `grubby --default-index /
  --default-kernel / --default-title`, `grub2-editenv list`, `grubby --info=ALL`.
  Save to `.artifacts/tinyland-lab-host-rollout-preflight/<UTC>-sting.txt`.
- **`/boot` capacity gate.** Known: **~232 MB free / 73% used**. A new kernel +
  initramfs is ≈150–210 MB (xr initramfs ~155 MB + kdump ~40 MB + vmlinuz ~16 MB).
  **Gate:** remove the stale **xr7** line FIRST to reclaim ~210 MB, then confirm
  ≥ ~180 MB free after accounting for xr11. Keep xr9 (running/rollback), stock
  6.12, and rescue.
- **RKE2 quorum gate.** `systemctl is-active rke2-server` = `active` on sting;
  confirm honey + bumble are both `Ready` and their etcd members healthy so the
  quorum tolerates sting rebooting. If not, **abort before reboot** (fall back to
  A′). Never stop/drain-as-reset `rke2`.
- **Sudo lane.** sting has no passwordless sudo; the attended operator runs each
  privileged step interactively (or via the lab sops-backed become path). No
  hard-coded password in run notes.
- **Option B only — DSC artifact rebuild (P0 blocker, same as the honey packet).**
  The originally-built `kernel-xr-6.19.5-12.xr.el10` artifact from linux-xr
  Actions expired (90-day retention). If Option B is pursued, first re-dispatch
  `.github/workflows/build-kernel.yml` on linux-xr `xr/main` (`variant=generic`)
  to regenerate the RPM set carrying PR #69, and record the fresh run ID +
  artifact name. Owning repo: **linux-xr**. Pre-stage before the window.
- **Options 4–5 (Beyond move + P4 probe) do not apply on sting** — see the
  hardware-delta finding. No display/HMD precondition is listed because the step
  is BLOCKED, not gated.

## Ordered action set (attended window)

The operator-requested step order (0–7) is preserved. Steps 0–3 are the real,
executable sting window; steps 4–5 are recorded as BLOCKED with the honest
rationale; steps 6–7 close out.

**(0) Fresh preflight capture + RKE2 safety note.**
1. Run the `rockies` preflight capture (Preconditions); record kernel / `boot_id`
   / `/boot` free / grubby default.
2. Confirm the RKE2 quorum gate (honey + bumble healthy; sting reboot tolerable).
   Optionally `kubectl cordon sting`.
3. Confirm `/boot` free and enumerate installed kernels (`rpm -qa | grep ^kernel`,
   `ls /boot/vmlinuz-*`).

**(1) `/boot` cleanup (TIN-2582).** Remove the stale xr7 line:
`sudo dnf remove kernel-xr-6.19.5-7.xr.el10`. Re-verify `/boot` free (`df -h /boot`)
and that `grubby --info=ALL` no longer lists an xr7 entry. **Never remove** xr9
(running/rollback), stock 6.12, or rescue.

**(2) Kernel catch-up xr9 → xr11 (`6.19.5-11.xr.el10`).**
1. Acquire without changing the default (staged posture from
   [`linux-xr-install-and-rollback.md`](linux-xr-install-and-rollback.md)):
   `curl -fsSL https://tinyland-inc.github.io/linux-xr/install/rocky10-generic.sh | bash -s -- --no-set-default`
   (or `--download-only --target-dir <staging>` then `sudo dnf install ./kernel-xr-6.19.5-11.xr.el10*.rpm`).
2. Verify the new entry exists: `sudo grubby --info=ALL | grep 6.19.5-11`. Capture
   a post-install / pre-reboot preflight.
3. Arm one-time boot to xr11: `sudo grub2-reboot <index-of-xr11-entry>`; confirm
   `grub2-editenv list` shows `next_entry` = the xr11 entry. Leave the persistent
   default unchanged for now.
4. **Attended reboot** (exactly one; do **not** touch `rke2`). After boot:
   `uname -r` = `6.19.5-11.xr.el10`; `boot_id` changed; `systemctl is-active
   rke2-server` = `active`; SELinux `Enforcing`; sting rejoins the etcd quorum
   (verify member health). Optionally `kubectl uncordon sting`.
5. **Promote xr11 to persistent default** once validated:
   `sudo grubby --set-default /boot/vmlinuz-6.19.5-11.xr.el10`; verify
   `sudo grubby --default-kernel`. Keep **xr9** as the recorded rollback. Capture
   a post-boot preflight. This closes the `TIN-2582` catch-up.

**(3) DSC-observability kernel (linux-xr PR #69 / `6.19.5-12.xr.el10`) — OPTIONAL, boot-validate-only.**
> **On sting this produces no DSC data.** PR #69 exposes the *AMD* DSC PPS through
> `amdgpu` connector debugfs; sting has no AMD GPU, so `amdgpu` never binds and the
> debugfs node never appears. Pursue this step **only** if the operator wants the
> diagnostic RPM boot-validated on a T7810 chassis before the honey install.
If pursued: complete P0 (rebuild the artifact); if `/boot` is tight after xr11,
remove xr9 first (now that xr11 is the validated default); `sudo dnf install
./kernel-xr-6.19.5-12.xr.el10*.rpm`; arm one-time boot; attended reboot; confirm
`uname -r` = `6.19.5-12.xr.el10` and that the kernel boots cleanly and RKE2
rejoins. **Do not** expect or claim any PPS/DSC surface. Roll back to xr11
default after the boot-validation.

**(4) OPERATOR PHYSICAL STEP — move the Bigscreen Beyond 2e to sting — BLOCKED / NOT RECOMMENDED.**
> Do **not** move the Beyond 2e to sting for the P4 diagnosis. sting's NVS 510 is
> DisplayPort 1.2 with **no DSC**; the Beyond 2e's native dual-panel mode requires
> DSC over DP 1.4, so the display pipe cannot light the headset at native mode.
> Even setting the pipe aside, Kepler/`nouveau` has no viable modern Vulkan/OpenXR
> runtime, so Monado cannot bring up a session. Moving the headset here would
> **not** produce a honey-representative result. The physical move that matters
> stays as written in the honey packet (`TIN-346`): the Beyond 2e on honey's
> `card0-DP-1`. If the operator still wants a sting-side display sanity check, it
> is limited to "does a normal DP monitor light up on NVS 510" — which is not P4
> and not this program's diagnosis.

**(5) Instrumented P3→P4 probe (adapted from the honey packet) — BLOCKED on sting GPU.**
> The honey packet's Phase 8–10 probe (`just honey-openxr-smoke`,
> `just honey-kernel-dsc-truth`, `hello_xr -g Vulkan`, `video_state` / HID
> display-wake capture) is `amdgpu` + Beyond-on-honey + XoxdWM-runtime specific.
> None of it is reproducible on sting (no `amdgpu`, no OpenXR/Vulkan on
> Kepler/`nouveau`, no `xoxdwm`/Monado install; the `just honey-*` recipes are
> honey-scoped). **The P3→P4 visual-first-frame diagnosis remains honey-only
> under `TIN-346`.** Adapting host names/connectors does not rescue it because the
> blocking difference is the GPU class, not the hostname. Recorded here for
> completeness per the requested step order; not executable on sting.

**(6) Evidence capture (per the XoxdWM template).** Capture the *kernel-window*
evidence (steps 0–3): fill the host-mutation fields of the reusable
[`reset-run-template.md`](reset-run-template.md) (before/after `uname -r`,
`boot_id`, `/boot` free, grubby default, RKE2 member health) and record the
preflight artifact paths. The XoxdWM
`honey-p4-visual-first-frame-evidence-template.md` P4 fields are **N/A on sting**
(no visual observation to record); mark them `not_applicable — GPU-incompatible
host` rather than leaving them blank. Post the filled kernel-window summary to
`TIN-2582`; note on `TIN-346` that sting was evaluated as an XR candidate and
found GPU-incompatible for the Beyond diagnosis.

**(7) Rollback + abort criteria + duration.** See the two sections below.

## Rollback path

- **Default is self-rollback:** because xr11 (and the optional xr12) are armed
  one-time only until validated, a plain reboot returns sting to the prior
  persistent default. No action needed to recover the known-good lane.
- **If a newly-booted kernel misbehaves:** `sudo grubby --set-default
  /boot/vmlinuz-6.19.5-9.xr.el10` (xr9), reboot, verify `uname -r` and
  `sudo grubby --default-kernel`. Rollback set on sting after this window: **xr9
  (prior known-good) or xr11 (new default once promoted)**, stock
  `6.12.0-124.47.1.el10_1`, rescue.
- **To retire the optional diagnostic kernel:** `sudo dnf remove
  kernel-xr-6.19.5-12.xr.el10`; re-verify `/boot` free and `grubby --default-kernel`.
- **`/boot` cleanup is not "rolled back"** — removing the stale xr7 is the intended
  outcome; keep xr9 until xr11 is the validated default.
- **`rke2`:** no rollback step ever stops, drains-as-reset, or restarts `rke2` by
  hand. The attended reboot is the only RKE2 state change, and it self-recovers.

## Abort criteria

- RKE2 quorum cannot tolerate sting rebooting (honey or bumble down/unhealthy at
  window time) → **abort before reboot**; fall back to A′ (`/boot` cleanup only)
  or reschedule.
- `/boot` free below the required threshold after removing xr7 → abort the kernel
  install; fall back to A′.
- xr11 acquire (supplier surface / RPM) unavailable or checksum-mismatched in the
  window → abort the install; fall back to A′ or reschedule.
- Option B only: the DSC artifact rebuild (P0) is unavailable/failed → skip
  Option B (it was optional and inert on sting anyway).
- Post-reboot: sting does not rejoin the etcd quorum, or `rke2-server` does not
  return `active`, or SELinux is not `Enforcing` → roll back to xr9 (self-rollback
  via plain reboot) and investigate before promoting any default.
- Any attempt to reach steps 4–5 → **stop**; those are BLOCKED on sting hardware.
  Route the Beyond-2e P4 diagnosis to the honey window (`TIN-346`).

## Expected duration

≈ **45–75 min attended** for the real window (Options A + A′): preflight + RKE2 +
`/boot` gates ~15 min; xr7 removal + xr11 install + one-time-arm + reboot + verify
+ promote-default ~25–40 min; evidence capture ~10 min. Add **~20–30 min** if
Option B (diagnostic-kernel boot-validation) is pursued (second install + reboot),
plus the pre-staged P0 rebuild time. Steps 4–5 add **zero** time (BLOCKED).

## Success framing

- **Full success (window goal):** sting converged to **xr11** as the validated
  persistent default with xr9 retained as rollback; `/boot` headroom reclaimed
  (stale xr7 removed) proving room for one more kernel line; RKE2 quorum intact
  throughout. This closes the `TIN-2582` catch-up and de-risks the eventual
  honey/laptop xr12 line by proving the T7810 kernel-swap mechanics once more.
- **Optional interim (Option B):** the DSC-observability RPM boot-validated on a
  T7810 chassis (install + clean boot + RKE2 rejoin), with the explicit recorded
  caveat that its PPS/DSC surface is inert on sting.
- **Honest non-goal:** this window does **not** and **cannot** advance the Beyond
  2e P4 first-frame diagnosis. That is not a shortfall of the window; it is the
  hardware-delta finding, and it is the useful result the operator asked for
  before committing to a physical headset move.

## Non-claims / gates honored

- This packet installs nothing, reboots nothing, and touches no host until an
  attended operator window with a fresh live preflight (D13).
- `rke2` is never stopped, drained-as-a-reset-lever, or hand-restarted; the etcd
  quorum is never taken below two healthy voters (D13 / `TIN-617`).
- No upstream sends of any kind. The Bigscreen Beyond EDID upstream lane is
  decided **HOLD** (D15).
- sting is **not** folded into the Budgie desktop lane (GDM/GNOME only) and this
  window does not change its session posture (`TIN-2582` non-claims).
- The XR-probe internals, the P4 gate definition, and the PPS/DSC/HID semantics
  are owned by XoxdWM / linux-xr and referenced here, not redefined (D11) — and
  are BLOCKED on sting hardware regardless.
- Display-first only; the HIP/ROCm-compute stack is out of scope (D4). (Moot on
  sting — no AMD GPU.)
- No HA/quorum decision is made or moved here (that stays `TIN-617`).

## Cross-references

- Tracker: `TIN-2582` (home — sting xr lag + `/boot`), `TIN-346` (honey P4 —
  where the Beyond diagnosis stays), `TIN-617` (honey/sting HA + etcd quorum, the
  member-health caution source), `TIN-2317` (xr12 forward line, honey-first),
  `TIN-318` (bumble kernel-target analog), `TIN-295` (lab sting maintenance).
- linux-xr: release `v6.19.5-xr11` (catch-up target); PR #69 (AMD DSC PPS debugfs
  carry, merged — `amdgpu`-only, inert on sting); rebuild via
  `.github/workflows/build-kernel.yml` on `xr/main` (Option B P0).
- Dell-7810: [`honey-p4-visual-first-frame-operator-window-2026-07-06.md`](honey-p4-visual-first-frame-operator-window-2026-07-06.md)
  (the packet this adapts), [`linux-xr-install-and-rollback.md`](linux-xr-install-and-rollback.md),
  [`kernel-lane.md`](kernel-lane.md), [`reset-run-template.md`](reset-run-template.md),
  [`docs/platform/README.md`](README.md).
- lab: `inventory/host_vars/sting.yml` (sting fleet facts), `TIN-617` HA lane.
- rockies: [`docs/cordillera-machine-matrix-2026-07-06.md`](https://github.com/tinyland-inc/rockies/blob/main/docs/cordillera-machine-matrix-2026-07-06.md)
  (surfaced `TIN-2582`), [`docs/p4-composition-gate.md`](https://github.com/tinyland-inc/rockies/blob/main/docs/p4-composition-gate.md).
- XoxdWM: `honey-p4-visual-first-frame-evidence-template.md` (P4 fields N/A on
  sting), `support-matrix.md` (P0–P6 ladder).
