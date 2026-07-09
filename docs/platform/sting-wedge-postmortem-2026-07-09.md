# `sting` Wedge Post-Mortem -- 2026-07-09

Owner issue: `TIN-618` (NVMe / cooling maintenance)
Cross-links: `TIN-2067` (Tier-2 UPS), `TIN-2582` (xr9 to xr11 kernel window)
GitHub mirror: `Dell-7810#33`
Host: `sting` -- Dell Precision Tower 7810, S/N `9WSFR22`, dual-socket Xeon (Haswell-EP)
Method: read-only forensics + privileged **read** via lab sops-sudo; **no mutations, no reboot, no package/kernel change.**
Lane: `cordillera-2026-07-09` STING-POSTMORTEM. This lane does not reboot; it hands its verdict to the kernel-window lane (`TIN-2582`).

---

## TL;DR verdict

`sting` suffered an **abrupt, host-local hard stop at 2026-07-09 05:22:07 EDT**, sat dead/wedged for
**~3 h 15 m**, then came back on its own at **08:37:20 EDT** on the same kernel it crashed on
(`6.19.5-9.xr.el10`, xr9). The stop left **no kernel-panic trace of any kind** (no kdump vmcore, empty
pstore, EDAC = 0) and left **every writable XFS filesystem plus the EFI FAT partition dirty**, requiring log
recovery on the next boot. It was **not** thermal, **not** ECC/memory, **not** a clean reboot, and **not** a
site-wide power outage (three sibling hosts on the same LAN stayed up through the event).

Ranked cause:

1. **(Primary) Host-local hard power / power-delivery fault on `sting`.** Best explains: instantaneous
   silence with no shutdown sequence, dirty filesystems, no panic trace, ~3 h dead then unattended
   self-recovery (consistent with BIOS AC-power-recovery auto-power-on), and neighbors unaffected (local, not
   site). `sting` has **no UPS** and no UPS software, so any PSU trip or wall/PDU glitch is immediately fatal.
   `sting` also has a **recurring hard-crash history** in `wtmp` across multiple kernels.
2. **(Co-primary, strongest positive hardware evidence, possibly the same root) Crucial P310 NVMe controller
   power-management fault (`TIN-618`).** During this same boot session the kernel logged the P310
   (`nvme1`, `/srv/fast-local`) **falling off the PCIe bus** (`CSTS=0xffffffff, PCI_STATUS=0xffff`) and
   **explicitly blamed a faulty power-saving mode**, recommending
   `nvme_core.default_ps_max_latency_us=0 pcie_aspm=off pcie_port_pm=off`. That workaround is **not applied**
   (default cmdline, ASPM policy `[default]`). Under the heavy Nix build I/O running at crash time, an NVMe
   controller drop / error-handler stall can wedge all disk I/O (journald goes silent, box hangs). A
   `CSTS`/`PCI_STATUS` of all-`F`s is itself a power/link-loss symptom, which is why this may share root #1.
3. **(Less likely) xr9 kernel / `io_uring` hard hang.** A Nix `node-v22` build was hammering `io_uring`
   (repeated `io_uring_t` SELinux denials in the final seconds) on `6.19.5-9.xr.el10`. But **no** soft-lockup,
   hard-lockup, RCU stall, or `hung_task` was logged, the NMI watchdog was enabled, and the box is healthy on
   the **same** xr9 kernel now. No positive kernel-fault evidence.

Ruled out: site-wide power (neighbors up), thermal (temps healthy before and after, fans nominal), ECC/memory
(EDAC + MCE clean), clean reboot (dirty FS, no shutdown sequence), etcd (healthy until 05:19).

---

## Timeline (2026-07-09, EDT)

