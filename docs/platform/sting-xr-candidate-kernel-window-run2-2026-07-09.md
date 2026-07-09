# Sting XR-Candidate Kernel-Window — Run Record RUN-2 (ATTENDED EXECUTION ATTEMPT) 2026-07-09

Status: **ABORTED BEFORE FIRST MUTATION — host `sting` unreachable at window
start.** Zero mutations were performed on any host. This is the attended
execution attempt that follows the stage-and-park record
[`sting-xr-candidate-kernel-window-run-2026-07-09.md`](sting-xr-candidate-kernel-window-run-2026-07-09.md)
(RUN-1) for the window packet
[`sting-xr-candidate-kernel-window-2026-07-08.md`](sting-xr-candidate-kernel-window-2026-07-08.md)
(home tracker [`TIN-2582`](https://linear.app/tinyland/issue/TIN-2582); cross-link
[`TIN-346`](https://linear.app/tinyland/issue/TIN-346)). Executed under the
Cordillera execution wave, agent lane, stamped `[cordillera-2026-07-09]`.

## What changed vs RUN-1

RUN-1 was **STAGE-AND-PARK** because the privilege probe `ssh sting "sudo -n true"`
required a password and the lane would not self-escalate. For RUN-2 the operator
**upgraded the authorization to full agent execution** of the staged packet,
explicitly granting the `lab` sops/age become-password mechanism
(`nix/secrets/hosts/sting.yaml` → remote `sops -d` with the host age key →
`.become.password` → `sudo -S`; the canonical `privileged_boot_selector` pattern in
`rockies/bazel/capture-tinyland-lab-host-rollout-preflight.sh`). sting's SOPS agent
auth was provisioned under `TIN-295` (lab PR #420), so the become path is
present-and-ready on this host. This run was therefore cleared to execute the
parked script phases 0–2 (kernel install + one attended reboot + promote-default)
rather than merely stage them.

## Fresh reachability preflight (window start `20260709T093743Z`) — sting is DOWN

Per the rails, live state was re-verified before any mutation. **`sting` is
unreachable at the network layer** — the hard precondition for every phase (all of
Phase 0's privileged preflight and the DEEP etcd quorum gate run *over SSH on
sting*) is not satisfiable:

| Probe | Result |
| --- | --- |
| `ssh -o ConnectTimeout=8 sting` ×3 | `connect to host 100.85.46.118 port 22: Operation timed out` (all 3) |
| `ping -c5 100.85.46.118` | **5 transmitted, 0 received, 100% packet loss** |
| `tailscale status` (sting row) | `100.85.46.118 sting tagged-devices linux active; relay "nyc", tx 2184 rx 0` — path allocated, **rx 0: no return traffic** |
| bounded recovery poll (~5 min, 20 s cadence) + a 4th direct probe minutes later | no recovery — every attempt across the window timed out |

`tx N / rx 0` with 100 % ICMP loss and no SSH is a host that is **offline or hung**
(powered off, kernel-hung, or network-stack-dead), not merely SSH-filtered. The
node is not on the network.

### Peer voters (read-only, non-privileged — the two hosts that ARE up)

| Voter | Kernel | `rke2-server` | boot_id |
| --- | --- | --- | --- |
| honey | `6.19.5-11.xr.el10` (xr11) | **active** | `f5dc8aaf-1385-4ce7-8ab1-f26af38e5406` |
| bumble | `6.12.0-124.8.1.el10_1.x86_64` (stock) | **active** | `1294abbb-678a-40d9-b65c-4c61cde1a612` |
| **sting** | — | **UNREACHABLE** | — |

## Quorum interpretation (load-bearing — no remediation performed)

The odd-3 etcd quorum is honey `b1d6b8eb8ff1b710` / sting `1c95c2eabb6abf01` /
bumble `97469e6753157feb` (`TIN-617`); it tolerates exactly one member down. With
sting down and honey+bumble both `rke2-server active`, the control-plane quorum is
**INTACT but DEGRADED** — 2 of 3 voters healthy, **zero further fault tolerance**
until sting returns. This lane performed **no** remediation and **no** quorum
mutation: sting is unreachable (nothing to do there), `honey` is a hard-never for
this lane beyond read-only status, and `rke2` is never stopped/drained/restarted
anywhere. The degraded-but-safe quorum is reported for operator action, not acted
on here.

## Decision — HARD STOP before Phase 0

Because Phase 0 (fresh privileged preflight: `grubby --info=ALL`, `dnf history`,
and the DEEP gate `etcdctl member list` + `endpoint health` on sting as root) and
every subsequent phase run **on sting over SSH**, and sting is unreachable, the
window **cannot be entered**. Per the execution rails ("if the host does not
return STOP EVERYTHING and report — no retries, no further mutations anywhere")
and the packet abort criterion ("sting does not return within ~8 min → stop, do
not retry"), the lane **stops here**:

- **Phase 0 (gates):** NOT RUN — sting unreachable.
- **Phase 1 (/boot xr7 cleanup):** NOT RUN.
- **Phase 2 (xr9 → xr11 install / one-time-boot / reboot / promote):** NOT RUN.
- **Phase 3 (Option B xr12 chassis boot-validate):** NOT RUN.
- **Fallback A′ (/boot cleanup only):** also not possible — it too requires sting.

No package, kernel, bootloader, display-manager, or reboot mutation was performed
on any host. No secret material was written to any file, log, PR, or ticket.

## Option B artifact — state update (obtainability gate now MET; still deferred)

RUN-1 recorded the xr12 DSC-observability artifact as PENDING (rebuild dispatched,
run `28996916368`, queued 05:44Z). Re-checked live this run:

- linux-xr `build-kernel.yml` run **`28996916368`** on `xr/main` is now
  **`completed / success`**.
- Artifact **`kernel-xr-rpms-generic`** is **downloadable** — `expired: false`,
  `size 130,781,523 B`, `expires_at 2026-08-08T08:43:51Z`. It is the newest
  `build-kernel.yml` run on `xr/main` (no newer completed run exists).

So Option B's **obtainability precondition is now satisfied**. Option B remains
**not executed** regardless, for two independent reasons: (1) its execute-condition
requires steps 0–2 completed clean, and steps 0–2 did not run (sting down); (2) it
is **inert on sting's NVIDIA GK107 / NVS 510** hardware — the amdgpu DSC/PPS
debugfs carry never binds a device, so it would be chassis-boot-validation only,
zero P4 value. Pre-staged for a *future attended* run once sting returns.

## Rollback-asset verification

N/A — no destructive step was reached. Rollback assets (xr9 known-good, stock
fallback, rescue image) were confirmed present in the RUN-1 read-only capture and
remain sting's on-disk state (unchanged, host untouched by this lane).

## Host end-state (this session)

- **sting:** UNREACHABLE at window start and throughout; **untouched by this lane
  (zero mutations)**. Presumed last-known kernel `6.19.5-9.xr.el10` (xr9) per
  RUN-1; not re-verifiable while offline.
- **honey:** read-only status only — xr11, `rke2-server active`. Untouched.
- **bumble:** read-only status only — stock, `rke2-server active`. Untouched.
- **etcd quorum:** intact but degraded (2/3 voters) while sting is offline.

## Next (operator actions)

1. **Bring sting back online / triage why it is offline.** This is Dell-7810 host
   authority (power/console/BMC, possible relation to `TIN-618` NVMe/cooling,
   `TIN-2067` UPS, or a kernel hang on xr9). A dead etcd voter also means the
   cluster is one fault from losing quorum — worth prompt attention even apart from
   this kernel window.
2. **Re-run this window from Phase 0 once sting is reachable.** The script of
   record (RUN-1 §Parked operator script) is unchanged and still valid; the
   Option-A xr11 RPM digest `4f64a56c4f64a9902109f721d91e36199d260e8b76ad6557ccd911359184fb8c`
   is still pinned; the `lab` sops/age become path is verified-present. Nothing
   about the plan needs restaging — only the host needs to be up.
3. **Tooling gap (carried from RUN-1):** add `sting` to the supported-host `case`
   in `rockies/bazel/capture-tinyland-lab-host-rollout-preflight.sh` (currently
   honey/mbp-13/yoga only) so the D13 preflight — including the privileged
   boot-selector section via `--secret-file` — can be captured canonically for this
   host instead of a packet-named-equivalent.

## Cross-references

- RUN-1 (stage-and-park): [`sting-xr-candidate-kernel-window-run-2026-07-09.md`](sting-xr-candidate-kernel-window-run-2026-07-09.md)
  (Dell-7810 PR #31, merged). Packet:
  [`sting-xr-candidate-kernel-window-2026-07-08.md`](sting-xr-candidate-kernel-window-2026-07-08.md)
  (Dell-7810 PR #30, merged).
- Trackers: `TIN-2582` (home; stays open — catch-up NOT closed), `TIN-346` (honey
  P4 — no chassis validation ran this window, so nothing new proven for honey's
  eventual install; cross-link deferred), `TIN-617` (etcd quorum), `TIN-295` (sting
  SOPS agent auth provenance), `TIN-2317` (xr12-forward line), `TIN-618`/`TIN-2067`
  (sting hardware/power — candidate causes for the offline state).
- linux-xr: release `v6.19.5-xr11` (Option A target, unchanged), rebuild run
  `28996916368` (Option B artifact now `success`/downloadable, still deferred/inert
  on sting).
