# Kernel-Proof Sequencing — sting-then-honey (2026-07-09)

Status: **DESIGN + RECALL ONLY.** No host mutation, no reboot, no drain, no
purchase authorized or performed by this document. It records a promotion
pipeline, a reboot-safety minimum, a role reconciliation, and a procurement
horizon so downstream execution lanes have one place to sequence against.
Provenance: `[cordillera-2026-07-09]`, operator-directed (Jess, in-session
2026-07-09).

This note is the T7810-platform-side companion to three artifacts that all
landed the same day and that, read naively, appear to disagree about what
`sting` is for:

- `sting-xr-candidate-kernel-window-run3-2026-07-09.md` (RUN-3 — privileged
  gates GREEN, reboot deliberately parked),
- Linear `TIN-2715` ("Migrate production workloads off sting … to reclassify it
  off kernel-candidate duty," Done as a scoping ticket),
- rockies PR #260 (amended `docs/cordillera-machine-matrix-2026-07-06.md`:
  "sting is a PRODUCTION + etcd-voter host, NOT an XR/kernel-candidate host").

§1 reconciles those. §2 states the promotion pipeline and what transfers
`sting`→`honey`. §3 is the reboot-safety minimum. §4 records the Dell
procurement horizon. §5 lists non-claims.

---

## 1. Reconciliation — sting is BOTH a prod/etcd host AND the reaffirmed kernel-proof host