| Time | Event |
|---|---|
| 05:08:54 | rke2 etcd snapshot reconcile -- normal. |
| 05:19:01--02 | rke2 etcd snapshot reconcile -- normal (last healthy control-plane heartbeat). |
| 05:20:26--27 | rke2 remotedialer tunnels to agents close abnormally: `websocket: close 1006 (abnormal closure): unexpected EOF` (x2). First soft precursor, ~1.5 min before death. |
| 05:20:39 | Agents `bumble` and `honey` reconnect their tunnels to `sting`. |
| 05:21:10--12 | containerd tears down several pods / kube slices (churn). |
| 05:21:29--43 | Three `node` (uid 30003) processes abort with `SIGABRT` (the Nix `node-v22.22.2` build; `node_mksnapshot` hitting `io_uring_t` SELinux denials). No coredump (rlimits). |
| 05:21:47--48 | `tinyland-hardware-metrics-collector` cycles (this run consumed 49.9 s CPU / 827 MB). |
| 05:21:58 | Last non-kernel line: `setroubleshoot` SELinux denial for `node_mksnapshot` on `io_uring_t`. |
| **05:22:07** | **Last journal entry** (a benign `nftables-drop`). Journal goes **silent mid-operation. No shutdown sequence.** |
| 05:24:59 | Neighbor `bumble` logs a single dropped TCP ACK ostensibly `SRC=192.168.70.12` (sting) -- suggests the network stack may have briefly outlived the journal (points to a staged I/O-first death rather than an instantaneous power cut; weak, could be a retransmit artifact). |
| **08:37:20** | `sting` boots (cold), kernel `6.19.5-9.xr.el10`. |
| 08:37:25--28 | **XFS log recovery** on root (`dm-0`), `nvme0n1p2`, and data volumes `dm-3/4/5/6/8/9`; journald file "corrupted or uncleanly shut down"; EFI `FAT-fs (sda1)` "not properly unmounted." |
| ~08:37+ | rke2-server active, node `Ready` again, rejoining quorum. |

The ~3 h 15 m gap between last log (05:22:07) and boot (08:37:20) is **not** an auto-panic-reboot (those fire
in seconds). The box was dead/wedged the whole interval and recovered without a logged shutdown -- consistent
with power removed then restored (AC-recovery), or a hang held until an external reset.

---

## Evidence (in order of volatility)

### 1. Previous-boot (`-b -1`) crash tail -- abrupt silence, no panic
- Crashed boot ID `e6fada27...`, ran **`6.19.5-9.xr.el10` (xr9)** -- the **same** kernel as the current
  boot. This was **not** a "new kernel crashed, rolled back to old" scenario.
- Journal (persistent, on-disk) ends at **05:22:07** with benign `nftables-drop`/SELinux noise. A targeted
  scan of the crashed boot for `panic|oops|BUG|hung_task|soft lockup|rcu stall|call trace|oom-kill|thermal
  shutdown|mce|nvme timeout` found **nothing** (only boot-time init strings: thermal-governor registration,
  EDAC probe, "NMI watchdog: Enabled", and node_exporter duplicate-metric warnings).
- **No end-of-life shutdown markers** in `-b -1` (the only "Stopped target" lines are that boot's own
  `initrd -> switch-root` handoff at 05:21:55 on 07-03). Abrupt stop confirmed.

### 2. Reboot / crash history + unclean-shutdown proof
- `last -x`: the 07-03 22:21 boot -> 07-09 08:37 boot transition has **no `shutdown` record** = crash. The
  host also shows a **recurring crash pattern** historically (multiple `- crash` terminations Apr 13/20/21/26
  across both stock `6.12.0` and `6.19.5-x.xr` kernels).
- Next-boot filesystem state (the block-layer proof of a hard stop):
  - `XFS (dm-0)` root, `XFS (nvme0n1p2)`, and `XFS dm-3/4/5/6/8/9`: **Starting recovery / Ending recovery**
    (dirty logs). Only read-mostly volumes (`dm-2`, `dm-7`) mounted clean.
  - `systemd-journald`: active journal "corrupted or uncleanly shut down, renaming and replacing."
  - `FAT-fs (sda1)` (EFI): "Volume was not properly unmounted. Some data may be corrupt. Please run fsck."

### 3. Panic-mechanism negatives (three independent mechanisms all silent)
- **kdump** enabled + active, but **no new `/var/crash` vmcore** from 07-09 (only a stale `2026-05-11` dir).
  kdump has caught real panics on this box before, so its silence here is meaningful.
- **pstore** (`/sys/fs/pstore`) **empty** -- no ERST/efi-pstore panic record.
- **EDAC** `ce_count = 0`, `ue_count = 0` on both memory controllers (this boot).
- Conclusion: **no software kernel panic was recorded by any mechanism.** The stop was a hard
  power/hardware event or a hang so severe kdump could not run (kdump itself needs disk I/O).

