# Authority Map: Dell-7810 + XoxdWM

Use this document to answer "which repo owns this surface?" without hunting
through scattered boundary notes.

Last updated: 2026-04-22.

## Dell-7810 authority

These surfaces are canonical in this repo. XoxdWM may reference them but should
not duplicate or independently maintain them.

| Surface | Location | Notes |
| --- | --- | --- |
| Kernel baseline configs | `packaging/kernel/` | Generic T7810 low-latency base + RT overlay + cmdline |
| SMI mitigation and validation | `scripts/platform/smi-validate` | Canonical hardware validator; XoxdWM copy is convenience shim |
| BIOS configuration (cctk) | `scripts/platform/dcc-configure-rt` | Canonical; XoxdWM copy is convenience shim |
| tuned low-latency base profile | `packaging/tuned/t7810-low-latency/` | Generic host tuning; XoxdWM extends with `xr-bci/` |
| Reset matrix | `docs/research/honey-reset-matrix-*.md` | Hardware reset, power, display recovery evidence |
| Power path research | `docs/research/honey-power-reset-*.md` | PSU, distribution board, multi-PSU findings |
| Management display recovery | `docs/research/honey-management-display-*.md` | OOB recovery path design |
| SMI baseline | `docs/platform/t7810-smi-baseline.md` | Imported from XoxdWM; canonical going forward |
| Enclosure and coupon lane | `cad/`, `data/measurements/`, `output/` | Entirely Dell-only; no XoxdWM peer |
| Chapel host characterization | `analysis/src/HostNumaTiming.chpl`, `analysis/src/TimingProofs.chpl` | Dell-only modules |
| Chapel PBT tests | `analysis/test/` | Property-based tests for host invariants |
| Chapel host probe example | `analysis/examples/HostNumaProbe.chpl` | Canonical host-characterization demo |
| Chapel 2.8.0 Nix package | `nix/packages/chapel.nix` | Canonical; XoxdWM copy is fallback |
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
| smi-validate | `scripts/platform/smi-validate` | `packaging/scripts/smi-validate` | Dell is canonical |
| dcc-configure-rt | `scripts/platform/dcc-configure-rt` | `packaging/scripts/dcc-configure-rt` | Dell is canonical |
| tuned profile | `packaging/tuned/t7810-low-latency/` | `packaging/tuned/xr-bci/` | Separate but related; XR extends Dell base |
| chapel.nix | `nix/packages/chapel.nix` | `nix/packages/chapel.nix` | Dell is canonical; XoxdWM is fallback |
| DualSocketDemo.chpl | `analysis/examples/DualSocketDemo.chpl` | `analysis/examples/DualSocketDemo.chpl` | Diverged; Dell version is legacy shim |
| Mason.toml | `analysis/Mason.toml` | `analysis/Mason.toml` | Different project names and scope |

## Future moves (not yet actioned)

- `Platform.dhall`: pure hardware description; candidate to move from XoxdWM to Dell-7810
- `honey-storage-migrate`: pure hardware ops but operationally tied to XoxdWM deployment
- Dhall boot config inheritance: XoxdWM configs hardcode Dell SMI params inline;
  could reference Dell-7810 kernel baseline instead
- Chapel compiler packaging: the sibling `chapel` repo will eventually supersede
  both copies

## How to check

Run `just platform-xoxdwm-duplication-status` to compare derived-fork pairs
and confirm no exact duplicates have re-emerged.
