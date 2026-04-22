# Cross-Repo Authority Hardening: Dell-7810 + XoxdWM

**Date**: 2026-04-22
**Branch**: jess/tin-339-capture-honey-reset-matrix
**Goal**: Clear purpose mapping, concrete authority moves from XoxdWM to Dell-7810,
improved discoverability for future writing and presentation.

## Context

Two sibling repos under ~/git/ serve the same physical workstation (`honey`,
a Dell Precision 7810) but tell fundamentally different stories:

- **Dell-7810**: How do you turn an old Dell workstation into a safe, measured,
  characterized host after pushing it far outside stock spec?
- **XoxdWM**: How do you build a VR-first, BCI-ready Wayland compositor that
  runs on a prepared host?

The boundary was established in a prior session (publication docs, duplication
audit tooling, Chapel lane de-dup) but concrete authority moves and cross-repo
discoverability are still missing.

## Current State

- 0 exact duplicates, 5 derived forks across repos
- Chapel analysis trees already correctly separated
- Dell-7810 has publication boundary docs (narrative-lanes, claim-traceability)
- Dell-7810 has duplication status script + justfile recipe
- XoxdWM proof docs reference honey hardware without linking to Dell evidence
- Neither README mentions the sibling repo

## Plan

### Phase 1: Cross-repo discoverability (both READMEs)

**Files to edit:**
- `~/git/Dell-7810/README.md` — add "Related Repositories" section
- `~/git/XoxdWM/README.md` — add "Related Repositories" section

**Dell-7810 README addition:**
Point to XoxdWM for compositor, XR runtime, and application stack.
Reference docs/platform/xoxdwm-boundary-audit.md as the ownership doc.

**XoxdWM README addition:**
Point to Dell-7810 for hardware design, reset behavior, power paths,
BIOS/SMI characterization, NUMA/Chapel probes, and enclosure work.
Reference the boundary audit and reset matrix by URL.

### Phase 2: Evidence anchors in XoxdWM docs

**Files to edit in ~/git/XoxdWM:**

1. `docs/honey-substrate-proof-2026-04-22.md`
   - Add cross-link to Dell-7810 reset matrix in "Host Normalization" section
   - The proof doc claims host recovery happened but doesn't link to evidence

2. `docs/support-matrix.md`
   - Add footnote: hardware setup/reset/BIOS documented in Dell-7810
   - Link honey kernel baseline claim to Dell-7810 host-kernel-baseline.md

3. `docs/grounded-milestone-plan-2026-q2.md`
   - Replace vague "is recorded and understood" with link to reset matrix
   - Replace "both documented" with link to Dell-7810 research docs

4. `docs/reality-check-2026-04-22.md`
   - Add "Hardware and Platform Claims" section
   - State: XoxdWM proves software works given stable hardware;
     Dell-7810 proves the hardware is stable

5. `docs/remote-proof-lanes.md`
   - Add "Hardware Authority for honey" paragraph
   - Before interpreting honey test results, verify host health via Dell-7810

6. `docs/research/t7810-smi-baseline.md`
   - Add deprecation note at top: original baseline lives here,
     canonical copy imported to Dell-7810, future SMI measurements
     go to Dell-7810

### Phase 3: Authority consolidation (scripts + packages)

**3a. Fix smi-validate provenance (Dell-7810)**
- File: `~/git/Dell-7810/scripts/platform/smi-validate`
- Change "derived from XoxdWM" comment to "Dell T7810 hardware validator
  (canonical source of truth); originally developed in XoxdWM, formalized here"

**3b. Fix dcc-configure-rt duplication**
- The XoxdWM copy at `packaging/scripts/dcc-configure-rt` is near-identical
  to Dell-7810's `scripts/platform/dcc-configure-rt`
- Add note in XoxdWM copy: "Canonical version lives in Dell-7810.
  This copy is kept for operational convenience but should not diverge."
- OR: Replace XoxdWM copy with a README/pointer

**3c. Mark chapel.nix provenance**
- In XoxdWM `nix/packages/chapel.nix`: add header comment
  "Canonical Chapel 2.8.0 package for T7810 NUMA characterization lives
  in Dell-7810/nix/packages/chapel.nix. This copy is a deployment fallback."
- In Dell-7810 `nix/packages/chapel.nix`: add header comment
  "Canonical source of truth for Chapel 2.8.0 on T7810 dual-socket Xeon."

**3d. Update duplication-status.md**
- Record the provenance fixes made in this session
- Update the "next de-duplication targets" section

### Phase 4: Inheritance documentation (no code moves yet)

**File to create in Dell-7810:**
- `docs/platform/authority-map.md` — single document listing every surface
  and which repo owns it, replacing the scattered notes across multiple docs

**Content: concrete authority table**

| Surface | Authority | Notes |
|---------|-----------|-------|
| Kernel baseline configs | Dell-7810 | packaging/kernel/ |
| SMI mitigation params | Dell-7810 | scripts/platform/smi-validate |
| BIOS configuration | Dell-7810 | scripts/platform/dcc-configure-rt |
| tuned low-latency base | Dell-7810 | packaging/tuned/t7810-low-latency/ |
| Reset matrix | Dell-7810 | docs/research/honey-reset-matrix-*.md |
| Power path research | Dell-7810 | docs/research/honey-power-reset-*.md |
| Enclosure + coupon lane | Dell-7810 | cad/, data/measurements/ |
| Chapel host characterization | Dell-7810 | analysis/src/HostNumaTiming, TimingProofs |
| Chapel PBT (quickchpl) | Dell-7810 | analysis/test/ |
| Platform.dhall (T7810 type) | XoxdWM (candidate to move) | packaging/dhall/Platform.dhall |
| honey boot topology (dhall) | XoxdWM | packaging/dhall/defaults/honey-*.dhall |
| XR kernel overlay | XoxdWM | nix/kernel/xr-kernel.nix |
| tuned xr-bci extension | XoxdWM | packaging/tuned/xr-bci/ |
| Compositor + WM code | XoxdWM | compositor/, lisp/ |
| BCI signal processing | XoxdWM | analysis/src/bci/ |
| Monado/Sway/wlroots patches | XoxdWM | patches/, nix/packages/ |
| Boot-apply pipeline | XoxdWM | packaging/scripts/boot-apply |
| Beyond HID/display | XoxdWM | packaging/scripts/beyond-*, honey-phase* |
| Storage migration | XoxdWM | packaging/scripts/honey-storage-migrate |

**Future work (not this session):**
- XoxdWM dhall boot configs could reference Dell-7810 kernel baseline
  params instead of hardcoding SMI mitigation inline
- Platform.dhall (T7810 type-safe platform definition) is a candidate
  to move to Dell-7810 since it's pure hardware description
- honey-storage-migrate is pure hardware but operationally tied to XoxdWM
  deployment; keep there for now

## Verification

- `just platform-xoxdwm-duplication-status` still runs clean
- Both READMEs link to each other
- XoxdWM proof docs have evidence anchors
- Provenance comments are accurate in all derived-fork files
- authority-map.md is the single lookup surface for "which repo owns this?"

## Not in scope

- Moving honey boot dhall configs (operational, tied to XoxdWM deployment)
- Moving honey-storage-migrate (same reason)
- Changing flake.nix dependencies between repos
- Any Chapel code moves (already correct)
- Finishing TIN-339 reset matrix work (separate branch concern)
