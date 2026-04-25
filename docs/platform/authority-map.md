# Authority Map: Dell-7810 Host Evidence And Peer Repos

Use this document to answer "which repo owns this surface?" without hunting
through scattered boundary notes.

Last updated: 2026-04-25.

This map started as the Dell-7810 versus `XoxdWM` split. It now also records
the narrow peer-repo boundaries that matter for the RT, SMI, NUMA, Chapel, and
runner workstream.

It does not override the separate Chapel compiler boundary in
[`chapel-sourcing.md`](chapel-sourcing.md), where the dedicated sibling
`chapel` repo remains the preferred long-term compiler home.

It also does not answer whether a surface is actually measured yet. For that,
use [`../tracking/measured-evidence-map.md`](../tracking/measured-evidence-map.md).

## Adjacent repo authority

| Repo | Owns | Does not own |
| --- | --- | --- |
| `tinyland-inc/linux-xr` | `C0` kernel supplier facts: carried patches, RPM build/release surface, install/rollback mechanics, and upstream-watch notes | Dell workstation acceptance, SMI/NUMA/C-state measurements, tuned-profile proof, or Chapel host results |
| `Jesssullivan/XoxdWM` | `C4` downstream software-benefit claims: compositor, XR runtime, BCI software, OpenXR/Monado operator proof, and live `neo -> honey` software workflows | Raw Dell host measurements, BIOS/SMI/C-state acceptance, fan inventory, enclosure measurements, or RT host proof |
| `tinyland-inc/rockies` | Umbrella composition, desktop-stack routing, sanitized cross-repo status, and operator-surface topology | Raw `honey` measurement storage or Dell workstation acceptance |
| `tinyland-inc/GloriousFlywheel` | Shared Nix runner, cache, Attic, Bazel substrate, and dogfood runner product surface | Dell-specific runner fork or Dell host evidence |
| sibling `chapel` repo | Long-term Chapel compiler/toolchain/package authority candidate | Dell host evidence store or `honey` acceptance ledger |

## Dell-7810 authority

These surfaces are canonical in this repo. XoxdWM may reference them but should
not duplicate or independently maintain them.

| Surface | Location | Notes |
| --- | --- | --- |
| Kernel baseline configs | `packaging/kernel/` | Generic T7810 low-latency base + RT overlay + cmdline |
| SMI mitigation and validation | `scripts/platform/smi-validate` | Dell-owned host validator; XoxdWM copy is convenience shim |
| BIOS configuration (cctk) | `scripts/platform/dcc-configure-rt` | Dell-owned host BIOS posture script; XoxdWM copy is convenience shim |
| tuned low-latency base profile | `packaging/tuned/t7810-low-latency/` | Generic host tuning; XoxdWM extends with `xr-bci/` |
| Reset matrix | `docs/research/honey-reset-matrix-*.md` | Hardware reset, power, display recovery evidence |
| Power path research | `docs/research/honey-power-reset-*.md` | PSU, distribution board, multi-PSU findings |
| Management display recovery | `docs/research/honey-management-display-and-recovery-path-2026-04-22.md` | Source-backed recovery-path design note distilled from the reset and power research |
| SMI baseline | `docs/platform/t7810-smi-baseline.md` | Imported from XoxdWM; canonical going forward |
| Enclosure and coupon lane | `cad/`, `data/measurements/`, `output/` | Entirely Dell-only; no XoxdWM peer |
| Declarative host-contract schema | `dhall/` | Narrow host facts and evidence shapes; intentionally not a boot-generation lane |
| Chapel host characterization | `analysis/src/HostNumaTiming.chpl`, `analysis/src/TimingProofs.chpl` | Dell-only modules |
| Chapel PBT tests | `analysis/test/` | Property-based tests for host invariants |
| Chapel host probe example | `analysis/examples/HostNumaProbe.chpl` | Canonical host-characterization demo |
| Chapel repo-local fallback package | `nix/packages/chapel.nix` | Dell-local continuity surface for analysis work; prefer the sibling `chapel` repo for long-term compiler packaging |
| Host kernel baseline validation | `scripts/platform/validate-host-kernel-baseline` | Dell-only |
| NUMA/reset state capture | `scripts/platform/capture-numa-state`, `capture-reset-state` | Dell-only |
| Feature register and measurements | `data/measurements/` | Dell-only |
| Publication boundary docs | `docs/publication/` | Narrative lanes, claim traceability |
| XoxdWM boundary audit | `docs/platform/xoxdwm-boundary-audit.md` | Defines the ownership split |