### 4. NVMe controller power-management fault -- the key hardware finding (`TIN-618`)
During the crashed boot (2026-07-04 17:26:33, ~4.5 days before the wedge; the drive then ran fine for 4.5
more days):
```
nvme nvme1: controller is down; will reset: CSTS=0xffffffff, PCI_STATUS=0xffff
nvme nvme1: Does your device have a faulty power saving mode enabled?
nvme nvme1: Try "nvme_core.default_ps_max_latency_us=0 pcie_aspm=off pcie_port_pm=off" and report a bug
nvme nvme1: 32/0/0 default/read/poll queues        # reset recovered
```
- `nvme1` = **Crucial CT2000P310SSD8 2TB**, fw `VACR011` -- this is `sting`'s `/srv/fast-local`
  (`sting-nvme-fast`, per TIN-618). Linked at PCIe `5.0 GT/s x4`.
- `CSTS=0xffffffff / PCI_STATUS=0xffff` = the controller **dropped off the PCIe bus** (all-`F`s reads).
  The kernel's own heuristic attributes it to a **faulty APST/ASPM power-saving mode** -- a well-known
  consumer-NVMe failure class.
- The recommended mitigation is **not applied**: running `/proc/cmdline` is the default
  `... rhgb quiet` (no `nvme_core.default_ps_max_latency_us`, no `pcie_aspm=off`), and
  `/sys/module/pcie_aspm/parameters/policy` = `[default]` (ASPM power-saving active).
- Only one such event in the retained journals (boots 0/-2/-3 clean; no PCIe AER errors on any boot), so it
  is **not** yet chronic -- but it is a proven failure mode on the exact drive TIN-618 tracks, and it is a
  plausible trigger for an I/O-subsystem hang under the heavy build I/O present at crash time.

### 5. Thermal -- ruled out
- Crashed-boot start temps healthy (CPU 48--51 C, cores 37--49 C, SODIMM 29--43 C).
- Current temps healthy: CPU packages 47--48 C, cores 39--45 C (`high` 77 / `crit` 87), NVMe/GPU ~46--47 C,
  fans 4200--5747 RPM (Processor Fan near max spec, Other Fan nominal). No thermal-throttle / critical /
  thermal-shutdown ever logged. `dmidecode` chassis Thermal State = `Safe`.

### 6. ECC / MCE -- ruled out
- No `mce:` / Machine Check / EDAC corrected-or-uncorrected events in any boot. `mcelog`/`ras-mc-ctl` not
  installed; EDAC sysfs counters 0. (`sb_edac` for dual Haswell-EP is loaded and probing normally.)

### 7. Power / UPS + sibling correlation (local, not site-wide)
- **No UPS**: neither `nut`/`upsc` nor `apcupsd`/`apcaccess` is installed; there is no UPS signal path
  (`TIN-2067`). `dmidecode` chassis Power-Supply State = `Safe` (current reading only, not historical).
