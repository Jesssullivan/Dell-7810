# Sting XR-Candidate Kernel-Window — Run Record RUN-3 2026-07-09 (PRIVILEGED GATES GREEN, REBOOT PARKED)

Status: **PRIVILEGED GATES VERIFIED GREEN — reboot-bearing mutations deliberately
PARKED.** This is the post-post-mortem execution attempt for the sting window packet
[`sting-xr-candidate-kernel-window-2026-07-08.md`](sting-xr-candidate-kernel-window-2026-07-08.md)
(home tracker [`TIN-2582`](https://linear.app/tinyland/issue/TIN-2582); cross-link
[`TIN-346`](https://linear.app/tinyland/issue/TIN-346)). Executed under the Cordillera
execution wave, agent lane, stamped `[cordillera-2026-07-09]`.

**How this differs from the two prior 2026-07-09 runs.** RUN-1
([`…run-2026-07-09.md`](sting-xr-candidate-kernel-window-run-2026-07-09.md)) was
STAGE-AND-PARK because the lane had **no privilege mechanism** (`sudo -n` failed).
RUN-2 ([`…run2-2026-07-09.md`](sting-xr-candidate-kernel-window-run2-2026-07-09.md))
aborted because **the host went offline mid-window** (the crash the post-mortem
investigated). RUN-3 (this record) **did** have privilege — the lab `sops`/`age`
become path (`hosts/sting.yaml`) verified working live — and used it to positively
capture every privileged gate that the prior runs could only PARK. The reboot is
**not** parked for lack of privilege or reachability this time; it is parked as a
**deliberate risk decision** documented in [§Park decision](#park-decision-why-the-reboot-did-not-run).

## Inputs to this run

- **Operator execution grant (2026-07-09):** executor = agent via lab `sops`-sudo
  (`hosts/sting.yaml`), operator reachable; "run the kernel window once quorum is
  healthy."
- **Post-mortem verdict (STING-POSTMORTEM lane, `[cordillera-2026-07-09]`):** abrupt
  host-local hard stop 2026-07-09 05:22:07 EDT; ~3h15m dead; unattended self-recovery
  08:37:20 on the **same xr9 kernel**. Ranked cause: (1) host-local power/power-delivery
  fault; (2) co-primary Crucial P310 **NVMe APST/ASPM controller-drop** (`TIN-618`,
  workaround **not applied**); (3) weak xr9/io_uring-under-build-load (no lockup trace;
  **xr11 is not a proven fix**). **Verdict did NOT declare an active hardware fault a
  reboot would worsen** → the kernel-window lane was cleared to proceed *as fleet
  hygiene, not incident remediation*, gated on a healthy quorum.
- **Gate discipline:** proceed only if the HARD QUORUM GATE is fully GREEN and no
  active hardware fault is present; otherwise PARK.

## Privilege mechanism — verified working; secret hygiene held

All privileged reads below ran through the canonical lab become path: per-host
`sops`/`age` secret (`/…/lab/nix/secrets/hosts/sting.yaml`), decrypted **on-host**,
`become.password` piped to `sudo -S` and **never written to any file, log, echo,
evidence, PR, or Linear**. No `set -x` anywhere; remote payloads via `bash -s`
heredocs (never the login shell); temp files trap-removed; password unset. The
`sops` input-type had to be pinned (`--input-type yaml`) because the on-host temp
file carries no `.yaml` extension. This is the first sting-lane run to exercise the
become path end-to-end.

## HARD QUORUM GATE — GREEN (literal etcd artifact captured)

sting `rke2-server` = **active** (not `activating`). All three Kubernetes nodes
`Ready` (control-plane,etcd,master): honey (xr11), sting (xr9), bumble (stock 6.12) —
a live API server, which itself proves a healthy etcd quorum with a leader. Literal
`etcdctl` (via `crictl exec` into the `etcd-sting` static pod — the host has no
`etcdctl` at `/var/lib/rancher/rke2/bin/`; RUN-1's parked path was wrong for this host):

```
member list:
  1c95c2eabb6abf01  started  sting-94c3e927   192.168.70.12  IS LEARNER=false
  97469e6753157feb  started  bumble-006816de  192.168.70.11  IS LEARNER=false
  b1d6b8eb8ff1b710  started  honey-dfd256fd   192.168.70.10  IS LEARNER=false

endpoint health --cluster:  all 3 = true  (6.4ms / 4.5ms / 12.3ms)

endpoint status --cluster:  leader = bumble (97469e6753157feb), raft term 85
  ALL THREE at identical RAFT INDEX 65219771  → sting fully synced, not lagging
  db 124 MB / 2.1 GB quota (55% not-in-use)
```

**Gate result:** sting is a **started, non-learner, fully-raft-synced voter**;
quorum health 3/3; leader present. The cluster is **not** mid-recovery in the etcd
sense — sting rejoined hours ago and is in lock-step. **Quorum gate PASSES.**

## Active-hardware-fault re-check — NONE present (post-mortem park-condition NOT triggered)

- **dmesg (current boot) NVMe/PCIe/AER/MCE/I-O-error scan: CLEAN** — zero matching
  lines. The `nvme1` APST/ASPM controller-drop the post-mortem found was **previous-boot
  only**; under the current heavy load the NVMe is **not** dropping.
- **Thermals nominal under load:** package temps 48–50 °C, cores 39–47 °C (high=77,
  crit=87). No thermal emergency. Post-mortem's thermal-ruled-out holds live.
- **No proc wedged:** transient writeback kworkers only (`flush-253:x`); no hung_task.

→ There is **no active hardware fault a reboot would worsen** at gate time. The
post-mortem's explicit PARK trigger (failing NVMe mid-write / thermal emergency) is
**not** met. On the *hardware-fault* axis the lane is clear to proceed.

## Phase 1 (/boot cleanup) — ALREADY SATISFIED (no-op)

The packet's Phase 1 (remove stale **xr7**) is **already done**. Live privileged read:

- Installed kernel-xr = **only `kernel-xr-6.19.5-9.xr.el10` (xr9)** — xr7 is gone.
- `/boot` = **47% used, 451 MB free** (`849M`/`399M` on `/dev/nvme0n1p2`) — up from
  the packet/RUN-1 baseline of 73%/232 MB; the ~218 MB xr7 footprint was reclaimed
  between RUN-1's 05:40Z capture and this run.
- `/boot/vmlinuz-*` = xr9 + stock 6.12 + rescue. `grubby --default-kernel` = **xr9**
  (`saved_entry` = xr9, `boot_success=1`, index 0).

The `/boot` capacity gate is now **permanently green** (room for xr11 with margin).
No cleanup mutation is required or performed.

## Acquire gates — GREEN (both staged artifacts confirmed live, non-mutating)

- **Option A (xr11):** release `v6.19.5-xr11` carries
  `kernel-xr-6.19.5-11.xr.el10.x86_64.rpm` (128,817,926 B); live `SHA256SUMS` digest
  = **`4f64a56c4f64a9902109f721d91e36199d260e8b76ad6557ccd911359184fb8c`** — matches
  the packet-pinned digest exactly. The "xr11 unavailable/checksum-mismatch" abort
  does **not** trigger.
- **Option B (xr12 DSC-observability):** linux-xr build **run `28996916368`** =
  `conclusion: success, completed`; artifact `kernel-xr-rpms-generic` (130,781,523 B)
  **`expired: false`** → downloadable **now**. This is a material upgrade over RUN-1,
  where Option B's artifact was PENDING (a rebuild had just been dispatched). Option B
  is therefore *available* — but it is still **DEFER** on sting (PPS/DSC surface is
  `amdgpu`-only, inert on NVIDIA; chassis boot-validation only, zero P4 value) and it
  requires a **second** reboot, so it inherits the same park (below).

## Park decision — why the reboot did NOT run

Every *gate* the packet defines is GREEN (quorum, hardware-clean, /boot, acquire).
The reboot was nonetheless **parked** because the packet's reboot **precondition** is
unmet and the risk/urgency balance is decisively against an autonomous reboot right now:

1. **The packet's workload precondition is demonstrably UNMET.** The RKE2 safety note
   authorizes the reboot *"iff the operator has confirmed no non-replicated critical
   workload is pinned sting-only at window time."* Live census of non-DaemonSet pods on
   sting shows the opposite — sting is densely packed with **single-replica production
   and stateful** workloads that a reboot would evict:
   - **financebro** — 7 single-replica pods (authority-api, plaid-sync, gmail-sync,
     ingest-deriver, openclaw-operator, otel-collector, unsubscribe-worker).
   - **massageithaca-prod** + **massageithaca-acuity-hosted-prod** (production) and the
     **`redis-massageithaca-0`** StatefulSet; **`redis-software-0`** StatefulSet
     (software-homegrown-prod). Stateful, single-replica, likely local-path-backed
     (the `local-path-provisioner` itself runs on sting).
   - **ingress-nginx-controller** (single replica), **cloudflared**, **acuity-middleware**
     + alertmanager, **mcp-services** (arxiv/fetch/wikipedia/paper-search/duckduckgo),
     **fuzzy-dev** (llama-cpp/modal-proxy), **gf-rbe**, **account-controller**.
   No operator confirmation exists for this specific, live workload set. A brief single
   reboot is quorum-safe, but it is **not** the "no critical workload pinned" reboot the
   packet gates on; the stateful Redis + local-path-backed pods and the production apps
   need a deliberate cordon/drain-with-rescheduling and operator sign-off first.
2. **Crash-replicating load profile.** sting is under heavy, sustained CI build load —
   the **arc-runners** namespace has 9 active runners including live
   `tinyland-nix-compute-expansion` nix builds (the `java`/`tar` churn, load ~20–50 on
   32 cores across the window). This is the **same heavy-build load profile that
   co-occurred with the 05:22 crash** (post-mortem hypothesis #3). Rebooting into xr11
   under this exact load neither cleanly validates the kernel nor is a calm moment to
   reboot; it also hard-kills in-flight CI.
3. **Root-cause hardware fault is unresolved.** The post-mortem's primary/co-primary
   causes (host-local power-delivery fault; NVMe P310 APST/ASPM controller-drop) are
   **not fixed** — no PSU re-seat, no BIOS AC-recovery confirmation, the NVMe/ASPM
   cmdline workaround not applied, no UPS, and `smartmontools`/`nvme-cli` still absent.
   A reboot on hardware that hard-crashed **~6 h ago from an unresolved suspected-power
   fault** carries real (not theoretical) recurrence risk. If sting failed to return
   within the 8-min bound, the rails require STOP-EVERYTHING — converting a zero-urgency
   hygiene bump into a self-inflicted incident on a node hosting production + stateful +
   ingress + CI, with quorum reduced to 2/3.
4. **Zero urgency.** By the post-mortem's own framing this window is *"fleet hygiene,
   not incident remediation"*; xr11 is *"not a proven fix"* for the wedge. There is no
   time pressure that would justify absorbing (1)–(3).

The asymmetry is decisive: the upside of rebooting now is a non-urgent kernel bump; the
plausible downside is a production/stateful incident on known-unfixed hardware. **The
disciplined, rails-honoring call is to PARK the reboot** and hand back precise
reschedule conditions. This is the same conclusion the post-mortem's NEXT anticipated
("attend/drain quorum"; "Hardware: inspect/re-seat PSU … first").

**Nothing was mutated.** No package install/removal, no bootloader change, no one-time
boot arm, no reboot, no cordon/drain, no cmdline change. Installing xr11 without an
imminent reboot was also declined: arming one-time boot on a host with a demonstrated
crash-and-auto-recover pattern would leave a landmine (an unattended crash-recovery
could boot an unvalidated kernel), and installing without arming is valueless half-work.

## Reschedule conditions (all must hold for the parked reboot)

Run the parked script (below) in an **attended, quiescent** window when:
- **A.** Operator confirms (or arranges) that the sting-pinned single-replica/stateful
  workloads are safe to evict — ideally `kubectl cordon sting` + a graceful drain that
  reschedules financebro / massageithaca / redis / ingress-nginx / MCP to honey/bumble,
  or an explicit "these may blip" sign-off.
- **B.** CI is quiesced (arc-runners idle or cordoned off sting) so no in-flight build
  is hard-killed and the host is not under the crash-replicating load at reboot time.
- **C.** HARD QUORUM GATE re-verified GREEN live (etcd 3/3 `started`+healthy, sting
  synced), honey+bumble healthy — re-run immediately before arming.
- **D.** *(Strongly recommended, per post-mortem)* the hardware root cause is addressed
  first, or at least the evidence-backed **NVMe/ASPM cmdline** is applied in the same
  window (see next section). No UPS remains an accepted risk (`TIN-2067`).

## NVMe/ASPM cmdline carry-forward (post-mortem NEXT) — recommend, needs packet amendment

The post-mortem's single evidence-backed kernel-adjacent change is to add
`nvme_core.default_ps_max_latency_us=0 pcie_aspm=off pcie_port_pm=off` to sting's
kernel cmdline (mitigates the P310 APST/ASPM controller-drop, `TIN-618`). This is
**not** in the current packet's ordered action set, so RUN-3 did **not** apply it
(staying inside the script-of-record; not free-lancing a cmdline mutation on a
just-recovered voter). It is the **top recommended addition** to the attended window
and should be folded into the packet via a short amendment (the same discipline the
mbp-13 lane used to add its executor clause) before it is applied — e.g. via
`grubby --update-kernel=ALL --args="nvme_core.default_ps_max_latency_us=0 pcie_aspm=off pcie_port_pm=off"`
captured before/after, during the same reboot that lands xr11.

## Parked operator / next-window script (packet steps 0–3, corrected for live state)

Run privileged via the lab `sops`-sudo become path (agent) **or** interactively by the
operator on sting. Phase by phase; stop at any failed gate. `rke2` is never
stopped/drained-as-reset/hand-restarted — the one attended reboot is the only RKE2
state change and it self-recovers. **Corrections vs RUN-1's parked script:** (a) Phase 1
xr7 removal is a **no-op** (already gone); (b) `etcdctl` is **not** at
`/var/lib/rancher/rke2/bin/` — use `crictl exec` into the `etcd-sting` pod as shown;
(c) an optional cmdline-mitigation step is included (pending packet amendment).

```bash
# ============================================================================
# STING XR KERNEL WINDOW — RUN-3 parked script | TIN-2582 | [cordillera-2026-07-09]
# One attended reboot; xr9 kept as rollback. Reschedule conditions A–D must hold.
# ============================================================================
RKE2BIN=/var/lib/rancher/rke2/bin
SOCK=unix:///run/k3s/containerd/containerd.sock
KUBE="$RKE2BIN/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml"

# ---- PHASE 0: live gates (READ-ONLY; abort if any fails) --------------------
# identity / boot selector / SELinux / rollback assets:
grubby --default-kernel; grubby --default-index; grub2-editenv - list
rpm -qa 'kernel-xr*' | sort; ls -1 /boot/vmlinuz-*; getenforce; df -h /boot
# quorum (etcdctl lives INSIDE the etcd static pod on this host):
CID=$("$RKE2BIN/crictl" --runtime-endpoint "$SOCK" ps --name etcd -q | head -1)
CA=/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt
CT=/var/lib/rancher/rke2/server/tls/etcd/server-client.crt
KY=/var/lib/rancher/rke2/server/tls/etcd/server-client.key
"$RKE2BIN/crictl" --runtime-endpoint "$SOCK" exec "$CID" etcdctl \
  --endpoints https://127.0.0.1:2379 --cacert "$CA" --cert "$CT" --key "$KY" \
  member list -w table
"$RKE2BIN/crictl" --runtime-endpoint "$SOCK" exec "$CID" etcdctl \
  --endpoints https://127.0.0.1:2379 --cacert "$CA" --cert "$CT" --key "$KY" \
  endpoint health --cluster -w table
$KUBE get nodes -o wide   # all 3 Ready
# GATE: quorum 3/3 healthy + sting started/synced voter + honey+bumble Ready,
#       SELinux Enforcing, xr9 present as rollback. Else STOP.
# Drain/cordon per reschedule cond. A/B (do NOT hard-drain stateful without a plan):
# $KUBE cordon sting

# ---- PHASE 1: /boot cleanup — NO-OP on this host (xr7 already removed) -------
# Verify only: rpm -qa kernel-xr* shows ONLY 6.19.5-9; /boot has margin. No removal.

# ---- (OPTIONAL, pending packet amendment) NVMe/ASPM mitigation — TIN-618 -----
# grubby --info=ALL | grep -o 'args=.*'                         # capture BEFORE
# grubby --update-kernel=ALL \
#   --args="nvme_core.default_ps_max_latency_us=0 pcie_aspm=off pcie_port_pm=off"
# grubby --info=DEFAULT | grep args                             # capture AFTER

# ---- PHASE 2a: acquire xr11 WITHOUT changing default (checksum-gated) --------
D=$(mktemp -d); cd "$D"
BASE=https://github.com/tinyland-inc/linux-xr/releases/download/v6.19.5-xr11
curl -fsSLO "$BASE/kernel-xr-6.19.5-11.xr.el10.x86_64.rpm"
echo "4f64a56c4f64a9902109f721d91e36199d260e8b76ad6557ccd911359184fb8c  kernel-xr-6.19.5-11.xr.el10.x86_64.rpm" | sha256sum -c -
# GATE: sha256 MUST match. On mismatch/unavailable -> STOP (fall back A′).
dnf install ./kernel-xr-6.19.5-11.xr.el10.x86_64.rpm         # adds entry; no default change
grubby --info=ALL | grep 6.19.5-11 || { echo "xr11 entry missing"; exit 1; }
grubby --set-default /boot/vmlinuz-6.19.5-9.xr.el10          # keep known-good persistent
XR11=$(grubby --info=/boot/vmlinuz-6.19.5-11.xr.el10 | awk -F= '/^index=/{print $2}')
grub2-reboot "$XR11"                                          # ONE-TIME next boot only
grub2-editenv - list                                         # expect next_entry=$XR11
grubby --default-kernel                                      # expect xr9 (unchanged)

# ---- PHASE 2b: ATTENDED REBOOT (exactly one; never touch rke2) --------------
systemctl reboot
# Bounded wait <=8 min. If sting does NOT return: STOP, no retry, report; a plain
# power-cycle self-recovers to xr9 (one-time arm only). After return, verify:
#   uname -r = 6.19.5-11.xr.el10 ; boot_id changed ; getenforce=Enforcing ;
#   systemctl is-active rke2-server = active ; etcd endpoint health 3/3 (Phase-0 cmd) ;
#   sting rejoined as started synced voter.
# GATE: ALL must pass, else ROLLBACK (below); do NOT promote default.

# ---- PHASE 2c: promote xr11 default (only after clean validate) -------------
grubby --set-default /boot/vmlinuz-6.19.5-11.xr.el10 && grubby --default-kernel
# xr9 retained as rollback.  $KUBE uncordon sting   # if cordoned.  Closes TIN-2582.

# ---- PHASE 3 (OPTIONAL, DEFER): xr12 DSC boot-validate — INERT on sting ------
# Artifact ready: linux-xr run 28996916368, kernel-xr-rpms-generic (expired=false).
# Second reboot for a T7810 chassis boot-check ONLY (no PPS/DSC on NVIDIA). If /boot
# tight, remove xr9 first (xr11 now validated default); dnf install xr12 rpm;
# grub2-reboot its index (one-time); reboot; confirm uname=6.19.5-12 + rke2 rejoin;
# grubby --set-default back to xr11. Given the unresolved hardware fault, prefer to
# SKIP the extra reboot this window (record PENDING) unless the xr11 reboot was flawless.

# ---- ROLLBACK ---------------------------------------------------------------
# grubby --set-default /boot/vmlinuz-6.19.5-9.xr.el10 && systemctl reboot
```

## Reset-run host-mutation fields (packet step 6 / `reset-run-template.md`)

| Field | Before (RUN-3 live 2026-07-09 ~14:1x EDT) | After (parked window) |
| --- | --- | --- |
| `uname -r` | `6.19.5-9.xr.el10` | **PENDING** (target `6.19.5-11.xr.el10`) |
| `boot_id` | `a9bd56f6-3b4d-40ea-b2be-8afeb5918f3d` | **PENDING** (must change post-reboot) |
| `/boot` free | **451 MB (47% used)** — xr7 already reclaimed | **PENDING** (≥ ~230 MB after xr11) |
| grubby default | **xr9** (`/boot/vmlinuz-6.19.5-9.xr.el10`, index 0) | **PENDING** (xr11 after validation; xr9 = rollback) |
| RKE2 member health | **3/3 started, synced (raft idx 65219771), leader=bumble** | **PENDING** (sting must rejoin post-boot) |
| SELinux | `Enforcing` | **PENDING** (must remain `Enforcing`) |
| kernel cmdline | default (`rhgb quiet`); **no** NVMe/ASPM mitigation | **RECOMMEND** add `nvme_core.default_ps_max_latency_us=0 pcie_aspm=off pcie_port_pm=off` (`TIN-618`, pending packet amendment) |
| P4 visual fields | **N/A — GPU-incompatible host** | **N/A — GPU-incompatible host** |

## Host end-state (RUN-3)

`sting` is **unchanged** — kernel `6.19.5-9.xr.el10` (xr9), boot_id `a9bd56f6-…`,
`/boot` 451 MB free (xr7 already gone), `grubby` default xr9, SELinux Enforcing,
`rke2-server` active, etcd quorum 3/3 started/synced (leader bumble). No package,
kernel, bootloader, cmdline, cordon/drain, or reboot mutation was performed. honey and
bumble untouched (read-only health only). Secret hygiene held throughout.

## Cross-references

- Packet: [`sting-xr-candidate-kernel-window-2026-07-08.md`](sting-xr-candidate-kernel-window-2026-07-08.md).
  Prior runs: [`…run-2026-07-09.md`](sting-xr-candidate-kernel-window-run-2026-07-09.md)
  (RUN-1, privilege-limited park), [`…run2-2026-07-09.md`](sting-xr-candidate-kernel-window-run2-2026-07-09.md)
  (RUN-2, host-offline abort = the crash).
- Post-mortem: `docs/platform/sting-wedge-postmortem-2026-07-09.md` (Dell-7810 #33).
- Trackers: `TIN-2582` (home), `TIN-618` (NVMe P310 APST/ASPM), `TIN-2067` (UPS),
  `TIN-346` (honey P4 — Beyond diagnosis stays there), `TIN-617` (etcd quorum),
  `TIN-2317` (xr12-forward), `TIN-295` (lab sting maint).
- linux-xr: release `v6.19.5-xr11` (Option A, digest `4f64a56c…fb8c`), Option B build
  run `28996916368` (`kernel-xr-rpms-generic`, expired=false), PR #69 (DSC PPS carry,
  merged, `amdgpu`-only/inert on sting).
