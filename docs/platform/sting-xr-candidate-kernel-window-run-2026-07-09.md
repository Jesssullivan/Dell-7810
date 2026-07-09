# Sting XR-Candidate Kernel-Window — Run Record 2026-07-09 (STAGE-AND-PARK)

Status: **PARTIALLY EXECUTED — read-only phases done; all privileged mutations
PARKED for the operator.** This is the run record for the sting window packet
[`sting-xr-candidate-kernel-window-2026-07-08.md`](sting-xr-candidate-kernel-window-2026-07-08.md)
(home tracker [`TIN-2582`](https://linear.app/tinyland/issue/TIN-2582); cross-link
[`TIN-346`](https://linear.app/tinyland/issue/TIN-346)). Executed under the
Cordillera execution wave, agent lane, stamped `[cordillera-2026-07-09]`.

**Why STAGE-AND-PARK:** the privilege probe `ssh sting "sudo -n true"` returned
`sudo: a password is required` (user `jess`, no passwordless sudo — exactly as the
packet's *Sudo lane* precondition states). Per the execution rails, the lane does
**not** attempt interactive escalation and does **not** use the lab sops become
path to self-escalate mutations. Every no-privilege probe/capture/verification was
executed; every privileged step (steps 1–3: `/boot` cleanup, kernel install,
bootloader arm, reboot, promote-default) is **staged as an exact copy-paste
operator script** in [§Parked operator script](#parked-operator-script) below.

## Operator greenlight (verbatim, 2026-07-09)

> "these are the way, and we are fully prepped and greenlit for these — merges,
> greens, parallel fable led workflows... run the windows in whatever order suits."

The window packet (merged 2026-07-08 via Dell-7810 PR #30) is the fresh
operator-window authorization; this greenlight authorizes executing it. Recorded
here and on `TIN-2582` per the rails. Nothing in this record was run with
elevated privilege.

## Preflight capture (D13-required) — EXECUTED read-only

The canonical helper `rockies/bazel/capture-tinyland-lab-host-rollout-preflight.sh`
**does not wire `sting`** — its host `case` accepts only `honey|mbp-13|yoga`
(a real tooling gap; see [§Next](#next)). A **packet-named-equivalent** read-only
capture was run instead, gathering the exact precondition fields and written to the
same convention/location:
`rockies/.artifacts/tinyland-lab-host-rollout-preflight/20260709T054000Z-sting.txt`
(that tree is `.gitignore`d in rockies, so the capture is embedded verbatim here).

```text
# Tinyland lab host rollout preflight (packet-named-equivalent for sting)
captured_at=20260709T054000Z
host=sting
ssh_target=sting
capture_tool=stage-and-park read-only equivalent (bazel/capture-tinyland-lab-host-rollout-preflight.sh does not wire sting; only honey/mbp-13/yoga)
mutation_policy=read-only; no package install/removal, kernel install, bootloader mutation, DM mutation, DE teardown, reboot, or external outreach
privilege=no passwordless sudo; sops become path deliberately NOT used; privileged-only fields marked PARKED

## identity
host=sting
kernel=6.19.5-9.xr.el10
boot_id=e6fada27-5a49-486c-b515-df6bc987c897
boot_time=system boot  2026-07-03 22:21
selinux=Enforcing

## dmi_chassis
sys_vendor=Dell Inc.
product_name=Precision Tower 7810

## gpu_delta
lspci_vga_3d=
02:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK107 [NVS 510] [10de:0ffd] (rev a1)
03:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK107 [NVS 510] [10de:0ffd] (rev a1)
gpu_modules=
drm_connectors=
card0-DP-1
card0-DP-2
card0-DP-3
card0-DP-4
card1-DP-5
card1-DP-6
card1-DP-7
card1-DP-8

## systemd
default_target=graphical.target
Id=gdm.service
ActiveState=active
UnitFileState=enabled
Id=sddm.service
ActiveState=inactive
display_manager_unit=/usr/lib/systemd/system/gdm.service

## rke2_local
rke2_server_active=active
rke2_agent_active=inactive

## filesystems
Filesystem           Size  Used Avail Use% Mounted on
/dev/mapper/rl-root   70G   47G   24G  67% /
/dev/nvme0n1p2       849M  617M  232M  73% /boot
/dev/nvme0n1p1       599M  8.4M  591M   2% /boot/efi

## packages
gdm-47.0-11.el10.x86_64
kernel-6.12.0-124.47.1.el10_1.x86_64
kernel-core-6.12.0-124.47.1.el10_1.x86_64
kernel-devel-6.12.0-124.47.1.el10_1.x86_64
kernel-headers-6.12.0-124.47.1.el10_1.x86_64
kernel-modules-6.12.0-124.47.1.el10_1.x86_64
kernel-modules-core-6.12.0-124.47.1.el10_1.x86_64
kernel-modules-extra-6.12.0-124.47.1.el10_1.x86_64
kernel-tools-6.12.0-124.47.1.el10_1.x86_64
kernel-xr-6.19.5-7.xr.el10.x86_64
kernel-xr-6.19.5-9.xr.el10.x86_64

## sessions
/usr/share/wayland-sessions/gnome.desktop
/usr/share/wayland-sessions/gnome-wayland.desktop
(/usr/share/xsessions: none)

## boot_files (name size_bytes)
config-6.19.5-7.xr.el10 286756
config-6.19.5-9.xr.el10 286756
initramfs-6.12.0-124.47.1.el10_1.x86_64.img 93581232
initramfs-6.19.5-7.xr.el10.img 162422907
initramfs-6.19.5-7.xr.el10kdump.img 41362944
initramfs-6.19.5-9.xr.el10.img 162420379
initramfs-6.19.5-9.xr.el10kdump.img 41342464
vmlinuz-0-rescue-ad2ee3baf7434090a3f8635779698326 16072704
vmlinuz-6.12.0-124.47.1.el10_1.x86_64 15969096
vmlinuz-6.19.5-7.xr.el10 16068608
vmlinuz-6.19.5-9.xr.el10 16072704

## boot_selector_nonpriv  (PARKED — all root-only)
grubenv_list=Permission denied (/boot/grub2/grubenv)
bls_entries=Permission denied (/boot/loader/entries/)
grubby=not on non-login PATH; requires root regardless
-> grubby --default-index / --default-kernel / --default-title, grub2-editenv list,
   grubby --info=ALL are PARKED to operator phase-0 (see staged script).

## tcfs_mount
tcfs on /home/jess/tcfs type fuse (rw,nosuid,nodev,relatime,user_id=1000,group_id=1000)

## quorum_peers
peer=honey   hostname=honey   kernel=6.19.5-11.xr.el10             rke2_server_active=active   boot_id=f5dc8aaf-1385-4ce7-8ab1-f26af38e5406
peer=bumble  hostname=bumble  kernel=6.12.0-124.8.1.el10_1.x86_64  rke2_server_active=active   boot_id=1294abbb-678a-40d9-b65c-4c61cde1a612
```

### Preflight interpretation (every packet premise re-verified live)

- **Running kernel `6.19.5-9.xr.el10` (xr9)** — matches packet. SELinux `Enforcing`.
- **Chassis = Dell Precision Tower 7810** (DMI `Dell Inc.` / `Precision Tower 7810`)
  — the T7810 mechanics transfer premise holds.
- **GPU = 2× NVIDIA GK107 [NVS 510] (`10de:0ffd`)**, DP connectors `card0-DP-1..4`
  / `card1-DP-5..8`, **no `amdgpu`** — the load-bearing hardware-delta is **confirmed
  live**. Steps 4–5 remain correctly **BLOCKED** (see below).
- **`/boot` = 73% used, 232 MB free** (`849M`/`617M` on `/dev/nvme0n1p2`) — matches
  packet exactly. ESP `/boot/efi` 591 MB free.
- **Installed kernel-xr = xr7 + xr9** (plus stock 6.12); the stale **xr7** is the
  single clean removable (one `kernel-xr-6.19.5-7.xr.el10` package, no split
  -core/-modules subpackages).
- **DM = GDM active; GNOME/gnome-wayland sessions only** — not a Budgie/XR host
  (packet non-claim holds).
- **`rke2-server` active** on sting; `rke2-agent` inactive — sting is a live etcd
  voter.

## Gate results (read-only) — all currently GREEN

### RKE2 quorum gate (load-bearing before any reboot)

The odd-3 etcd quorum (honey `b1d6b8eb8ff1b710`, sting `1c95c2eabb6abf01`, bumble
`97469e6753157feb`; `TIN-617`) tolerates exactly one member down.

- sting `rke2-server` = **active**
- honey `rke2-server` = **active** (kernel xr11, boot_id captured)
- bumble `rke2-server` = **active** (kernel stock 6.12.0-124.8.1)

Both other voters are up → a single sting reboot is quorum-safe **at capture time**.
The deeper **etcd member-list health** (`etcdctl member list` / `endpoint health`)
requires root certs (`/var/lib/rancher/rke2/server/tls/etcd/…`) and is **PARKED to
operator phase 0** — it MUST be re-confirmed live immediately before arming the
reboot (staged below). If honey or bumble is unhealthy at window time → **abort
before reboot**, fall back to A′ (`/boot` cleanup only).

### `/boot` capacity gate (math from live sizes)

Removing `kernel-xr-6.19.5-7.xr.el10` frees (bytes): initramfs 162,422,907 +
kdump 41,362,944 + vmlinuz 16,068,608 + config 286,756 + System.map 8,821,945 =
**≈ 228,963,160 B ≈ 218 MiB**. Current free = 232 MB → **≈ 450 MB free after xr7
removal**. Installed xr11 `/boot` footprint ≈ 220 MB (vmlinuz 16 + initramfs 155 +
kdump 40 + config/System.map 9) → **≈ 230 MB free after xr11**, comfortably above
the packet's ~180 MB gate. **Gate passes** (verify live in phase 0/1).

### Rollback-asset verification (before any destructive step)

Confirmed present on disk from the capture:
- **xr9 known-good/rollback:** `vmlinuz-6.19.5-9.xr.el10` + package installed ✓
- **stock fallback:** `vmlinuz-6.12.0-124.47.1.el10_1.x86_64` + package ✓
- **rescue image:** `vmlinuz-0-rescue-ad2ee3baf7434090a3f8635779698326` ✓

The corresponding **BLS entries + `grubby --default-kernel`** confirmation is root-only
→ PARKED to operator phase 0 (`grubby --info=ALL` capture) before the first mutation.
`dnf history` confirmation is likewise PARKED to phase 0.

## GPU hardware-delta → Steps 4–5 BLOCKED (confirmed, not executed)

The live probe confirms sting is **NVIDIA-only (Kepler/NVS 510, DP 1.2, no DSC, no
`amdgpu`)**. Therefore, exactly as the packet directs:

- **Step 4 (move Bigscreen Beyond 2e to sting): BLOCKED / NOT RECOMMENDED.** No
  DSC-capable DP 1.4 pipe; no viable modern Vulkan/OpenXR on Kepler/nouveau. The
  Beyond-2e physical move stays on honey (`TIN-346`, `card0-DP-1`).
- **Step 5 (instrumented P3→P4 probe): BLOCKED.** `amdgpu`-/Beyond-on-honey-/XoxdWM-
  runtime specific; not reproducible on sting. P4 first-frame diagnosis remains
  honey-only under `TIN-346`.
- linux-xr **PR #69** DSC PPS debugfs carry is **`amdgpu`-only → inert on sting**
  (never binds a device, captures nothing). This is chassis boot-validation only,
  **zero P4 value** — stated plainly per the lane instruction.

## Option B (xr12 DSC-observability kernel) — DEFERRED; artifact rebuild PENDING

- Packet verdict for Option B on sting = **Defer** (inert on NVIDIA; chassis
  boot-validation of the RPM only).
- **Execute-condition NOT met:** Option B runs iff steps 0–2 completed clean AND the
  DSC artifact is obtainable. Steps 0–2 are **PARKED** (no passwordless sudo), so
  Option B is not executed this session regardless.
- **Artifact obtainability check (executed):** linux-xr **PR #69 is MERGED** into
  `xr/main` (2026-05-12). There is **no `v6.19.5-xr12` release**. The post-#69
  `xr/main` build (run `25710987473`) artifact `kernel-xr-rpms-generic` is
  **`expired: true`** (retention lapsed 2026-06-11) — so the DSC RPM **needs a
  rebuild**, confirming the packet P0 premise.
- **Rebuild dispatched (async, PENDING — not waited on):** per the lane instruction
  ("if it needs a rebuild, trigger the CI rebuild per the packet P0 note and record
  PENDING rather than blocking the window") and the packet's "pre-stage before the
  window":
  - Workflow: `.github/workflows/build-kernel.yml` on **`xr/main`**,
    `kernel_version=6.19.5`, `xr_release=12`, `variant=generic`, `rt_version=`(empty),
    `use_ccache=false`.
  - **Run ID `28996916368`** (queued 2026-07-09T05:44:08Z):
    https://github.com/tinyland-inc/linux-xr/actions/runs/28996916368
  - Expected output: `kernel-xr-6.19.5-12.xr.el10.x86_64.rpm` (generic). Operator
    confirms the exact produced version at install time. This only pre-stages the
    artifact so Option B's obtainability gate won't block a *future attended*
    boot-validation; it does **not** authorize or perform any Option-B install.

## Option A acquire path — CONFIRMED available (no abort trigger)

linux-xr release **`v6.19.5-xr11`** (latest) carries the exact target RPM:
- `kernel-xr-6.19.5-11.xr.el10.x86_64.rpm` — 128,817,926 B
- sha256 `4f64a56c4f64a9902109f721d91e36199d260e8b76ad6557ccd911359184fb8c`
- plus `SHA256SUMS`. The "xr11 acquire unavailable/checksum-mismatch" abort criterion
  does **not** trigger. The staged install pins this digest.

## Reset-run host-mutation fields (per packet step 6 / `reset-run-template.md`)

| Field | Before (captured 2026-07-09) | After (window) |
| --- | --- | --- |
| `uname -r` | `6.19.5-9.xr.el10` | **PENDING** (target `6.19.5-11.xr.el10`) |
| `boot_id` | `e6fada27-5a49-486c-b515-df6bc987c897` | **PENDING** (must change post-reboot) |
| `/boot` free | 232 MB (73% used) | **PENDING** (target ≥ ~180 MB after xr7 rm + xr11) |
| grubby default | **PARKED** (root-only capture) | **PENDING** (xr11 after validation; xr9 = rollback) |
| RKE2 member health | all 3 `rke2-server` active | **PENDING** (sting must rejoin quorum post-boot) |
| SELinux | `Enforcing` | **PENDING** (must remain `Enforcing`) |
| P4 visual fields | **N/A — GPU-incompatible host** | **N/A — GPU-incompatible host** |

## Parked operator script

Run **on `neo`** (each block copy-paste; the operator has interactive sudo on
`sting`). Run **phase by phase**, stop at any failed gate. Do **not** paste all at
once — the reboot is a deliberate manual pause, and the default is only promoted
**after** a clean boot + quorum rejoin. `rke2` is never stopped/drained/hand-restarted.

```bash
# ============================================================================
# STING XR-CANDIDATE KERNEL WINDOW — operator run (packet steps 0–3)
# TIN-2582 | [cordillera-2026-07-09] | one attended reboot; xr9 kept as rollback
# ============================================================================

# ---- PHASE 0: live gates (READ-ONLY; abort here if any gate fails) ----------
ssh sting 'sudo bash -s' <<'EOF'
set -e
echo "== identity =="; uname -r; cat /proc/sys/kernel/random/boot_id; getenforce
echo "== /boot =="; df -h /boot
echo "== installed kernels =="; rpm -qa 'kernel*' | sort; ls -1 /boot/vmlinuz-*
echo "== boot selector (rollback assets must list xr9 + rescue) =="
grubby --default-kernel; grubby --default-index; grubby --default-title
grub2-editenv - list | tr '\n' ';'; echo
grubby --info=ALL | awk -F= '/^(index|kernel|title)=/{print}'
echo "== dnf history (rollback reference) =="; dnf history list | head -5
echo "== rke2 local =="; systemctl is-active rke2-server
echo "== etcd quorum health (all 3 must be started/healthy) =="
ETCDCTL_API=3 /var/lib/rancher/rke2/bin/etcdctl \
  --cacert /var/lib/rancher/rke2/server/tls/etcd/server-ca.crt \
  --cert   /var/lib/rancher/rke2/server/tls/etcd/server-client.crt \
  --key    /var/lib/rancher/rke2/server/tls/etcd/server-client.key \
  --endpoints https://127.0.0.1:2379 member list -w table
ETCDCTL_API=3 /var/lib/rancher/rke2/bin/etcdctl \
  --cacert /var/lib/rancher/rke2/server/tls/etcd/server-ca.crt \
  --cert   /var/lib/rancher/rke2/server/tls/etcd/server-client.crt \
  --key    /var/lib/rancher/rke2/server/tls/etcd/server-client.key \
  --endpoints https://127.0.0.1:2379 endpoint health --cluster -w table
EOF
# Confirm the other two voters are healthy (peer-side rke2 status):
for h in honey bumble; do echo "== $h =="; ssh "$h" 'systemctl is-active rke2-server'; done
# GATE: proceed only if honey+bumble healthy, xr9 present as rollback, SELinux Enforcing.
# Optional: ssh sting 'sudo kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml cordon $(hostname)'

# ---- PHASE 1: /boot cleanup — remove stale xr7 (TIN-2582) -------------------
ssh sting 'sudo dnf remove kernel-xr-6.19.5-7.xr.el10'   # review transaction; confirm
ssh sting 'df -h /boot; ! grubby --info=ALL | grep -q 6.19.5-7 && echo "xr7 entry gone OK"'
# GATE: /boot free must be >= ~180 MB accounting for xr11. If not -> STOP (fall back A′).

# ---- PHASE 2a: acquire xr11 WITHOUT changing default (checksum-gated) -------
ssh sting 'bash -s' <<'EOF'
set -e
cd "$(mktemp -d)"
BASE=https://github.com/tinyland-inc/linux-xr/releases/download/v6.19.5-xr11
curl -fsSLO "$BASE/kernel-xr-6.19.5-11.xr.el10.x86_64.rpm"
echo "4f64a56c4f64a9902109f721d91e36199d260e8b76ad6557ccd911359184fb8c  kernel-xr-6.19.5-11.xr.el10.x86_64.rpm" | sha256sum -c -
echo "STAGED_RPM=$PWD/kernel-xr-6.19.5-11.xr.el10.x86_64.rpm"
EOF
# GATE: sha256 must match. On mismatch/unavailable -> STOP (abort install, fall back A′).
# Install WITHOUT promoting default (paste the STAGED_RPM path printed above):
ssh sting 'sudo dnf install /path/from/STAGED_RPM/kernel-xr-6.19.5-11.xr.el10.x86_64.rpm'
# Safety-belt: force persistent default back to known-good xr9 until xr11 is validated,
# then arm xr11 as ONE-TIME next boot only.
ssh sting 'sudo bash -s' <<'EOF'
set -e
grubby --info=ALL | grep 6.19.5-11 || { echo "xr11 entry missing"; exit 1; }
sudo grubby --set-default /boot/vmlinuz-6.19.5-9.xr.el10   # keep known-good persistent
XR11=$(grubby --info=/boot/vmlinuz-6.19.5-11.xr.el10 | awk -F= '/^index=/{print $2}')
echo "xr11 index=$XR11"
sudo grub2-reboot "$XR11"                                   # one-time next boot ONLY
grub2-editenv - list | tr '\n' ';'; echo                    # expect next_entry=$XR11
grubby --default-kernel                                     # expect xr9 (unchanged)
EOF

# ---- PHASE 2b: ATTENDED REBOOT (exactly one; never touch rke2) --------------
ssh sting 'sudo systemctl reboot'
# Wait for return, then verify. If sting does NOT return within ~8 min: STOP,
# do not retry; a plain power-cycle self-recovers to xr9 (one-time arm only).
ssh sting 'bash -s' <<'EOF'
set -e
echo "uname: $(uname -r)"           # expect 6.19.5-11.xr.el10
echo "boot_id: $(cat /proc/sys/kernel/random/boot_id)"   # must differ from before
getenforce                           # expect Enforcing
systemctl is-active rke2-server      # expect active
sudo /var/lib/rancher/rke2/bin/etcdctl \
  --cacert /var/lib/rancher/rke2/server/tls/etcd/server-ca.crt \
  --cert   /var/lib/rancher/rke2/server/tls/etcd/server-client.crt \
  --key    /var/lib/rancher/rke2/server/tls/etcd/server-client.key \
  --endpoints https://127.0.0.1:2379 endpoint health --cluster -w table
EOF
# GATE: uname=xr11 AND boot_id changed AND rke2 active AND sting rejoined quorum AND
# SELinux Enforcing. If ANY fail -> ROLLBACK (below); do not promote default.

# ---- PHASE 2c: promote xr11 to persistent default (only after clean validate) ---
ssh sting 'sudo grubby --set-default /boot/vmlinuz-6.19.5-11.xr.el10 && sudo grubby --default-kernel'
# xr9 retained as rollback. Optional: ssh sting 'sudo kubectl --kubeconfig \
#   /etc/rancher/rke2/rke2.yaml uncordon $(hostname)'
# This closes the TIN-2582 catch-up.

# ---- PHASE 3 (OPTIONAL, DEFER): xr12 DSC boot-validate — INERT on sting ------
# Only if the operator wants the DSC RPM boot-validated on a T7810 chassis.
# Prereq: rebuild artifact from run 28996916368 (or newer) downloaded.
# Produces NO DSC/PPS data on sting (NVIDIA-only). If pursued: if /boot tight,
# remove xr9 first (now xr11 is validated default); dnf install the xr12 rpm;
# grub2-reboot its index (one-time); attended reboot; confirm uname=6.19.5-12 and
# rke2 rejoin; then grubby --set-default back to xr11. Do NOT expect PPS/DSC surface.

# ---- ROLLBACK (if a booted kernel misbehaves) -------------------------------
# Default self-rollback: one-time arm means a plain reboot returns to the persistent
# default. To force known-good: 
ssh sting 'sudo grubby --set-default /boot/vmlinuz-6.19.5-9.xr.el10 && sudo systemctl reboot'
# Verify uname=xr9, rke2 active, quorum rejoined. Never stop/drain/hand-restart rke2.
```

### Abort criteria (from packet — honored)

- honey or bumble down/unhealthy at window time → **abort before reboot** (fall back A′).
- `/boot` free below threshold after xr7 removal → abort install (fall back A′).
- xr11 acquire unavailable/checksum-mismatch → abort install (fall back A′). *(Not
  triggered at capture: release live, digest pinned.)*
- post-reboot: sting fails to rejoin quorum, `rke2-server` not active, or SELinux not
  Enforcing → self-rollback to xr9, investigate before promoting default.
- Any attempt to reach steps 4–5 → **stop** (BLOCKED on sting GPU; route to `TIN-346`).
- sting does not return within ~8 min after reboot → **stop, do not retry**, report
  state + rollback (plain power-cycle self-recovers to xr9).

## Host end-state (this session)

`sting` is **unchanged** — kernel `6.19.5-9.xr.el10` (xr9), boot_id
`e6fada27-…`, `/boot` 232 MB free, xr7 still installed, `rke2-server` active, etcd
quorum intact (all 3 voters `rke2-server` active). No package, kernel, bootloader,
DM, or reboot mutation was performed. honey and bumble untouched (read-only status
only).

## Cross-references

- Packet: [`sting-xr-candidate-kernel-window-2026-07-08.md`](sting-xr-candidate-kernel-window-2026-07-08.md)
  (Dell-7810 PR #30). Sibling: [`honey-p4-visual-first-frame-operator-window-2026-07-06.md`](honey-p4-visual-first-frame-operator-window-2026-07-06.md).
- Trackers: `TIN-2582` (home), `TIN-346` (honey P4 — Beyond diagnosis stays there),
  `TIN-617` (etcd quorum), `TIN-2317` (xr12-forward line), `TIN-295` (lab sting maint).
- linux-xr: release `v6.19.5-xr11` (Option A target), PR #69 (DSC PPS carry, merged,
  `amdgpu`-only/inert on sting), rebuild run `28996916368` (Option B P0, PENDING).
- rockies preflight capture: `.artifacts/tinyland-lab-host-rollout-preflight/20260709T054000Z-sting.txt`
  (gitignored; embedded above).

## Next

- Operator: run the parked script phases 0–2 in an attended window to close the
  `TIN-2582` xr11 catch-up (steps 4–5 BLOCKED; Option B optional/inert).
- Tooling gap: `rockies/bazel/capture-tinyland-lab-host-rollout-preflight.sh` should
  add `sting` to its supported-host `case` (currently honey/mbp-13/yoga only) so the
  D13 preflight can be run canonically for this host.