- **Sibling hosts on the same LAN did NOT drop at 05:22** -- decisive against a building/circuit outage:
  - `honey` up 13 d (since 06-25), logging normally at 05:24:59 07-09.
  - `yoga` up since 07-06, logging at 05:24:49 07-09.
  - `bumble` (192.168.70.**11**, `sting`'s immediate neighbor at .**12**) up since 07-04, logging at
    05:24:59 07-09.
- Therefore the loss was **specific to `sting`** (its PSU / power connector / outlet / PDU port), not shared
  power. This is exactly the failure mode `TIN-2067`'s Tier-2 UPS ("sting PSU surge") is meant to cover.

### 8. rke2 / etcd -- not causal
- etcd snapshot reconciliation was normal through 05:19:02. The only anomaly is the 05:20:26 remotedialer
  tunnel blip + 05:20:39 agent reconnects (~1.5 min pre-death) -- consistent with the box *beginning to
  struggle*, not an etcd fault. `sting` is the RKE2 server / embedded-etcd member; it rejoined quorum cleanly
  post-boot (node `Ready`, `rke2-server` active).

---

## Recommendations / handoff

**To the kernel-window lane (`TIN-2582`, owns the reboot):**
1. **Apply the NVMe/PCIe power-management workaround while the reboot is already happening** -- add
   `nvme_core.default_ps_max_latency_us=0 pcie_aspm=off pcie_port_pm=off` to the kernel cmdline (or set ASPM
   policy to `performance`). This is the kernel's own recommendation for the observed P310 controller drop and
   is independent of xr9-vs-xr11.
2. The **xr9 -> xr11 catch-up is worth doing** and *may* carry newer NVMe/PCIe-PM handling, but there is **no
   direct kernel-fault evidence** here (no lockup/panic trace, same kernel healthy now) -- so **xr11 is not a
   proven fix** for this wedge. Do not represent it as one. The `/boot` cleanup + fresh window packet gates in
   `TIN-2582` still apply; `sting` is a live etcd quorum member -- attend/drain, never break quorum as a reset
   lever.

**Hardware / power (`TIN-618` + `TIN-2067`):**
3. Treat `sting`'s **power delivery** as suspect: inspect/re-seat PSU power connectors, consider PSU age/health
   on this 7810, and confirm the BIOS **AC Power Recovery** setting (its "self-reboot" behavior implies
   AC-recovery = On/Last-state).
4. `TIN-2067` (Tier-2 UPS for bumble+sting) now has a **concrete real-world justification**: an unprotected,
   host-local hard power loss that cost ~3 h of downtime and dirty filesystems. Prioritize.
5. Install on-box disk-health tooling (`smartmontools` / `nvme-cli`): **neither is present**, so proactive
   SMART monitoring (unsafe-shutdown / media-error / wear counters) is currently blind. This blocked the
   direct power-loss-count confirmation in this very investigation.

**This lane does not reboot.** Verdict handed to `TIN-2582`.

---

## Method & scope

- Read-only journald/sysfs/`last` reads (unprivileged where possible; the persistent journal is readable by
  `jess`), plus privileged **reads** (`dmidecode`, `sensors`, `pstore`, EDAC) via the lab sops-sudo pattern
  (`bazel/capture-tinyland-lab-host-rollout-preflight.sh` `privileged_boot_selector` shape; per-host secret
  `nix/secrets/hosts/sting.yaml`, decrypted on-host with the host age key).
- **No mutations, no reboot, no drain, no package/kernel/bootloader change.** Honey and the other siblings
  were touched only with read-only health probes.
- No secret material is recorded in this document. `smartctl`/`nvme-cli` being absent, NVMe SMART persistent
  counters (unsafe-shutdowns/power-cycles/media-errors) could not be read directly; the power-loss conclusion
  rests instead on the dirty-filesystem recovery, absent-panic mechanisms, and sibling non-correlation.

## Raw evidence appendix (key excerpts)

```
# last -x (transition with no shutdown = crash)
reboot  system boot 6.19.5-9.xr.el10 Thu Jul  9 08:37:25 2026   still running
reboot  system boot 6.19.5-9.xr.el10 Fri Jul  3 22:21:55 2026   still running   # no shutdown between = crash
... (historical: multiple "- crash" terminations Apr 13/20/21/26, stock 6.12 and xr kernels)

# journalctl --list-boots
-1 e6fada27... Fri 2026-07-03 22:21:50 -> Thu 2026-07-09 05:22:07   # crashed boot, xr9
 0 a9bd56f6... Thu 2026-07-09 08:37:20 -> ...                       # recovery boot, xr9

# next-boot filesystem recovery (unclean stop)
XFS (dm-0): Starting recovery ... Ending recovery
XFS (nvme0n1p2): Starting recovery ... Ending recovery
XFS (dm-3/4/5/6/8/9): Starting recovery ... Ending recovery
systemd-journald: ... system.journal corrupted or uncleanly shut down, renaming and replacing.
FAT-fs (sda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.

# panic mechanisms all silent
/var/crash: only 127.0.0.1-2026-05-11-03:16:27 (stale); kdump enabled+active
/sys/fs/pstore: empty
edac mc0/mc1 ce_count=0 ue_count=0

# NVMe controller power-management fault (TIN-618 drive)
nvme nvme1: controller is down; will reset: CSTS=0xffffffff, PCI_STATUS=0xffff
nvme nvme1: Does your device have a faulty power saving mode enabled?
nvme nvme1: Try "nvme_core.default_ps_max_latency_us=0 pcie_aspm=off pcie_port_pm=off" and report a bug
/proc/cmdline: BOOT_IMAGE=(hd3,gpt2)/vmlinuz-6.19.5-9.xr.el10 root=/dev/mapper/rl-root ro crashkernel=... rhgb quiet
/sys/module/pcie_aspm/parameters/policy: [default] performance powersave powersupersave

# drives
nvme0 HFM256GDJTNG-8310A (SK Hynix 256G, boot)   nvme1 CT2000P310SSD8 (Crucial P310 2T, /srv/fast-local)
sda Samsung SSD 860 DCT 3.84T (sata)             sdb Micron M550 512G (sata)

# sibling non-correlation (no site-wide outage) -- all up through 05:22 on 07-09
honey up 13d; yoga up since 07-06; bumble (.11, sting's neighbor) up since 07-04
```