## XoxdWM authority

These surfaces are canonical in XoxdWM. This repo may reference the downstream
effects but should not duplicate or own them.

| Surface | Location in XoxdWM | Notes |
| --- | --- | --- |
| Compositor + WM code | `compositor/`, `lisp/` | Rust Wayland compositor + Elisp WM |
| BCI signal processing | `analysis/src/bci/` | Epochs, Spectral, BciAnalysis |
| BCI spectral tests | `analysis/test/TestSpectral.chpl` | Application-side PBT |
| XR kernel overlay | `nix/kernel/xr-kernel.nix` | Beyond EDID, DSC, DRM lease patches |
| tuned xr-bci extension | `packaging/tuned/xr-bci/` | BCI-specific isolation extending Dell base |
| honey boot topology (dhall) | `packaging/dhall/defaults/honey-*.dhall` | Stock, XR, and debug boot entries |
| Platform type definition | `packaging/dhall/Platform.dhall` | T7810 type-safe platform model (candidate to move) |
| Boot-apply pipeline | `packaging/scripts/boot-apply` | Dhall to BLS entry generation |
| Beyond HID/display scripts | `packaging/scripts/beyond-*`, `honey-phase*` | VR hardware setup/verification |
| Storage migration | `packaging/scripts/honey-storage-migrate` | NVMe migration ops |
| Monado/Sway/wlroots patches | `patches/`, `nix/packages/monado-beyond.nix` etc. | XR runtime |
| Packaging (RPM, DEB, systemd) | `packaging/rpm/`, `packaging/systemd/`, `packaging/selinux/` | Compositor deployment |
| CI/CD workflows | `.github/workflows/` | 12 workflows for build, test, release |

## Derived forks (both repos, diverging)

These exist in both repos as intentional forks. The Dell-7810 version is
canonical for host-platform concerns.

| Surface | Dell-7810 path | XoxdWM path | Status |
| --- | --- | --- | --- |
| smi-validate | `scripts/platform/smi-validate` | `packaging/scripts/smi-validate` | Dell owns the host-facing copy |
| dcc-configure-rt | `scripts/platform/dcc-configure-rt` | `packaging/scripts/dcc-configure-rt` | Dell owns the host-facing copy |
| tuned profile | `packaging/tuned/t7810-low-latency/` | `packaging/tuned/xr-bci/` | Separate but related; XR extends Dell base |
| chapel.nix | `nix/packages/chapel.nix` | `nix/packages/chapel.nix` | Dell keeps the repo-local fallback; the sibling `chapel` repo is the long-term compiler authority |
| DualSocketDemo.chpl | `analysis/examples/DualSocketDemo.chpl` | `analysis/examples/DualSocketDemo.chpl` | Diverged; Dell version is legacy shim |
| Mason.toml | `analysis/Mason.toml` | `analysis/Mason.toml` | Different project names and scope |

## Future moves (not yet actioned)

- `Platform.dhall`: stable host facts are now partially projected inside
  XoxdWM via `HostFacts.dhall`; decide later whether that projection should
  graduate into a shared schema home
- `honey-storage-migrate`: candidate only for a future host-ops extraction, not
  for a blind move into the Dell-7810 repo
- Dhall boot config inheritance: host timing posture is now partially projected
  inside XoxdWM via `HostTiming.dhall`; keep extracting shared host-baseline
  inputs instead of moving full boot-entry ops here
- Chapel compiler packaging: the sibling `chapel` repo will eventually supersede
  both copies

## How to check

Run `just platform-xoxdwm-duplication-status` to compare derived-fork pairs
and confirm no exact duplicates have re-emerged.