**The apparent contradiction.** The 2026-07-08 "R2" ratification (as amended by
rockies PR #260 on 2026-07-09) reads role-exclusive: sting is prod + etcd voter,
*not* a kernel-candidate host, and kernel-candidate boot-validation must move
*off* sting. The 2026-07-09 operator steer this document lands under reads the
other way: sting is **reaffirmed as the kernel-proof host**; the goal is to make
it safely reboot-able for kernel proofing, **not to evacuate it**.

**The resolution the operator directed: reboot-safety discipline, not
role-exclusivity.** These two framings are the same trajectory seen from
opposite ends, not a genuine fork:

- What PR #260 actually established is that sting is **unsafe to reboot on a
  whim today** — it carries a single-replica customer-facing prod surface
  (`software.tinyland.dev`, both replicas on sting) and is 1-of-3 etcd voters
  (TIN-617). That is true and stays true. "Kernel-candidate boot-validation must
  move off sting" is correct **as a statement about the unsafe-today
  condition**.
- What the operator's ruling adds is the *direction of travel*: the fix is to
  make sting reboot-safe (the TIN-2715 make-before-break minimum in §3), **then
  keep using it as the proof box** — not to strip it of the role permanently.
  "Migrate prod off sting, then use it" (TIN-2715, verbatim operator ruling) is
  a **make-before-break for reboot-safety**, not an evacuation that ends in
  abandonment.

So the reconciled reading is: replace PR #260's gate wording

> "kernel-candidate boot-validation must move OFF sting **until prod is
> migrated**"

with the reboot-safety-discipline wording

> "kernel-candidate boot-validation stays OFF sting **until sting clears the
> reboot-safety minimum (§3)**; once it clears, sting is the intended
> kernel-proof host."

Same gate, same near-term behavior (no casual sting reboots yet), but the
end-state is "sting kept as the proof box," not "sting is never a
kernel-candidate again." sting holds **both** roles concurrently; the discipline
that lets it is the drained, quorum-aware, attended reboot window — covered in
§3.

**The one fork this does NOT silently close.** PR #260 left an explicit open
question for the operator: *where do 7.1.y/xr12 candidates boot-validate in the
interim* — honey off-hours, a dedicated non-prod box, or accepting the
honey-first path. This document does not need to force that decision this week,
because **nothing is currently built to boot-validate on any host** (see §2, gate
1: no 7.1.y RPM exists yet). The honest interim answer is: the question does not
bind until a 7.1.y RPM exists; when it does, the intended host is a
reboot-safe sting, with the dedicated iteration box (§4) as the eventual clean
separation.

**Cross-repo note (not an action here).** The rockies
`docs/cordillera-machine-matrix-2026-07-06.md`, as amended by PR #260, currently
reads role-exclusive. Reconciling its wording to the reboot-safety-discipline
framing above is a rockies-owned follow-up; this Dell-7810 doc does not amend it.

---

## 2. The promotion pipeline — CI RPM → boot/RT/stability on sting → trusted on honey

The pipeline is **staged and per-host**. There is no single fleet-wide "trusted"
flag; a kernel is trusted on the host whose own staged one-time-boot validated it
clean. Between a CI build and a promoted default on honey:

| Gate | Proves | Owner | State for the live candidate (7.1.y / xr12) |
|---|---|---|---|
| **0. Base-anchor** | Case-sensitive checkout matches the pinned upstream tag; all carry patches apply zero-fuzz; RPM security-preflight (CVE disposition) | `linux-xr` | **Passed** for `v7.1.3` (PR #83, merged 2026-07-06). All 3 tracked CVEs fixed natively at 7.1.3; no security backports apply. |
| **1. Full RPM build** | Produces the actually-installable `.rpm` set | `linux-xr` | **Not yet run for 7.1.y.** `xr/source-sync.md`: the last published line stays until a `7.1.3` generic RPM proof is built and host-validated. TIN-611 (amdgpu DSC PPS carry-refresh, PR #85) is the in-progress precondition. The only published, RPM-complete lab line remains **`v6.19.5-xr11`**. |
| **2. Chassis boot-validation** | RPM installs + boots clean on a real T7810 (kernel/initramfs/bootloader/RKE2-rejoin/SELinux mechanics) | `Dell-7810` | **This is the step sting substitutes for honey** — GPU-agnostic. Currently exercised only for the xr9→xr11 catch-up (an already-boot-proven line), *not* for the 7.1.y candidate (nothing built to boot yet). |
| **3. RT validation (RT variant)** | One-time RT boot; `uname -v` shows `PREEMPT_RT`; `/sys/kernel/realtime=1`; then BIOS A34 + low-latency posture + `smi-validate-full` + bounded SMI count before RT becomes a persistent default | `Dell-7810` | **RT is stuck on the old base.** No `7.1.x` PREEMPT_RT patchset proven yet, so RT stays pinned at `v7.0.1-rt2`. Generic and RT lines are on different upstream bases until a compatible 7.1.x RT patch appears — a fork-divergence risk for the BCI/low-latency mission. |
| **4. P3→P4 visual first-frame** | OpenXR/Monado session `FOCUSED` + correct eye swapchains = P3; actual non-black in-goggles output = P4 | XoxdWM / honey | **honey-ONLY** — cannot move to sting at all (see §2.2, TIN-346). |
| **5. Per-host default promotion** | `grubby --set-default` only after that host's own staged one-time-boot validated clean | `Dell-7810` | Standing rule: stage `--no-set-default` → `grub2-reboot` one-time-next-boot → attended reboot → verify → **only then** promote. Never `--set-default` an unvalidated kernel. |

**Net.** The sting kernel window that is actually ready to run *today* (the
xr9→xr11 catch-up, TIN-2582) is **fleet hygiene on the old published line**, not
a proof step for the new 7.1.y/xr12 candidate. That candidate has not cleared
gate 1 on any host, so "proof it on sting before honey" is presently a
forward-looking design statement, not an executable-this-week action. The
sequencing this doc commits to is: **when a 7.1.y RPM exists → gate 2/3 on a
reboot-safe sting → only then gate 4/5 on honey.**

### 2.1 What transfers sting→honey (the operator's framing, confirmed)

sting (Dell Precision T7810, DMI-confirmed) and honey (Dell Precision T7810) are
the **same chassis class**, so everything that is a function of the chassis and
the boot/kernel/RPM mechanics transfers:

- kernel / boot / RPM install-and-rollback mechanics,
- `/boot` capacity procedure,
- the one-time-next-boot GRUB rule (stage → `grub2-reboot` → attend → promote),
- the generic install supplier surface,
- the RKE2 embedded-etcd reboot-safety model,
- the T7810-generic low-latency / RT config baseline
  (`packaging/kernel/t7810-host-latency-{base,rt}.config`,
  `t7810-host-latency.cmdline` — repo-owned as chassis-generic, not
  honey-specific; see `kernel-lane.md`),
- and, critically, **a chassis boot-validation of the RPM package itself**
  (gate 2): does this RPM install and boot cleanly on a real T7810.

This is the whole value of sting as the proof box: it lets a T7810 eat the
first, riskiest reboot of a freshly-built kernel **without** that first reboot
being on the exotic BCI rig.

### 2.2 What is honey-ONLY (does not transfer — GPU class is the blocking variable)

honey's exotic profile — **AMD RX 9070 XT (Navi 48 / RDNA4, `amdgpu`), DP 1.4
with DSC, dual PSU, the BCI/XR rig** — is exactly the part sting cannot stand in
for. sting's GPUs are 2× NVIDIA GK107 [NVS 510] (Kepler, `nouveau`), DP 1.2, no
DSC, and no viable modern Vulkan/OpenXR path (NVK needs Turing+; the legacy 470
driver does not support Rocky 10 / 6.19 kernels).

| | honey | sting | Transfers? |
|---|---|---|---|
| Chassis | Dell Precision T7810 | Dell Precision T7810 | **Yes** |
| GPU | AMD RX 9070 XT (RDNA4, `amdgpu`) | 2× NVIDIA GK107 NVS 510 (Kepler, `nouveau`) | **No** |
| Display pipe | DP 1.4 + DSC (Beyond 2e native) | DP 1.2, no DSC | **No** |
| OpenXR / Vulkan | Mesa RADV, full Vulkan | No modern Vulkan/OpenXR | **No** |
| Power | dual PSU | single PSU | n/a |

Honey-only gates, confirmed **blocked, not merely deferred** on sting (the
blocking variable is GPU class, not hostname — no amount of "adapt the packet"
rescues them):

- any AMD DSC PPS capture (linux-xr PR #69's debugfs carry is `amdgpu`-only and
  inert on sting — it never binds a device, captures nothing);
- any Beyond 2e panel-state / HID-wake observation;
- the entire **P3→P4 visual-first-frame** diagnosis (TIN-346). The honey P4
  window packet explicitly marks physically moving the Beyond 2e to sting as
  BLOCKED / NOT RECOMMENDED.

**So the honey-only tail of the pipeline is: gate 4 (P4 visual first frame) and
every DSC/panel/HID diagnostic.** Those are the reason honey is the *final*
target and can never be fully pre-proven on sting — sting proves the kernel
boots and is stable on a T7810; honey is where the kernel meets the display
stack that only exists there.

### 2.3 Live artifact clock (feeds both sting and the honey P4 window)

The sting Option-B pre-stage (linux-xr `build-kernel.yml` run `28996916368`,
`kernel-xr-6.19.5-12.xr.el10`, generic) is the **same artifact** honey's P4
window needs for its own Option A. It was rebuilt because the honey packet's P0
precondition (artifact expired 2026-06-11) was unmet; the sting-lane rebuild
satisfies it as a byproduct. **That artifact expires 2026-08-08.** If the honey
P4 window does not run before then, this precondition lapses a third time this
program.

---

## 3. sting reboot-safety minimum — must-fix vs nice-to-have

This is the **make-before-break list from TIN-2715**, scoped specifically to
"safe to take a single, attended, kernel-proofing reboot," not to full
evacuation. The operator keeps sting as the proof box; other machines are the
lower-hanging fruit. Grounded in RUN-3 (what it actually gated on) + TIN-2715
(the census), not the pre-amendment R2 view.

### MUST-FIX before the first kernel-candidate reboot on sting

| # | Item | Ticket | Why it gates | Cost |
|---|---|---|---|---|
| M1 | **Spread `software.tinyland.dev` off both-on-sting.** `software-homegrown-prod/software` is Deployment 2/2 but *both* replicas landed on sting (soft/`preferred` anti-affinity failed to spread). A sting reboot takes the whole surface down. | TIN-2715 (gap B), `software.tinyland.dev` track | The one genuinely-not-HA customer-facing surface on sting. Everything else customer-facing already survives a sting loss (required anti-affinity or honey+sting spread). | Cheap: force one replica to honey, or harden anti-affinity to `required`. |
| M2 | **Live quorum re-check immediately before arming, every time.** honey + bumble both `Ready`/etcd-healthy at the moment of arming; abort before reboot if not. | TIN-617 | Standing procedural gate, not a one-time fix. RUN-3 proved it is checkable via `crictl exec` into the `etcd-sting` static pod for `etcdctl` (the host has no `etcdctl` at `/var/lib/rancher/rke2/bin/`). | Procedure only. |
| M3 | **CI quiescence for the window** — cordon / idle the `arc-runners` compute-expansion scale-sets on sting. | TIN-2715 (class E), TIN-2460/2454 | RUN-3 park reason #2: sting was under the same heavy-build load profile that co-occurred with the 05:22 crash. Rebooting into a new kernel under that load neither validates cleanly nor is a safe moment to hard-kill in-flight CI. | Cordon + wait. |
| M4 | **Cordon and accept the acceptable blips** (not a full evacuation). The two Redis StatefulSets on sting are `emptyDir` (no PVC) → reschedule costs only a cache cold-start; financebro's 7 workers reschedule cleanly to honey (their Postgres/TigerBeetle state already lives on honey). No customer-facing prod *data* lives on sting local disk. | TIN-2715 (classes C/D), TIN-1304 | Confirms the drain is a compute-reschedule, not a data migration — so an attended reboot is bounded and reversible. | Cordon; accept a cache cold-start. |

### NICE-TO-HAVE — real residual risk, but not gating a single attended reboot

| # | Item | Ticket | Disposition |
|---|---|---|---|
| N1 | **Tier-2 UPS.** | TIN-2067 | RUN-3 verbatim: "no UPS remains an accepted risk." Not required to gate this reboot, but it is the single most concrete justification the UPS ticket has ever had — a real ~3h15m unprotected power-fault outage on this exact box the same morning (2026-07-09 05:22). |
| N2 | **NVMe / ASPM cmdline mitigation** — the kernel's own diagnostic recommendation (`nvme_core.default_ps_max_latency_us=0 pcie_aspm=off pcie_port_pm=off`) for the proven Crucial P310 controller-drop failure mode. | TIN-618 | Cheap and recommended to apply in the *same* reboot that lands the kernel, but not yet in the window packet's ordered action set, so it was not applied at RUN-3. Fold into the packet by amendment. |
| N3 | **Full hardware root-cause closure** — PSU re-seat/inspection, confirm BIOS AC-Power-Recovery, install `smartmontools`/`nvme-cli` for future SMART visibility. | TIN-618, TIN-337/339 | Recommended, not blocking: no *active* fault was found live at RUN-3 (dmesg/thermal/EDAC clean). |
| N4 | **Broader TIN-2715 migration** — permanent CI-runner repoint, `gf-reapi-cell` placement (TIN-2453), financebro placement guarantees. | TIN-2715, TIN-2453 | Evacuation-class work; required only to make sting a *standing-always-available* disposable box, not for an occasional attended kernel-proofing reboot. |

### STRUCTURAL — must be lived with or redesigned (not a "fix")

sting is **1-of-3 rke2 embedded-etcd voters** (honey `b1d6b8eb8ff1b710` / sting
`1c95c2eabb6abf01` / bumble `97469e6753157feb`, TIN-617). *Every* sting reboot
drops quorum to 2/3 with **zero** further fault tolerance for that window,
regardless of workload state. Making sting a *true throwaway* kernel-candidate
box (repeated reboots without this caution) requires either removing it from the
etcd quorum (reshape the control-plane pool / provision a different third voter)
or permanently accepting **attended, quorum-checked, one-at-a-time** reboots.
That is a TIN-617 HA-design decision, out of scope for a single-window fix — and
it is precisely what the dedicated iteration box in §4 would relieve.

### Tooling gap (blocks clean repeatability of exactly this discipline)

`rockies/bazel/capture-tinyland-lab-host-rollout-preflight.sh`'s host `case` only
wires `honey|mbp-13|yoga` — **sting is not wired**, so the canonical D13 preflight
capture had to be hand-substituted for all three 2026-07-09 sting runs. Small
fix; tracked-adjacent to TIN-2582.

---

## 4. The Dell procurement horizon — dedicated full-cycle kernel-iteration chassis

**Record only. No purchase authorized here. Operator-gated.** The operator (Jess,
2026-07-09) intends to buy **additional Dell Precision T7810 chassis
(honey/sting-class)** for **dedicated full-cycle kernel iteration**. This
document records the intent and what it would change; it does not select a
vendor, a quantity, a price, or a date, and it authorizes no spend.

**Why it matters to the sequencing above.** Today sting carries double duty: it
is simultaneously a production + etcd-voter host **and** the kernel-proof host.
Every §3 must-fix and the §3 structural caveat exist *only because* sting is
coupled to prod and quorum. A dedicated iteration box breaks that coupling:

- **Throwaway kernel-candidate reboots** with no prod surface and no etcd voter
  attached — reboot as often as the build cadence wants, no drain, no quorum
  math, no attended-window discipline, no customer-facing blast radius.
- **Removes the etcd-voter reboot penalty** (§3 structural) from the
  kernel-proof loop entirely: an iteration box that is not in the honey/sting/
  bumble quorum can cycle without touching cluster fault tolerance.
- **Frees sting from double-duty.** With a dedicated iteration chassis, sting can
  settle into its prod + etcd-voter role (the PR #260 reading) *without* the
  reboot-safety tension, because the kernel-proof role moves to the throwaway
  box. sting stays available as an *additional* T7810 proof surface when
  convenient, but is no longer the *only* one.
- **Same chassis class = the §2.1 transfer set still holds.** An additional
  T7810 inherits the entire "transfers sting→honey" surface for free; it does
  **not** inherit the honey-only tail (§2.2) — it is a Kepler/nouveau-or-
  whatever generic-GPU boot/stability proof box, still not a P4 surface. honey
  remains the final target for the same GPU-class reason.

**Explicitly still honey-gated regardless of how many T7810s exist.** Buying more
chassis does not move gate 4 (P4 visual first frame) or any DSC/panel/HID
diagnostic off honey — those need the RX 9070 XT / DP-1.4-DSC / Beyond 2e path
that is honey-only. More iteration boxes shorten the *boot/RT/stability* half of
the pipeline; the *display-stack* half stays on honey.

**Sequencing note.** This horizon does not block anything in §2–§3. The
reboot-safety minimum is the near-term path (it makes today's single sting
usable); the dedicated iteration box is the medium-term path (it removes the
reason the minimum is fiddly). They are complementary, not alternatives.

A Linear ticket records this horizon in the Backlog (operator-gated purchase),
cross-linked to honey/sting/TIN-618/TIN-2067. See §Anchors.

---

## 5. Non-claims

- This document authorizes **no** host mutation, reboot, drain, cordon,
  `kubectl apply/delete/scale`, kernel install/removal, bootloader change, or
  `/boot` cleanup on any host.
- It authorizes **no** purchase and selects no vendor/quantity/price/date.
- It does not claim sting is drained, reboot-safe, or migrated today — it is not
  (`software.tinyland.dev` is single-node on sting and sting is a no-UPS etcd
  voter).
- It does not move any product initiative's target date.
- It does not amend the rockies machine-matrix or PR #260; it reconciles their
  *reading* and flags a rockies-owned follow-up (§1).
- The M1 signed-budgie-repo publish and any registry decision are **not** part of
  this doc; they belong to the registry-charter lane and stay with the
  orchestrator.

---

## Anchors

- **Reclassification arc (2026-07-09):** `sting-xr-candidate-kernel-window-run3-2026-07-09.md` (RUN-3) → `TIN-2715` → rockies PR #260 (amends `docs/cordillera-machine-matrix-2026-07-06.md`).
- **Kernel window packet + runs:** `sting-xr-candidate-kernel-window-2026-07-08.md`, `…-run-`/`-run2-`/`-run3-2026-07-09.md`, `sting-wedge-postmortem-2026-07-09.md`.
- **Kernel base/line:** `TIN-2317` (7.0.x→7.1.y, Done), `TIN-611` (RPM carry-refresh, in progress, linux-xr PR #85), linux-xr `xr/source-sync.md` (base/RT/CVE table), linux-xr PR #83 (v7.1.3 base-anchor).
- **Host baseline / ownership split:** `kernel-lane.md`, `packaging/kernel/t7810-host-latency-{base,rt}.config`, `t7810-host-latency.cmdline`.
- **Honey P4 (honey-only tail):** `TIN-346`, `honey-p4-visual-first-frame-operator-window-2026-07-06.md` (unexecuted), rockies `docs/p4-composition-gate.md` (TIN-2578); linux-xr PR #69 (amdgpu DSC PPS debugfs carry).
- **Reboot-safety tickets:** `TIN-617` (HA/quorum), `TIN-618` (NVMe/ASPM + cooling), `TIN-2067` (Tier-2 UPS), `TIN-2582` (sting kernel lag / `/boot`, open), `TIN-2453` (gf-reapi-cell pin), `TIN-1304` (financebro placement), `TIN-2677` (honey capacity — the cost of concentrating prod on honey).
- **Procurement horizon:** the new Backlog ticket (§4), Infrastructure project, cross-linked honey/sting/TIN-618/TIN-2067.
